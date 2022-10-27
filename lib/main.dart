import 'package:awake/constants.dart';
import 'package:awake/screens/home.dart';
import 'package:awake/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

void main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await NotificationService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Awake- The Alarm Clock',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorSchemeSeed: primaryColor,
        dialogBackgroundColor: lightScaffoldGradient1Color,
        timePickerTheme: const TimePickerThemeData(
          backgroundColor: lightScaffoldGradient1Color,
          hourMinuteTextColor: lightBackgroundTextColor,
          dayPeriodTextColor: lightBackgroundTextColor,
          entryModeIconColor: lightBackgroundTextColor,
          dialTextColor: lightBackgroundTextColor,
          helpTextStyle: TextStyle(
            color: darkBackgroundTextColor,
            fontFamily: "Poppins",
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: primaryAlternateColor,
        dialogBackgroundColor: darkScaffoldGradient1Color,
        timePickerTheme: const TimePickerThemeData(
          backgroundColor: darkScaffoldGradient2Color,
          hourMinuteTextColor: darkBackgroundTextColor,
          dayPeriodTextColor: darkBackgroundTextColor,
          dialTextColor: darkBackgroundTextColor,
          entryModeIconColor: darkBackgroundTextColor,
          dialBackgroundColor: darkScaffoldGradient1Color,
          helpTextStyle: TextStyle(
            color: darkBackgroundTextColor,
            fontFamily: "Poppins",
          ),
        ),
      ),
      home: const Home(),
    );
  }
}
