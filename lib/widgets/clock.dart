import 'dart:async';
import 'dart:math' as math;
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
    final bool isDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
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
                (isDark)
                    ? [const Color(0xFF363E46), const Color(0xFF2C343C)]
                    : [const Color(0xFFECEEF3), const Color(0xFFF1F2F7)],
          ).createShader(rectOuter);
    final Paint clockBackgroundBorderPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                (isDark)
                    ? [const Color(0xFF5D666D), const Color(0xFF232A30)]
                    : [const Color(0xFFA5B1C3), const Color(0xFFFEFEFF)],
          ).createShader(rectOuter);

    //draw an interior border circle and the background circle itself
    canvas.drawCircle(center, radius - 14, clockBackgroundBorderPaint);
    canvas.drawCircle(center, radius - 15, clockBackgroundPaint);

    final Paint secondHandPaint =
        Paint()
          ..shader = const RadialGradient(
            colors: [Color(0xFFFD251E), Color(0xFFFE725C)],
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round;

    final Paint secondHandButtPaint =
        Paint()
          ..shader = const RadialGradient(
            colors: [Color(0xFFFD251E), Color(0xFFFE725C)],
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round;

    final Paint minuteHandPaint =
        Paint()
          ..color = (isDark) ? const Color(0xFF8E98A1) : const Color(0xFF646E82)
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 6;
    final Paint labelHandPaint =
        Paint()
          ..color =
              (isDark)
                  ? const Color(0xFF5D666D)
                  : const Color(0xFFA6B4C8).withValues(alpha: 0.57)
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

    var minHandX =
        centerX + radius / 1.8 * math.cos(dateTime.minute * 6 * math.pi / 180);
    var minHandY =
        centerY + radius / 1.8 * math.sin(dateTime.minute * 6 * math.pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minuteHandPaint);

    var hourHandX =
        centerX +
        radius /
            2.2 *
            math.cos(
              (dateTime.hour * 30 + dateTime.minute * 0.5) * math.pi / 180,
            );
    var hourHandY =
        centerY +
        radius /
            2.2 *
            math.sin(
              (dateTime.hour * 30 + dateTime.minute * 0.5) * math.pi / 180,
            );
    canvas.drawLine(center, Offset(hourHandX, hourHandY), minuteHandPaint);

    var secHandX =
        centerX + radius / 1.5 * math.cos(dateTime.second * 6 * math.pi / 180);
    var secHandY =
        centerY + radius / 1.5 * math.sin(dateTime.second * 6 * math.pi / 180);
    var secHandEndX =
        centerX - 15 * math.cos(dateTime.second * 6 * math.pi / 180);
    var secHandEndY =
        centerY - 15 * math.sin(dateTime.second * 6 * math.pi / 180);
    var secHandButtX =
        centerX - 30 * math.cos(dateTime.second * 6 * math.pi / 180);
    var secHandButtY =
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
