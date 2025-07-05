import 'package:awake/models/alarm_model.dart';
import 'package:awake/theme/app_colors.dart';
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
              ? AppColors.primary
              : isDark
              ? AppColors.darkBackgroundText
              : AppColors.lightBackgroundText;

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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(1),
      margin: const EdgeInsets.only(top: 23),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? [AppColors.darkBorder, AppColors.darkScaffold2]
                  : [Colors.white, AppColors.lightScaffold2],
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
                    offset: const Offset(13, 14),
                    blurRadius: 12,
                    spreadRadius: -6,
                    color: AppColors.shadowDark.withValues(alpha: 0.70),
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
                    color: AppColors.shadowLight.withValues(alpha: 0.57),
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
                isDark
                    ? [AppColors.darkClock1, AppColors.darkScaffold1]
                    : [AppColors.lightScaffold1, AppColors.lightGradient2],
          ),
        ),
        child: Row(
          children: [
            Text(
              "${alarmModel.timeOfDay.hour < 10 ? "0${alarmModel.timeOfDay.hour}" : alarmModel.timeOfDay.hour}:${alarmModel.timeOfDay.minute < 10 ? "0${alarmModel.timeOfDay.minute}" : alarmModel.timeOfDay.minute}",
              style: TextStyle(
                color:
                    isDark
                        ? AppColors.darkBackgroundText
                        : AppColors.lightBackgroundText,
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
              icon: const Icon(Icons.delete),
              style: IconButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
