import 'package:alarm/alarm.dart';
import 'package:awake/constants.dart';
import 'package:awake/screens/home.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Alarm.init();

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
        dialogTheme: DialogThemeData(
          backgroundColor: lightScaffoldGradient1Color,
        ),
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
        dialogTheme: DialogThemeData(
          backgroundColor: darkScaffoldGradient1Color,
        ),
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
