import 'package:awake/extensions/context_extensions.dart';
import 'package:awake/theme/app_colors.dart';
import 'package:awake/theme/app_text_styles.dart';
import 'package:awake/widgets/settings_tile.dart';
import 'package:flutter/material.dart';

class ThemeListTile extends StatelessWidget {
  final ThemeMode mode;
  final ValueChanged<ThemeMode> onChanged;

  const ThemeListTile({super.key, required this.mode, required this.onChanged});

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
    return SettingsTile(
      onTap: () => onChanged(_nextMode(mode)),
      child: Row(
        children: [
          Text('Theme', style: AppTextStyles.body(context)),
          const Spacer(),
          Icon(_iconForMode(mode), color: color),
        ],
      ),
    );
  }
}
