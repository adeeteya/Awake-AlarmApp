import 'package:awake/models/alarm_db_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('toMap and fromMap should be inverses', () {
    final entry = AlarmDbEntry(
      time: const TimeOfDay(hour: 7, minute: 30),
      days: const [DateTime.monday, DateTime.friday],
      enabled: false,
      body: 'Morning alarm',
    );

    final map = entry.toMap();
    final restored = AlarmDbEntry.fromMap(map);

    expect(restored.time, entry.time);
    expect(restored.days, entry.days);
    expect(restored.enabled, entry.enabled);
    expect(restored.body, entry.body);
  });

  test('fromMap handles missing fields', () {
    final restored = AlarmDbEntry.fromMap({'time': '6:15'});

    expect(restored.time, const TimeOfDay(hour: 6, minute: 15));
    expect(restored.days, isEmpty);
    expect(restored.enabled, isTrue);
    expect(restored.body, '');
  });
}
