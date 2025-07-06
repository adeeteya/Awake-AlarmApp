import 'package:flutter/material.dart';

class AlarmDbEntry {
  final TimeOfDay time;
  final List<int> days;
  final bool enabled;

  AlarmDbEntry({required this.time, required this.days, this.enabled = true});

  Map<String, dynamic> toMap() {
    final timeString = '${time.hour}:${time.minute}';
    return {
      'time': timeString,
      'days': days.join(','),
      'enabled': enabled ? 1 : 0,
    };
  }

  factory AlarmDbEntry.fromMap(Map<String, dynamic> map) {
    final parts = (map['time'] as String).split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final daysString = map['days'] as String? ?? '';
    final dayList =
        daysString.isEmpty
            ? <int>[]
            : daysString.split(',').map(int.parse).toList();
    final enabled = (map['enabled'] as int?) ?? 1;
    return AlarmDbEntry(
      time: TimeOfDay(hour: hour, minute: minute),
      days: dayList,
      enabled: enabled == 1,
    );
  }
}
