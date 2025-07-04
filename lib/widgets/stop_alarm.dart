import 'package:flutter/material.dart';
import 'package:awake/theme/app_colors.dart';
import 'dart:math' as math;

class StopButton extends StatelessWidget {
  const StopButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              (isDark)
                  ? [AppColors.darkGradient1, AppColors.darkGradient2]
                  : [AppColors.lightGradient1, AppColors.lightGradient2],
        ),
        boxShadow:
            (isDark)
                ? [
                  BoxShadow(
                    offset: const Offset(-5, -5),
                    blurRadius: 20,
                    color: AppColors.darkGrey.withOpacity(0.35),
                  ),
                  BoxShadow(
                    offset: const Offset(5, 5),
                    blurRadius: 10,
                    color: AppColors.shadowDark.withOpacity(0.7),
                  ),
                ]
                : [
                  BoxShadow(
                    offset: const Offset(-5, -5),
                    blurRadius: 10,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  BoxShadow(
                    offset: const Offset(5, 5),
                    blurRadius: 10,
                    color: AppColors.shadowLight.withOpacity(0.7),
                  ),
                ],
        shape: BoxShape.circle,
      ),
      child: CustomPaint(
        size: const Size(78, 78),
        painter: StopButtonPainter(isDark),
      ),
    );
  }
}

class StopButtonPainter extends CustomPainter {
  final bool isDark;

  StopButtonPainter(this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rectOuter = Offset.zero & size;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Paint xPaint = Paint()..color = AppColors.lightSurface;

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

    Path semiOvalBottomRight =
        Path()..addArc(
          Rect.fromCenter(center: center, width: 74, height: 74),
          -math.pi / 3,
          math.pi,
        );
    canvas.drawShadow(
      semiOvalBottomRight,
      AppColors.primary.withOpacity(0.35),
      11,
      true,
    );

    canvas.drawCircle(center, 31.5, sphereInset2);
    canvas.drawCircle(center, 30, sphere1);
    canvas.drawCircle(center, 28, sphereInset1);

    const double barLength = 18;
    const double barWidth = 4;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(math.pi / 4); // 45 degrees
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: barLength, height: barWidth),
      xPaint,
    );
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: barWidth, height: barLength),
      xPaint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
