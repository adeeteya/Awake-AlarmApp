import 'package:awake/extensions/context_extensions.dart';
import 'package:awake/theme/app_colors.dart';
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
    return GestureDetector(
      onTap: () => onChanged(_nextMode(mode)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isDark
                    ? [AppColors.darkBorder, AppColors.darkScaffold2]
                    : [Colors.white, AppColors.lightScaffold2],
          ),
          boxShadow:
              isDark
                  ? [
                    BoxShadow(
                      offset: const Offset(-5, -5),
                      blurRadius: 20,
                      color: AppColors.darkGrey.withValues(alpha: 0.35),
                    ),
                    BoxShadow(
                      offset: const Offset(13, 14),
                      blurRadius: 12,
                      spreadRadius: -6,
                      color: AppColors.shadowDark.withValues(alpha: 0.70),
                    ),
                  ]
                  : [
                    BoxShadow(
                      offset: const Offset(-5, -5),
                      blurRadius: 20,
                      color: Colors.white.withValues(alpha: 0.53),
                    ),
                    BoxShadow(
                      offset: const Offset(13, 14),
                      blurRadius: 12,
                      spreadRadius: -6,
                      color: AppColors.shadowLight.withValues(alpha: 0.57),
                    ),
                  ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: SizedBox(
            height: 74,
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors:
                      isDark
                          ? [AppColors.darkClock1, AppColors.darkScaffold1]
                          : [
                            AppColors.lightScaffold1,
                            AppColors.lightGradient2,
                          ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Text(
                      'Theme',
                      style: TextStyle(color: color, fontFamily: 'Poppins'),
                    ),
                    const Spacer(),
                    Icon(_iconForMode(mode), color: color),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
