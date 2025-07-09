import 'package:awake/theme/app_text_styles.dart';
import 'package:awake/widgets/add_button.dart';
import 'package:awake/widgets/minus_button.dart';
import 'package:flutter/material.dart';

class SnoozeButton extends StatefulWidget {
  final Function(int snoozeMinutes) onSnoozePressed;
  const SnoozeButton({super.key, required this.onSnoozePressed});

  @override
  State<SnoozeButton> createState() => _SnoozeButtonState();
}

class _SnoozeButtonState extends State<SnoozeButton> {
  int snoozeMinutes = 5;

  void _increment() {
    setState(() {
      snoozeMinutes += 5;
    });
  }

  void _decrement() {
    setState(() {
      if (snoozeMinutes > 5) snoozeMinutes -= 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.brightnessOf(context) == Brightness.dark;

    return Row(
      children: [
        const SizedBox(width: 16),
        GestureDetector(onTap: _decrement, child: const MinusButton()),
        const SizedBox(width: 16),
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => widget.onSnoozePressed(snoozeMinutes),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color:
                      isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.04),
                ),
                child: Text(
                  'Snooze: $snoozeMinutes min',
                  style: AppTextStyles.body(context).copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(onTap: _increment, child: const AddButton()),
        const SizedBox(width: 16),
      ],
    );
  }
}
