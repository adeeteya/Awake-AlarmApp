import 'package:awake/theme/app_colors.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow_update/flutter_inset_box_shadow_update.dart';

class GradientSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;

  const GradientSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
  });

  @override
  State<GradientSlider> createState() => _GradientSliderState();
}

class _GradientSliderState extends State<GradientSlider> {
  late double _value;
  final double thumbRadius = 12;

  @override
  void initState() {
    super.initState();
    _value = widget.value.clamp(widget.min, widget.max);
  }

  @override
  void didUpdateWidget(covariant GradientSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _value = widget.value.clamp(widget.min, widget.max);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.brightnessOf(context) == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final fullWidth = constraints.maxWidth;
        final trackLeft = thumbRadius;
        final trackRight = fullWidth - thumbRadius;
        final trackWidth = trackRight - trackLeft;

        final progress = (_value - widget.min) / (widget.max - widget.min);
        final thumbX = (progress * trackWidth) + trackLeft;

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanUpdate: (details) {
            final dx = details.localPosition.dx.clamp(trackLeft, trackRight);
            final newProgress = (dx - trackLeft) / trackWidth;
            final newValue =
                widget.min + newProgress * (widget.max - widget.min);
            setState(() => _value = newValue);
            widget.onChanged(_value);
          },
          child: SizedBox(
            height: 48,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // Inactive track
                Positioned(
                  left: trackLeft,
                  right: thumbRadius,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? AppColors.shadowDark.withValues(alpha: 0.25)
                              : AppColors.shadowLight.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(1.5, 1.5),
                          blurRadius: 3,
                          color:
                              isDark
                                  ? AppColors.shadowDark.withValues(alpha: 0.4)
                                  : AppColors.lightBackgroundText.withValues(
                                    alpha: 0.4,
                                  ),
                          inset: true,
                        ),
                      ],
                    ),
                  ),
                ),

                // Active track (gradient)
                Positioned(
                  left: trackLeft,
                  child: Container(
                    height: 6,
                    width: thumbX - trackLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                      ),
                    ),
                  ),
                ),

                // Thumb (always visible)
                Positioned(
                  left: thumbX - thumbRadius,
                  child: Container(
                    width: thumbRadius * 2,
                    height: thumbRadius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient:
                          isDark
                              ? null
                              : const LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: [
                                  AppColors.lightScaffold1,
                                  AppColors.lightGradient2,
                                ],
                              ),
                      color: isDark ? AppColors.lightScaffold2 : null,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(-3, -3),
                          blurRadius: 6,
                          color:
                              isDark
                                  ? const Color(
                                    0xFF454D56,
                                  ).withValues(alpha: 0.5)
                                  : Colors.white.withValues(alpha: 0.8),
                        ),
                        BoxShadow(
                          offset: const Offset(3, 3),
                          blurRadius: 6,
                          color:
                              isDark
                                  ? const Color(
                                    0xFF181E24,
                                  ).withValues(alpha: 0.6)
                                  : const Color(
                                    0xFFA6B4C8,
                                  ).withValues(alpha: 0.6),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
