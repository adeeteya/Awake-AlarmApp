import 'package:awake/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    colorSchemeSeed: AppColors.primary,
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.lightScaffold1,
    ),
    timePickerTheme: const TimePickerThemeData(
      backgroundColor: AppColors.lightScaffold1,
      hourMinuteTextColor: AppColors.lightBackgroundText,
      dayPeriodTextColor: AppColors.lightBackgroundText,
      entryModeIconColor: AppColors.lightBackgroundText,
      dialTextColor: AppColors.lightBackgroundText,
      helpTextStyle: TextStyle(
        color: AppColors.darkBackgroundText,
        fontFamily: 'Poppins',
      ),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    colorSchemeSeed: AppColors.primaryAlt,
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.darkScaffold1,
    ),
    timePickerTheme: const TimePickerThemeData(
      backgroundColor: AppColors.darkScaffold2,
      hourMinuteTextColor: AppColors.darkBackgroundText,
      dayPeriodTextColor: AppColors.darkBackgroundText,
      dialTextColor: AppColors.darkBackgroundText,
      entryModeIconColor: AppColors.darkBackgroundText,
      dialBackgroundColor: AppColors.darkScaffold1,
      helpTextStyle: TextStyle(
        color: AppColors.darkBackgroundText,
        fontFamily: 'Poppins',
      ),
    ),
  );
}
