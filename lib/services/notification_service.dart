import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

class NotificationService {
  static final _localNotifications = FlutterLocalNotificationsPlugin();

  Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'Awake_Alarm_App',
        'Alarm Notifications',
        icon: 'ic_stat_access_alarms',
        enableLights: true,
        usesChronometer: true,
        ongoing: true,
        visibility: NotificationVisibility.public,
        category: AndroidNotificationCategory.alarm,
        audioAttributesUsage: AudioAttributesUsage.alarm,
        channelDescription: "Reminds all the appointments added by the user ",
        importance: Importance.max,
        priority: Priority.max,
        actions: [
          AndroidNotificationAction(
            "id_1",
            "Dismiss",
          )
        ],
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

  Future cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }
}
