import 'package:awake/extensions/context_extensions.dart';
import 'package:awake/theme/app_colors.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow_update/flutter_inset_box_shadow_update.dart';

class GradientLinearProgressIndicator extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final double height;

  const GradientLinearProgressIndicator({
    super.key,
    required this.value,
    this.height = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final clampedValue = value.clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final filledWidth = totalWidth * clampedValue;

        return SizedBox(
          height: height + 12, // Padding for shadow visibility
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Inactive Track
              SizedBox(
                height: height,
                width: totalWidth,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? AppColors.shadowDark.withValues(alpha: 0.25)
                            : AppColors.shadowLight.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(height),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(1.5, 1.5),
                        blurRadius: 3,
                        inset: true,
                        color:
                            isDark
                                ? AppColors.shadowDark.withValues(alpha: 0.4)
                                : AppColors.lightBackgroundText.withValues(
                                  alpha: 0.4,
                                ),
                      ),
                    ],
                  ),
                ),
              ),

              // Active Track (Gradient)
              SizedBox(
                height: height,
                width: filledWidth,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                    ),
                    borderRadius: BorderRadius.circular(height),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
