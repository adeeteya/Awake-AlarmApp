import 'package:alarm/alarm.dart';
import 'package:flutter/services.dart';

class AlarmService {
  Future setAlarm(int id, DateTime scheduledDate) async {
    await Alarm.set(
      alarmSettings: AlarmSettings(
        id: id,
        dateTime: scheduledDate,
        assetAudioPath: "assets/alarm_ringtone.mp3",
        volumeSettings: VolumeSettings.fixed(volume: 1.0, volumeEnforced: true),
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

  Future cancelAlarm(int id) async {
    await Alarm.stop(id);
  }
}
