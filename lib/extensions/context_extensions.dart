import 'package:awake/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  bool get isDarkMode => Theme.brightnessOf(this) == Brightness.dark;

  AppLocalizations get localization {
    return AppLocalizations.of(this)!;
  }
}
