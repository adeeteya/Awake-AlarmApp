import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class GradientSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const GradientSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<GradientSwitch> createState() => _GradientSwitchState();
}

class _GradientSwitchState extends State<GradientSwitch> {
  late bool isChecked = widget.value;

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
          widget.onChanged(isChecked);
        });
      },
      child: Stack(
        alignment: Alignment.centerLeft,
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            width: 40,
            height: 14,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeIn,
            padding: const EdgeInsets.only(
              top: 4,
              bottom: 4,
              right: 4,
              left: 4,
            ),
            decoration: BoxDecoration(
              color:
                  isChecked
                      ? null
                      : (isDark)
                      ? const Color(0xFF282F35)
                      : const Color(0xFFA6B4C8).withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(40),
              gradient:
                  isChecked
                      ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFD2A22), Color(0xFFFE6C57)],
                      )
                      : null,
              boxShadow:
                  isChecked
                      ? [
                        BoxShadow(
                          offset: const Offset(1.6, 1.3),
                          blurRadius: 1.98,
                          color: Colors.black.withValues(alpha: 0.2),
                          inset: true,
                        ),
                        BoxShadow(
                          offset: const Offset(3, 3),
                          blurRadius: 11,
                          spreadRadius: 2,
                          color: const Color(
                            0xFFFD251E,
                          ).withValues(alpha: 0.35),
                        ),
                      ]
                      : (isDark)
                      ? [
                        BoxShadow(
                          offset: const Offset(-1.6, -1.6),
                          blurRadius: 4.9,
                          color: const Color(
                            0xFF454D55,
                          ).withValues(alpha: 0.25),
                          inset: true,
                        ),
                        BoxShadow(
                          offset: const Offset(1.6, 1.3),
                          blurRadius: 1.98,
                          color: const Color(0xFF23282D).withValues(alpha: 0.7),
                          inset: true,
                        ),
                      ]
                      : [
                        BoxShadow(
                          offset: const Offset(-1.6, -1.6),
                          blurRadius: 3,
                          color: Colors.white.withValues(alpha: 0.41),
                          inset: true,
                        ),
                        BoxShadow(
                          offset: const Offset(1.6, 1.3),
                          blurRadius: 1.98,
                          color: const Color(0xFF63748B).withValues(alpha: 0.2),
                          inset: true,
                        ),
                      ],
            ),
          ),
          AnimatedPositioned(
            left: isChecked ? 19 : 0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeIn,
            child: Container(
              width: 21,
              height: 21,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    (isDark)
                        ? (isChecked)
                            ? const Color(0xFFA2ADB9)
                            : const Color(0xFF4E565F)
                        : null,
                gradient:
                    (isDark)
                        ? null
                        : const LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [Color(0xFFEEF0F5), Color(0xFFE6E9EF)],
                        ),
                boxShadow:
                    (isChecked)
                        ? null
                        : (isDark)
                        ? [
                          BoxShadow(
                            offset: const Offset(-3, -3),
                            blurRadius: 6,
                            color: const Color(
                              0xFF454D56,
                            ).withValues(alpha: 0.52),
                          ),
                          BoxShadow(
                            offset: const Offset(3, 3),
                            blurRadius: 6,
                            color: const Color(
                              0xFF181E24,
                            ).withValues(alpha: 0.65),
                          ),
                        ]
                        : [
                          BoxShadow(
                            offset: const Offset(-3, -3),
                            blurRadius: 6,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                          BoxShadow(
                            offset: const Offset(3, 3),
                            blurRadius: 6,
                            color: const Color(
                              0xFFA6B4C8,
                            ).withValues(alpha: 0.65),
                          ),
                        ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
