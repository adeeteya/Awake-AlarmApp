import 'package:alarm/alarm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AlarmModel {
  final TimeOfDay timeOfDay;
  final List<int> days;
  final bool enabled;
  final List<AlarmSettings> alarmSettings;

  AlarmModel({
    required this.timeOfDay,
    required this.days,
    this.enabled = true,
    this.alarmSettings = const [],
  });

  @override
  bool operator ==(Object other) {
    return other is AlarmModel &&
        other.timeOfDay == timeOfDay &&
        listEquals(other.days, days) &&
        other.enabled == enabled &&
        listEquals(other.alarmSettings, alarmSettings);
  }

  @override
  int get hashCode => Object.hash(timeOfDay, days, enabled, alarmSettings);

  @override
  String toString() {
    return 'AlarmModel(timeOfDay: $timeOfDay, days: $days, enabled: $enabled, alarmSettings: $alarmSettings)';
  }
}
