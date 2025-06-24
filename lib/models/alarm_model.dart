import 'package:alarm/alarm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AlarmModel {
  final TimeOfDay timeOfDay;
  final List<AlarmSettings> alarmSettings;

  AlarmModel({required this.timeOfDay, this.alarmSettings = const []});

  @override
  bool operator ==(Object other) {
    return other is AlarmModel &&
        other.timeOfDay == timeOfDay &&
        listEquals(other.alarmSettings, alarmSettings);
  }

  @override
  int get hashCode => Object.hash(timeOfDay, alarmSettings);

  @override
  String toString() {
    return 'AlarmModel(timeOfDay: $timeOfDay,alarmSettings: $alarmSettings)';
  }
}
