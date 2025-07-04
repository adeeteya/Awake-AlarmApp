import 'package:flutter/material.dart';
import 'dart:math' as math;

class MinusButton extends StatelessWidget {
  const MinusButton({super.key});

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
              isDark
                  ? [const Color(0xFF3B444D), const Color(0xFF343E46)]
                  : [const Color(0xFFE4E8F1), const Color(0xFFE6E9EF)],
        ),
        boxShadow:
            isDark
                ? [
                  BoxShadow(
                    offset: const Offset(-5, -5),
                    blurRadius: 20,
                    color: const Color(0xFF48535C).withAlpha(90),
                  ),
                  BoxShadow(
                    offset: const Offset(5, 5),
                    blurRadius: 10,
                    color: const Color(0xFF23282D).withAlpha(180),
                  ),
                ]
                : [
                  BoxShadow(
                    offset: const Offset(-5, -5),
                    blurRadius: 10,
                    color: Colors.white.withAlpha(180),
                  ),
                  BoxShadow(
                    offset: const Offset(5, 5),
                    blurRadius: 10,
                    color: const Color(0xFFA6B4C8).withAlpha(180),
                  ),
                ],
        shape: BoxShape.circle,
      ),
      child: CustomPaint(
        size: const Size(78, 78),
        painter: MinusButtonPainter(isDark),
      ),
    );
  }
}

class MinusButtonPainter extends CustomPainter {
  final bool isDark;
  MinusButtonPainter(this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rectOuter = Offset.zero & size;
    final Offset center = Offset(size.width / 2, size.height / 2);

    final Paint rectangle = Paint()..color = const Color(0xFFECF0F3);
    final Paint sphere1 =
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFD251E), Color(0xFFFE725C)],
          ).createShader(rectOuter);
    final Paint sphereInset1 =
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFE725C), Color(0xFFE5120A)],
          ).createShader(rectOuter);
    final Paint sphereInset2 =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isDark
                    ? [const Color(0xFF5D666D), const Color(0xFF21272D)]
                    : [const Color(0xFFA6B4C8), const Color(0xFF768FB1)],
          ).createShader(rectOuter);

    final Path semiOvalBottomRight =
        Path()..addArc(
          Rect.fromCenter(center: center, width: 74, height: 74),
          -math.pi / 3,
          math.pi,
        );
    canvas.drawShadow(
      semiOvalBottomRight,
      const Color(0xFFFD251E).withAlpha(90),
      11,
      true,
    );

    canvas
      ..drawCircle(center, 31.5, sphereInset2)
      ..drawCircle(center, 30, sphere1)
      ..drawCircle(center, 28, sphereInset1);

    canvas.drawRect(
      Rect.fromCenter(center: center, width: 18, height: 4),
      rectangle,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
