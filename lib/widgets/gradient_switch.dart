import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow_update/flutter_inset_box_shadow_update.dart';
import 'package:awake/theme/app_colors.dart';

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
                      ? AppColors.darkDeep
                      : AppColors.shadowLight.withOpacity(0.25),
              borderRadius: BorderRadius.circular(40),
              gradient:
                  isChecked
                      ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, AppColors.primaryLight],
                      )
                      : null,
              boxShadow:
                  isChecked
                      ? [
                        BoxShadow(
                          offset: const Offset(1.6, 1.3),
                          blurRadius: 1.98,
                          color: Colors.black.withOpacity(0.2),
                          inset: true,
                        ),
                        BoxShadow(
                          offset: const Offset(3, 3),
                          blurRadius: 11,
                          spreadRadius: 2,
                          color: const Color(
                            0xFFFD251E,
                          ).withOpacity(0.35),
                        ),
                      ]
                      : (isDark)
                      ? [
                        BoxShadow(
                          offset: const Offset(-1.6, -1.6),
                          blurRadius: 4.9,
                          color: const Color(
                            0xFF454D55,
                          ).withOpacity(0.25),
                          inset: true,
                        ),
                        BoxShadow(
                          offset: const Offset(1.6, 1.3),
                          blurRadius: 1.98,
                          color: AppColors.shadowDark.withOpacity(0.7),
                          inset: true,
                        ),
                      ]
                      : [
                        BoxShadow(
                          offset: const Offset(-1.6, -1.6),
                          blurRadius: 3,
                          color: Colors.white.withOpacity(0.41),
                          inset: true,
                        ),
                        BoxShadow(
                          offset: const Offset(1.6, 1.3),
                          blurRadius: 1.98,
                          color: AppColors.lightBackgroundText.withOpacity(0.2),
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
                            ? AppColors.lightScaffold2
                            : AppColors.darkGrey
                        : null,
                gradient:
                    (isDark)
                        ? null
                        : const LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [AppColors.lightScaffold1, AppColors.lightGradient2],
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
                            ).withOpacity(0.52),
                          ),
                          BoxShadow(
                            offset: const Offset(3, 3),
                            blurRadius: 6,
                            color: const Color(
                              0xFF181E24,
                            ).withOpacity(0.65),
                          ),
                        ]
                        : [
                          BoxShadow(
                            offset: const Offset(-3, -3),
                            blurRadius: 6,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          BoxShadow(
                            offset: const Offset(3, 3),
                            blurRadius: 6,
                            color: const Color(
                              0xFFA6B4C8,
                            ).withOpacity(0.65),
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
