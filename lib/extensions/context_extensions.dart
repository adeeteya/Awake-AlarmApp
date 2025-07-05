import 'package:flutter/material.dart';

extension ThemeModeContext on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
