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
    final isAutoStartEnabled =
        await DisableBatteryOptimization.isAutoStartEnabled;
    if (isAutoStartEnabled == false) {
      await DisableBatteryOptimization.showEnableAutoStartSettings(
        "Enable Auto Start",
        "Follow the steps and enable the auto start of this app to show alarms",
      );
    }
  }

  static Future<void> checkBatteryOptimization() async {
    final isBatteryOptimizationDisabled =
        await DisableBatteryOptimization.isBatteryOptimizationDisabled;
    if (isBatteryOptimizationDisabled == false) {
      await DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
    }
  }
}
