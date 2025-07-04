import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
        colorSchemeSeed: AppColors.primary,
        dialogTheme: const DialogTheme(
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
        colorSchemeSeed: AppColors.primaryAlt,
        dialogTheme: const DialogTheme(
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
