import 'package:flutter/material.dart';

class AlarmDbEntry {
  final TimeOfDay time;
  final List<int> days;

  AlarmDbEntry({required this.time, required this.days});

  Map<String, dynamic> toMap() {
    final timeString = '${time.hour}:${time.minute}';
    return {
      'time': timeString,
      'days': days.join(','),
    };
  }

  factory AlarmDbEntry.fromMap(Map<String, dynamic> map) {
    final parts = (map['time'] as String).split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final daysString = map['days'] as String? ?? '';
    final dayList = daysString.isEmpty
        ? <int>[]
        : daysString.split(',').map(int.parse).toList();
    return AlarmDbEntry(
      time: TimeOfDay(hour: hour, minute: minute),
      days: dayList,
    );
  }
}
