import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../extensions/context_extensions.dart';

class ThemeListTile extends StatelessWidget {
  final ThemeMode mode;
  final ValueChanged<ThemeMode> onChanged;

  const ThemeListTile({
    super.key,
    required this.mode,
    required this.onChanged,
  });

  IconData _iconForMode(ThemeMode m) {
    switch (m) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.phone_iphone;
    }
  }

  ThemeMode _nextMode(ThemeMode m) {
    switch (m) {
      case ThemeMode.system:
        return ThemeMode.light;
      case ThemeMode.light:
        return ThemeMode.dark;
      case ThemeMode.dark:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    final color =
        isDark ? AppColors.darkBackgroundText : AppColors.lightBackgroundText;
    return ListTile(
      title: Text(
        'Theme',
        style: TextStyle(
          color: color,
          fontFamily: 'Poppins',
        ),
      ),
      trailing: Icon(
        _iconForMode(mode),
        color: color,
      ),
      onTap: () => onChanged(_nextMode(mode)),
    );
  }
}
