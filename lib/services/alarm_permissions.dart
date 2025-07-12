import 'package:alarm/alarm.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmPermissions {
  static Future<void> checkNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
  }

  static Future<void> checkAndroidScheduleExactAlarmPermission() async {
    if (!Alarm.android) return;
    final status = await Permission.scheduleExactAlarm.status;
    if (status.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  static Future<bool> checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }
    return status.isGranted;
  }

  static Future<void> checkAutoStartPermission() async {
    final isAvailable = await DisableBatteryOptimization.isAutoStartEnabled;
    if (isAvailable ?? false) {
      await DisableBatteryOptimization.showEnableAutoStartSettings(
        "Enable Auto Start",
        "Follow the steps and enable the auto start of this app to show alarms",
      );
    }
  }
}
