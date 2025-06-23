import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

class AlarmService {
  Future _setAlarm(int id, DateTime scheduledDate) async {
    await Alarm.set(
      alarmSettings: AlarmSettings(
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
      ),
    );
  }

  Future<void> setPeriodicAlarms({
    required TimeOfDay time,
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
    const nbDays = 7;
    final now = DateTime.now();
    // Loop through the next days
    for (var i = 0; i < nbDays; i++) {
      if (i == 0 &&
          (now.hour > time.hour ||
              (now.hour == time.hour && now.minute >= time.minute))) {
        // If the time is already passed for today, skip it
        continue;
      }
      final dateTime = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      ).add(Duration(days: i));

      if (days.contains(dateTime.weekday)) {
        _setAlarm(dateTime.day, dateTime);
      }
    }
  }

  Future cancelAlarm(int id) async {
    await Alarm.stop(id);
  }
}
