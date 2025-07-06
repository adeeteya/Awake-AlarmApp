import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:awake/models/alarm_db_entry.dart';
import 'package:awake/models/alarm_model.dart';
import 'package:awake/services/alarm_database.dart';
import 'package:awake/services/shared_prefs_with_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlarmCubit extends Cubit<List<AlarmModel>> {
  AlarmCubit() : super([]) {
    unawaited(_loadAlarms());
  }

  Future<void> _loadAlarms({List<AlarmSettings>? presetAlarms}) async {
    final dbEntries = await AlarmDatabase.allAlarms();
    final existingAlarms = presetAlarms ?? await Alarm.getAlarms();
    final Map<TimeOfDay, List<AlarmSettings>> alarmSettingsSet = {};
    for (final alarm in existingAlarms) {
      final alarmTime = TimeOfDay.fromDateTime(alarm.dateTime);
      alarmSettingsSet.putIfAbsent(alarmTime, () => []).add(alarm);
    }

    for (final entry in dbEntries) {
      if (entry.enabled) {
        await _ensureUpcomingWeek(entry.time, entry.days, alarmSettingsSet);
      } else {
        alarmSettingsSet.putIfAbsent(entry.time, () => []);
      }
    }

    final tempAlarms = <AlarmModel>[];
    for (final entry in dbEntries) {
      final alarms = alarmSettingsSet[entry.time] ?? [];
      tempAlarms.add(
        AlarmModel(
          timeOfDay: entry.time,
          days: entry.days,
          enabled: entry.enabled,
          alarmSettings: alarms,
        ),
      );
    }
    emit(tempAlarms);
  }

  Future<AlarmSettings?> _setAlarm(int id, DateTime scheduledDate) async {
    try {
      final vibrate =
          (SharedPreferencesWithCache.instance.get<int>('vibrationEnabled') ??
              1) ==
          1;
      final fadeIn =
          (SharedPreferencesWithCache.instance.get<int>('fadeInAlarm') ?? 0) ==
          1;
      final volume =
          SharedPreferencesWithCache.instance.get<double>('alarmVolume') ?? 1.0;
      final volumeSettings =
          fadeIn
              ? VolumeSettings.fade(
                fadeDuration: const Duration(seconds: 5),
                volume: volume,
              )
              : VolumeSettings.fixed(volume: volume);
      final alarmSetting = AlarmSettings(
        id: id,
        dateTime: scheduledDate,
        assetAudioPath: "assets/alarm_ringtone.mp3",
        vibrate: vibrate,
        volumeSettings: volumeSettings,
        notificationSettings: const NotificationSettings(
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
      final exists =
          current[timeOfDay]?.any(
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
    final updatedDays = {...(existingEntry?.days ?? []), ...days}.toList();
    final enabled = existingEntry?.enabled ?? true;

    await AlarmDatabase.insertOrUpdate(
      AlarmDbEntry(time: timeOfDay, days: updatedDays, enabled: enabled),
    );

    if (enabled) {
      final existing = await Alarm.getAlarms();
      final Map<TimeOfDay, List<AlarmSettings>> current = {};
      for (final alarm in existing) {
        final alarmTime = TimeOfDay.fromDateTime(alarm.dateTime);
        current.putIfAbsent(alarmTime, () => []).add(alarm);
      }
      await _ensureUpcomingWeek(timeOfDay, updatedDays, current);
      await _loadAlarms(presetAlarms: current.values.expand((e) => e).toList());
    } else {
      await _loadAlarms();
    }
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

  Future<void> toggleAlarmEnabled(TimeOfDay timeOfDay, bool enabled) async {
    final entry = await AlarmDatabase.getAlarm(timeOfDay);
    if (entry == null) return;
    await AlarmDatabase.insertOrUpdate(
      AlarmDbEntry(time: timeOfDay, days: entry.days, enabled: enabled),
    );

    if (!enabled) {
      final existing = await Alarm.getAlarms();
      final remaining = <AlarmSettings>[];
      for (final alarm in existing) {
        if (TimeOfDay.fromDateTime(alarm.dateTime) == timeOfDay) {
          await stopAlarm(alarm.id);
        } else {
          remaining.add(alarm);
        }
      }
      await _loadAlarms(presetAlarms: remaining);
    } else {
      await _loadAlarms();
    }
  }

  Future<void> updateAlarmDays(TimeOfDay timeOfDay, List<int> days) async {
    final entry = await AlarmDatabase.getAlarm(timeOfDay);
    final bool enabled = days.isNotEmpty && (entry?.enabled ?? true);
    await AlarmDatabase.insertOrUpdate(
      AlarmDbEntry(time: timeOfDay, days: days, enabled: enabled),
    );

    final existing = await Alarm.getAlarms();
    final Map<TimeOfDay, List<AlarmSettings>> current = {};
    for (final alarm in existing) {
      final alarmTime = TimeOfDay.fromDateTime(alarm.dateTime);
      if (alarmTime == timeOfDay) {
        await stopAlarm(alarm.id);
      } else {
        current.putIfAbsent(alarmTime, () => []).add(alarm);
      }
    }

    if (enabled) {
      await _ensureUpcomingWeek(timeOfDay, days, current);
    }

    await _loadAlarms(presetAlarms: current.values.expand((e) => e).toList());
  }

  Future<void> updateVibrationForAll(bool vibrate) async {
    final alarms = await Alarm.getAlarms();
    for (final alarm in alarms) {
      await Alarm.set(alarmSettings: alarm.copyWith(vibrate: vibrate));
    }
    await _loadAlarms();
  }

  Future<void> updateVolumeSettingsForAll({
    required bool fadeIn,
    required double volume,
  }) async {
    final alarms = await Alarm.getAlarms();
    final volumeSettings =
        fadeIn
            ? VolumeSettings.fade(
              fadeDuration: const Duration(seconds: 5),
              volume: volume,
            )
            : VolumeSettings.fixed(volume: volume);
    for (final alarm in alarms) {
      await Alarm.set(
        alarmSettings: alarm.copyWith(volumeSettings: volumeSettings),
      );
    }
    await _loadAlarms();
  }
}
