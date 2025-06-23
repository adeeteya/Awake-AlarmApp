import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

class AlarmTile extends StatelessWidget {
  final AlarmSettings alarmSettings;
  final VoidCallback onDelete;
  const AlarmTile({
    super.key,
    required this.alarmSettings,
    required this.onDelete,
  });

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
              "${alarmSettings.dateTime.hour < 10 ? "0${alarmSettings.dateTime.hour}" : alarmSettings.dateTime.hour}:${alarmSettings.dateTime.minute < 10 ? "0${alarmSettings.dateTime.minute}" : alarmSettings.dateTime.minute}",
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
