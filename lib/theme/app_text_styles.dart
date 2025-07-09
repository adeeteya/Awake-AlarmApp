import 'dart:ui';

import 'package:awake/extensions/context_extensions.dart';
import 'package:awake/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle body(BuildContext context) => TextStyle(
    color:
        context.isDarkMode
            ? AppColors.darkBackgroundText
            : AppColors.lightBackgroundText,
    fontFamily: 'Poppins',
  );

  static TextStyle heading(BuildContext context) => body(
    context,
  ).copyWith(fontSize: 18, fontWeight: FontWeight.w500, letterSpacing: 0.03);

  static TextStyle bigTime(BuildContext context) => body(context).copyWith(
    fontSize: 34,
    fontWeight: FontWeight.w500,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static TextStyle large(BuildContext context) =>
      body(context).copyWith(fontSize: 24);

  static TextStyle caption(BuildContext context) =>
      body(context).copyWith(fontSize: 12, letterSpacing: 0.03);
}
