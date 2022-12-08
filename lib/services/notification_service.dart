import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

const MethodChannel platform = MethodChannel('adeeteya/awake');

class NotificationService {
  static final _localNotifications = FlutterLocalNotificationsPlugin();

  Future init() async {
    initializeTimeZones();
    await _localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings("ic_stat_access_alarms"),
      ),
    );
    _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  Future _notificationDetails() async {
    const int insistentFlag = 4;
    final String? alarmUri = await platform.invokeMethod<String>('getAlarmUri');
    final UriAndroidNotificationSound uriSound =
        UriAndroidNotificationSound(alarmUri!);
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'Awake_Alarm_App',
        'Alarm Notifications',
        icon: 'ic_stat_access_alarms',
        channelDescription: "Creates Alarm Notifications",
        enableLights: true,
        usesChronometer: true,
        ongoing: true,
        visibility: NotificationVisibility.public,
        category: AndroidNotificationCategory.alarm,
        audioAttributesUsage: AudioAttributesUsage.alarm,
        sound: uriSound,
        importance: Importance.max,
        priority: Priority.max,
        actions: const [
          AndroidNotificationAction(
            "id_1",
            "Dismiss",
          )
        ],
        additionalFlags: Int32List.fromList(<int>[insistentFlag]),
      ),
    );
  }

  Future showWeeklyRepeatNotification(int id, DateTime scheduledDate) async {
    _localNotifications.zonedSchedule(
      id,
      "Alarm",
      "Time to Wake Up",
      TZDateTime.from(scheduledDate, local),
      await _notificationDetails(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future showScheduledNotification(int id, DateTime scheduledDate) async {
    _localNotifications.zonedSchedule(
      int.parse("1$id"),
      "Alarm",
      "Time to Wake Up",
      TZDateTime.from(scheduledDate, local),
      await _notificationDetails(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );
  }

  Future cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }
}
