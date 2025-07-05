import 'dart:async';
import 'dart:math' as math;

import 'package:awake/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ClockWidget extends StatefulWidget {
  const ClockWidget({super.key});

  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomPaint(
      size: Size.infinite,
      willChange: true,
      painter: ClockPainter(isDark),
    );
  }
}

class ClockPainter extends CustomPainter {
  DateTime dateTime = DateTime.now();
  final bool isDark;

  ClockPainter(this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rectOuter = Offset.zero & size;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final Offset center = Offset(centerX, centerY);
    final double radius = math.min(centerX, centerY);

    final Paint clockBackgroundPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                isDark
                    ? [AppColors.darkScaffold1, AppColors.darkScaffold2]
                    : [AppColors.lightClock2, AppColors.lightClock1],
          ).createShader(rectOuter);
    final Paint clockBackgroundBorderPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isDark
                    ? [AppColors.darkBorder, AppColors.darkDeep]
                    : [AppColors.lightScaffold2, Colors.white],
          ).createShader(rectOuter);

    //draw an interior border circle and the background circle itself
    canvas.drawCircle(center, radius - 14, clockBackgroundBorderPaint);
    canvas.drawCircle(center, radius - 15, clockBackgroundPaint);

    final Paint secondHandPaint =
        Paint()
          ..shader = const RadialGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round;

    final Paint secondHandButtPaint =
        Paint()
          ..shader = const RadialGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round;

    final Paint minuteHandPaint =
        Paint()
          ..color =
              isDark
                  ? AppColors.darkBackgroundText
                  : AppColors.lightBackgroundText
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 6;
    final Paint labelHandPaint =
        Paint()
          ..color =
              isDark
                  ? AppColors.darkBorder
                  : AppColors.shadowLight.withValues(alpha: 0.57)
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 2;

    //draw minute sphere in the center
    canvas.drawCircle(center, 5, minuteHandPaint);

    //draw label hands
    canvas.drawLine(
      Offset(centerX, centerY - radius + 20),
      Offset(centerX, centerY - radius + 30),
      labelHandPaint,
    );
    canvas.drawLine(
      Offset(centerX, centerY + radius - 20),
      Offset(centerX, centerY + radius - 30),
      labelHandPaint,
    );
    canvas.drawLine(
      Offset(centerX + radius - 30, centerY),
      Offset(centerX + radius - 20, centerY),
      labelHandPaint,
    );
    canvas.drawLine(
      Offset(centerX - radius + 30, centerY),
      Offset(centerX - radius + 20, centerY),
      labelHandPaint,
    );

    final minHandX =
        centerX + radius / 1.8 * math.cos(dateTime.minute * 6 * math.pi / 180);
    final minHandY =
        centerY + radius / 1.8 * math.sin(dateTime.minute * 6 * math.pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minuteHandPaint);

    final hourHandX =
        centerX +
        radius /
            2.2 *
            math.cos(
              (dateTime.hour * 30 + dateTime.minute * 0.5) * math.pi / 180,
            );
    final hourHandY =
        centerY +
        radius /
            2.2 *
            math.sin(
              (dateTime.hour * 30 + dateTime.minute * 0.5) * math.pi / 180,
            );
    canvas.drawLine(center, Offset(hourHandX, hourHandY), minuteHandPaint);

    final secHandX =
        centerX + radius / 1.5 * math.cos(dateTime.second * 6 * math.pi / 180);
    final secHandY =
        centerY + radius / 1.5 * math.sin(dateTime.second * 6 * math.pi / 180);
    final secHandEndX =
        centerX - 15 * math.cos(dateTime.second * 6 * math.pi / 180);
    final secHandEndY =
        centerY - 15 * math.sin(dateTime.second * 6 * math.pi / 180);
    final secHandButtX =
        centerX - 30 * math.cos(dateTime.second * 6 * math.pi / 180);
    final secHandButtY =
        centerY - 30 * math.sin(dateTime.second * 6 * math.pi / 180);
    canvas.drawCircle(center, 3, secondHandPaint);
    canvas.drawLine(center, Offset(secHandEndX, secHandEndY), secondHandPaint);
    canvas.drawLine(
      Offset(secHandEndX, secHandEndY),
      Offset(secHandButtX, secHandButtY),
      secondHandButtPaint,
    );
    canvas.drawLine(center, Offset(secHandX, secHandY), secondHandPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
