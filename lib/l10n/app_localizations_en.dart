// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Awake- The Alarm Clock';

  @override
  String get addAlarm => 'Add Alarm';

  @override
  String get editAlarm => 'Edit Alarm';

  @override
  String get noAlarms => 'No Alarms Added Yet';

  @override
  String get alarms => 'Alarms';

  @override
  String get settings => 'Settings';

  @override
  String get back => 'Back';

  @override
  String get delete => 'Delete';

  @override
  String get deleteAlarm => 'Delete Alarm';

  @override
  String get deleteAlarmPrompt => 'Are you sure you want to delete this alarm?';

  @override
  String get cancel => 'Cancel';

  @override
  String get titleLabel => 'Title';

  @override
  String get wrongAnswer => 'Wrong answer';

  @override
  String alarmSnoozed(Object minutes) {
    return 'Alarm snoozed for $minutes minutes';
  }

  @override
  String get scanQrInstruction => 'Scan the QR Code';

  @override
  String get wrongQr => 'Wrong QR Code. Please scan the correct one.';

  @override
  String get shakePhone => 'Shake the phone!';

  @override
  String shakesCount(Object count, Object required) {
    return 'Shakes: $count / $required';
  }

  @override
  String get tapScreen => 'Tap the screen!';

  @override
  String tapsCount(Object count, Object required) {
    return 'Taps: $count / $required';
  }

  @override
  String get downloadQr => 'Download QR Code';

  @override
  String fileSaved(Object path) {
    return 'File saved to $path';
  }

  @override
  String get cameraPermissionRequired =>
      'Camera permission is required for QR Code Scan';

  @override
  String get vibration => 'Vibration';

  @override
  String get fadeIn => 'Gradual Fade In';

  @override
  String get alarmScreen => 'Alarm Screen';

  @override
  String get defaultOption => 'Default';

  @override
  String get mathChallenge => 'Math Challenge';

  @override
  String get shakeToStop => 'Shake to Stop';

  @override
  String get tapChallenge => 'Tap Challenge';

  @override
  String get qrCodeScan => 'QR Code Scan';

  @override
  String get alarmSound => 'Alarm Sound';

  @override
  String get addSound => 'Add Sound';

  @override
  String get clearCustomSounds => 'Clear Custom Sounds';

  @override
  String get format24h => '24-Hour Format';

  @override
  String snoozeLabel(Object minutes) {
    return 'Snooze: $minutes min';
  }

  @override
  String solve(Object a, Object b, Object symbol) {
    return 'Solve: $a $symbol $b = ';
  }

  @override
  String numberLabel(Object label) {
    return 'Number $label';
  }

  @override
  String get deleteLabel => 'Delete';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';
}
