import 'package:awake/models/alarm_db_entry.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class AlarmDatabase {
  static Database? _db;

  static Future<void> initialize() async {
    final dir = await getDatabasesPath();
    final path = '$dir/alarms.db';
    _db = await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE alarms(time TEXT PRIMARY KEY, days TEXT, enabled INTEGER, body TEXT)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2 && newVersion >= 2) {
          await db.execute(
            'ALTER TABLE alarms ADD COLUMN enabled INTEGER DEFAULT 1',
          );
        }
        if (oldVersion < 3 && newVersion >= 3) {
          await db.execute(
            "ALTER TABLE alarms ADD COLUMN body TEXT DEFAULT ''",
          );
        }
      },
    );
  }

  static Database get _database {
    final database = _db;
    if (database == null) {
      throw Exception('AlarmDatabase not initialized');
    }
    return database;
  }

  static Future<List<AlarmDbEntry>> allAlarms() async {
    final rows = await _database.query('alarms');
    return rows.map(AlarmDbEntry.fromMap).toList();
  }

  static Future<AlarmDbEntry?> getAlarm(TimeOfDay time) async {
    final key = '${time.hour}:${time.minute}';
    final rows = await _database.query(
      'alarms',
      where: 'time = ?',
      whereArgs: [key],
    );
    if (rows.isEmpty) return null;
    return AlarmDbEntry.fromMap(rows.first);
  }

  static Future<void> insertOrUpdate(AlarmDbEntry entry) async {
    await _database.insert(
      'alarms',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> delete(TimeOfDay time) async {
    final key = '${time.hour}:${time.minute}';
    await _database.delete('alarms', where: 'time = ?', whereArgs: [key]);
  }
}
