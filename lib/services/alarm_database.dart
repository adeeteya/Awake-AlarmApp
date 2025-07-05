import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/alarm_db_entry.dart';

class AlarmDatabase {
  static Database? _db;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'alarms.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE alarms(time TEXT PRIMARY KEY, days TEXT)',
        );
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
    return rows.map((e) => AlarmDbEntry.fromMap(e)).toList();
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
