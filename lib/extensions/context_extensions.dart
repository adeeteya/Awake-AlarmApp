import 'package:flutter/material.dart';

extension ThemeModeContext on BuildContext {
  bool get isDarkMode => Theme.brightnessOf(this) == Brightness.dark;
}
