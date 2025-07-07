import 'package:awake/extensions/context_extensions.dart';
import 'package:awake/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const SettingsTile({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    final outerColors = isDark
        ? [AppColors.darkBorder, AppColors.darkScaffold2]
        : [Colors.white, AppColors.lightScaffold2];
    final innerColors = isDark
        ? [AppColors.darkClock1, AppColors.darkScaffold1]
        : [AppColors.lightScaffold1, AppColors.lightGradient2];
    final boxShadows = isDark
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
          ];

    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: outerColors,
          ),
          boxShadow: boxShadows,
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
                  colors: innerColors,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
