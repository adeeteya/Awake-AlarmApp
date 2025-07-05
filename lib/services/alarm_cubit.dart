import 'package:alarm/alarm.dart';
import 'package:awake/models/alarm_model.dart';
import 'package:awake/models/alarm_db_entry.dart';
import 'package:awake/services/alarm_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlarmCubit extends Cubit<List<AlarmModel>> {
  AlarmCubit() : super([]) {
    _loadAlarms();
  }

  Future<void> _loadAlarms() async {
    final dbEntries = await AlarmDatabase.allAlarms();
    final existingAlarms = await Alarm.getAlarms();
    final Map<TimeOfDay, List<AlarmSettings>> alarmSettingsSet = {};
    for (final alarm in existingAlarms) {
      final alarmTime = TimeOfDay.fromDateTime(alarm.dateTime);
      alarmSettingsSet.putIfAbsent(alarmTime, () => []).add(alarm);
    }

    for (final entry in dbEntries) {
      await _ensureUpcomingWeek(entry.time, entry.days, alarmSettingsSet);
    }

    final tempAlarms = <AlarmModel>[];
    alarmSettingsSet.forEach((key, value) {
      tempAlarms.add(AlarmModel(timeOfDay: key, alarmSettings: value));
    });
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
          iconColor: Colors.white,
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

  Future<void> _ensureUpcomingWeek(
    TimeOfDay timeOfDay,
    List<int> days,
    Map<TimeOfDay, List<AlarmSettings>> current,
  ) async {
    final now = DateTime.now();
    for (var i = 0; i < 7; i++) {
      final dateTime = DateTime(
        now.year,
        now.month,
        now.day,
        timeOfDay.hour,
        timeOfDay.minute,
      ).add(Duration(days: i));

      if (!days.contains(dateTime.weekday)) continue;
      if (i == 0 &&
          (now.hour > timeOfDay.hour ||
              (now.hour == timeOfDay.hour && now.minute >= timeOfDay.minute))) {
        continue;
      }
      final exists = current[timeOfDay]?.any(
            (a) =>
                a.dateTime.year == dateTime.year &&
                a.dateTime.month == dateTime.month &&
                a.dateTime.day == dateTime.day,
          ) ??
          false;
      if (!exists) {
        final newAlarm = await _setAlarm(
          dateTime.millisecondsSinceEpoch.hashCode,
          dateTime,
        );
        if (newAlarm != null) {
          current.putIfAbsent(timeOfDay, () => []).add(newAlarm);
        }
      }
    }
  }

  Future<void> snoozeAlarm({
    required AlarmSettings alarmSettings,
    int snoozeMinutes = 5,
  }) async {
    await Alarm.set(
      alarmSettings: alarmSettings.copyWith(
        dateTime: DateTime.now().add(Duration(minutes: snoozeMinutes)),
      ),
    );
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
    final existingEntry = await AlarmDatabase.getAlarm(timeOfDay);
    final updatedDays = {
      ...(existingEntry?.days ?? []),
      ...days,
    }.toList();

    await AlarmDatabase.insertOrUpdate(
      AlarmDbEntry(time: timeOfDay, days: updatedDays),
    );

    final Map<TimeOfDay, List<AlarmSettings>> current = {
      for (final m in state) m.timeOfDay: [...m.alarmSettings]
    };

    await _ensureUpcomingWeek(timeOfDay, updatedDays, current);

    final tempAlarms = <AlarmModel>[];
    current.forEach((key, value) {
      tempAlarms.add(AlarmModel(timeOfDay: key, alarmSettings: value));
    });
    emit(tempAlarms);
  }

  Future<void> stopAlarm(int id) async {
    await Alarm.stop(id);
  }

  Future<void> deleteAlarmModel(AlarmModel alarmModel) async {
    for (final alarm in alarmModel.alarmSettings) {
      await stopAlarm(alarm.id);
    }
    await AlarmDatabase.delete(alarmModel.timeOfDay);
    emit(state.where((e) => e != alarmModel).toList());
  }
}
