import 'package:awake/models/alarm_model.dart';
import 'package:flutter/material.dart';

class AlarmTile extends StatelessWidget {
  final AlarmModel alarmModel;
  final VoidCallback onDelete;
  const AlarmTile({
    super.key,
    required this.alarmModel,
    required this.onDelete,
  });

  Widget _repeatDayText(bool isDark) {
    const dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'Su'];
    final textSpans = <TextSpan>[];

    for (int i = 0; i < dayLabels.length; i++) {
      final isSelected =
          alarmModel.alarmSettings
              .where((e) => e.dateTime.weekday == i + 1)
              .isNotEmpty;
      final color =
          isSelected
              ? const Color(0xFFFD251E)
              : isDark
              ? const Color(0xFF8E98A1)
              : const Color(0xFF646E82);

      textSpans.add(
        TextSpan(text: '${dayLabels[i]} ', style: TextStyle(color: color)),
      );
    }

    return Text.rich(
      TextSpan(children: textSpans),
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        letterSpacing: 0.03,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(1),
      margin: const EdgeInsets.only(top: 23),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              (isDark)
                  ? [const Color(0xFF5D666D), const Color(0xFF242B31)]
                  : [Colors.white, const Color(0xFFBAC3CF)],
        ),
        boxShadow:
            (isDark)
                ? [
                  BoxShadow(
                    offset: const Offset(-5, -5),
                    blurRadius: 20,
                    color: const Color(0xFF48535C).withValues(alpha: 0.35),
                  ),
                  BoxShadow(
                    offset: const Offset(13, 14),
                    blurRadius: 12,
                    spreadRadius: -6,
                    color: const Color(0xFF23282D).withValues(alpha: 0.70),
                  ),
                ]
                : [
                  BoxShadow(
                    offset: const Offset(-5, -5),
                    blurRadius: 20,
                    color: Colors.white.withValues(alpha: 0.53),
                  ),
                  BoxShadow(
                    offset: const Offset(13, 14),
                    blurRadius: 12,
                    spreadRadius: -6,
                    color: const Color(0xFFA6B4C8).withValues(alpha: 0.57),
                  ),
                ],
      ),
      child: Container(
        height: 74,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                (isDark)
                    ? [const Color(0xFF3F4850), const Color(0xFF363E46)]
                    : [const Color(0xFFEEF0F5), const Color(0xFFE6E9EF)],
          ),
        ),
        child: Row(
          children: [
            Text(
              "${alarmModel.timeOfDay.hour < 10 ? "0${alarmModel.timeOfDay.hour}" : alarmModel.timeOfDay.hour}:${alarmModel.timeOfDay.minute < 10 ? "0${alarmModel.timeOfDay.minute}" : alarmModel.timeOfDay.minute}",
              style: TextStyle(
                color:
                    (isDark)
                        ? const Color(0xFF8E98A1)
                        : const Color(0xFF646E82),
                fontFamily: 'Poppins',
                fontSize: 34,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (alarmModel.alarmSettings.isNotEmpty) _repeatDayText(isDark),
            const SizedBox(width: 12),
            IconButton(
              onPressed: onDelete,
              tooltip: "Delete",
              icon: Icon(Icons.delete),
              style: IconButton.styleFrom(foregroundColor: Color(0xFFFD251E)),
            ),
          ],
        ),
      ),
    );
  }
}
