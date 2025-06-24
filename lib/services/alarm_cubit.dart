import 'package:alarm/alarm.dart';
import 'package:awake/models/alarm_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlarmCubit extends Cubit<List<AlarmModel>> {
  AlarmCubit() : super([]) {
    _loadAlarms();
  }

  Future<void> _loadAlarms() async {
    final updatedAlarms = await Alarm.getAlarms();
    final Map<TimeOfDay, List<AlarmSettings>> alarmSettingsSet = {};
    for (final alarm in updatedAlarms) {
      final alarmTime = TimeOfDay.fromDateTime(alarm.dateTime);
      if (alarmSettingsSet.containsKey(alarmTime)) {
        alarmSettingsSet[alarmTime]?.add(alarm);
      } else {
        alarmSettingsSet[alarmTime] = [alarm];
      }
    }
    final tempAlarms = <AlarmModel>[];
    for (final key in alarmSettingsSet.keys) {
      tempAlarms.add(
        AlarmModel(timeOfDay: key, alarmSettings: alarmSettingsSet[key] ?? []),
      );
    }
    emit(tempAlarms);
  }

  Future<AlarmSettings?> _setAlarm(int id, DateTime scheduledDate) async {
    try {
      final alarmSetting = AlarmSettings(
        id: id,
        dateTime: scheduledDate,
        assetAudioPath: "assets/alarm_ringtone.mp3",
        volumeSettings: VolumeSettings.fixed(
          volume: 1.0,
          volumeEnforced: false,
        ),
        notificationSettings: NotificationSettings(
          title: "Alarm",
          body: "Time to Wake Up",
          stopButton: 'Stop',
          icon: 'notification_icon',
          iconColor: Color(0xFFFFFFFF),
        ),
      );
      final alarmSet = await Alarm.set(alarmSettings: alarmSetting);
      if (alarmSet) {
        return alarmSetting;
      }
    } catch (e) {
      debugPrint("Error setting alarm: $e");
    }
    return null;
  }

  Future<void> setPeriodicAlarms({
    required TimeOfDay timeOfDay,
    List<int> days = const [
      DateTime.monday,
      DateTime.tuesday,
      DateTime.wednesday,
      DateTime.thursday,
      DateTime.friday,
      DateTime.saturday,
      DateTime.sunday,
    ],
  }) async {
    final now = DateTime.now();
    final List<AlarmSettings> newAlarmSettings = [];
    // Loop through the next days
    for (var i = 0; i < 7; i++) {
      if (i == 0 &&
          (now.hour > timeOfDay.hour ||
              (now.hour == timeOfDay.hour && now.minute >= timeOfDay.minute))) {
        // If the time is already passed for today, skip it
        continue;
      }
      final dateTime = DateTime(
        now.year,
        now.month,
        now.day,
        timeOfDay.hour,
        timeOfDay.minute,
      ).add(Duration(days: i));

      if (days.contains(dateTime.weekday)) {
        final newAlarm = await _setAlarm(
          dateTime.millisecondsSinceEpoch.hashCode,
          dateTime,
        );
        if (newAlarm != null) {
          newAlarmSettings.add(newAlarm);
        }
      }
    }
    final newAlarmModel = AlarmModel(
      timeOfDay: timeOfDay,
      alarmSettings: newAlarmSettings,
    );
    if (!state.contains(newAlarmModel)) {
      emit([...state, newAlarmModel]);
    }
  }

  Future<void> _cancelAlarm(int id) async {
    await Alarm.stop(id);
  }

  Future<void> deleteAlarmModel(AlarmModel alarmModel) async {
    for (final alarm in alarmModel.alarmSettings) {
      await _cancelAlarm(alarm.id);
    }
    emit(state.where((e) => e != alarmModel).toList());
  }
}
