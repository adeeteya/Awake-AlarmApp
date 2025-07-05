import 'dart:math' as math;

import 'package:awake/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? [AppColors.darkGradient1, AppColors.darkGradient2]
                  : [AppColors.lightGradient1, AppColors.lightGradient2],
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
                    offset: const Offset(5, 5),
                    blurRadius: 10,
                    color: AppColors.shadowDark.withValues(alpha: 0.7),
                  ),
                ]
                : [
                  BoxShadow(
                    offset: const Offset(-5, -5),
                    blurRadius: 10,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  BoxShadow(
                    offset: const Offset(5, 5),
                    blurRadius: 10,
                    color: AppColors.shadowLight.withValues(alpha: 0.7),
                  ),
                ],
        shape: BoxShape.circle,
      ),
      child: CustomPaint(
        size: const Size(78, 78),
        painter: AddButtonPainter(isDark),
      ),
    );
  }
}

class AddButtonPainter extends CustomPainter {
  final bool isDark;

  AddButtonPainter(this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rectOuter = Offset.zero & size;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Paint rectangle = Paint()..color = AppColors.lightSurface;
    final Paint sphere1 =
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryLight],
          ).createShader(rectOuter);
    final Paint sphereInset1 =
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryLight, AppColors.accentDark],
          ).createShader(rectOuter);
    final Paint sphereInset2 =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isDark
                    ? [AppColors.darkBorder, AppColors.darkDeep]
                    : [AppColors.shadowLight, AppColors.lightBlueGrey],
          ).createShader(rectOuter);
    final Path semiOvalBottomRight =
        Path()..addArc(
          Rect.fromCenter(center: center, width: 74, height: 74),
          -math.pi / 3,
          math.pi,
        );
    canvas.drawShadow(
      semiOvalBottomRight,
      AppColors.primary.withValues(alpha: 0.35),
      11,
      true,
    );

    canvas.drawCircle(center, 31.5, sphereInset2);
    canvas.drawCircle(center, 30, sphere1);
    canvas.drawCircle(center, 28, sphereInset1);
    canvas.drawRect(
      Rect.fromCenter(center: center, width: 18, height: 4),
      rectangle,
    );
    canvas.drawRect(
      Rect.fromCenter(center: center, width: 4, height: 18),
      rectangle,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
