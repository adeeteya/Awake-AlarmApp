import 'package:awake/models/alarm.dart';
import 'package:awake/widgets/gradient_switch.dart';
import 'package:flutter/material.dart';

class AlarmTile extends StatelessWidget {
  final Alarm alarm;
  final ValueChanged<bool> onChanged;
  final VoidCallback onDelete;
  const AlarmTile(
      {Key? key,
      required this.alarm,
      required this.onChanged,
      required this.onDelete})
      : super(key: key);

  Widget repeatDayText(bool isDark) {
    return Text.rich(
      TextSpan(
        text: "S ",
        children: [
          TextSpan(
            text: "M ",
            children: [
              TextSpan(
                text: "T ",
                children: [
                  TextSpan(
                    text: "W ",
                    children: [
                      TextSpan(
                        text: "T ",
                        children: [
                          TextSpan(
                            text: "F ",
                            children: [
                              TextSpan(
                                text: "S ",
                                style: TextStyle(
                                  color: (alarm.repeatDays![6] == true)
                                      ? const Color(0xFFFD251E)
                                      : (isDark)
                                          ? const Color(0xFF8E98A1)
                                          : const Color(0xFF646E82),
                                ),
                              ),
                            ],
                            style: TextStyle(
                              color: (alarm.repeatDays![5] == true)
                                  ? const Color(0xFFFD251E)
                                  : (isDark)
                                      ? const Color(0xFF8E98A1)
                                      : const Color(0xFF646E82),
                            ),
                          ),
                        ],
                        style: TextStyle(
                          color: (alarm.repeatDays![4] == true)
                              ? const Color(0xFFFD251E)
                              : (isDark)
                                  ? const Color(0xFF8E98A1)
                                  : const Color(0xFF646E82),
                        ),
                      ),
                    ],
                    style: TextStyle(
                      color: (alarm.repeatDays![3] == true)
                          ? const Color(0xFFFD251E)
                          : (isDark)
                              ? const Color(0xFF8E98A1)
                              : const Color(0xFF646E82),
                    ),
                  ),
                ],
                style: TextStyle(
                  color: (alarm.repeatDays![2] == true)
                      ? const Color(0xFFFD251E)
                      : (isDark)
                          ? const Color(0xFF8E98A1)
                          : const Color(0xFF646E82),
                ),
              ),
            ],
            style: TextStyle(
              color: (alarm.repeatDays![1] == true)
                  ? const Color(0xFFFD251E)
                  : (isDark)
                      ? const Color(0xFF8E98A1)
                      : const Color(0xFF646E82),
            ),
          ),
        ],
        style: TextStyle(
          color: (alarm.repeatDays![0] == true)
              ? const Color(0xFFFD251E)
              : (isDark)
                  ? const Color(0xFF8E98A1)
                  : const Color(0xFF646E82),
        ),
      ),
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        letterSpacing: 0.03,
      ),
    );
  }

  String weekDayHelper(int pos) {
    switch (pos) {
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thur";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
      default:
        return "";
    }
  }

  String monthHelper(int pos) {
    switch (pos) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return GestureDetector(
      onLongPressStart: (details) {
        final tapPosition = details.globalPosition;
        final RenderObject? overlay =
            Overlay.of(context)?.context.findRenderObject();
        showMenu(
          context: context,
          position: RelativeRect.fromRect(
            Rect.fromLTWH(tapPosition.dx, tapPosition.dy, 30, 30),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                overlay.paintBounds.size.height),
          ),
          items: [
            PopupMenuItem(
              onTap: onDelete,
              child: Row(
                children: const [
                  Icon(
                    Icons.delete_rounded,
                    color: Color(0xFFFD251E),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Delete",
                    style: TextStyle(
                      color: Color(0xFFFD251E),
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      child: Container(
        padding: const EdgeInsets.all(1),
        margin: const EdgeInsets.only(top: 23),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: (isDark)
                ? [
                    const Color(0xFF5D666D),
                    const Color(0xFF242B31),
                  ]
                : [
                    Colors.white,
                    const Color(0xFFBAC3CF),
                  ],
          ),
          boxShadow: (isDark)
              ? [
                  BoxShadow(
                    offset: const Offset(-5, -5),
                    blurRadius: 20,
                    color: const Color(0xFF48535C).withOpacity(0.35),
                  ),
                  BoxShadow(
                    offset: const Offset(13, 14),
                    blurRadius: 12,
                    spreadRadius: -6,
                    color: const Color(0xFF23282D).withOpacity(0.70),
                  ),
                ]
              : [
                  BoxShadow(
                    offset: const Offset(-5, -5),
                    blurRadius: 20,
                    color: Colors.white.withOpacity(0.53),
                  ),
                  BoxShadow(
                    offset: const Offset(13, 14),
                    blurRadius: 12,
                    spreadRadius: -6,
                    color: const Color(0xFFA6B4C8).withOpacity(0.57),
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
              colors: (isDark)
                  ? [
                      const Color(0xFF3F4850),
                      const Color(0xFF363E46),
                    ]
                  : [
                      const Color(0xFFEEF0F5),
                      const Color(0xFFE6E9EF),
                    ],
            ),
          ),
          child: AnimatedOpacity(
            opacity: alarm.isTurnedOn ? 1 : 0.5,
            duration: const Duration(milliseconds: 250),
            child: Row(
              children: [
                Text(
                  "${alarm.hour < 10 ? "0${alarm.hour}" : alarm.hour}:${alarm.minute < 10 ? "0${alarm.minute}" : alarm.minute}",
                  style: TextStyle(
                    color: (isDark)
                        ? const Color(0xFF8E98A1)
                        : const Color(0xFF646E82),
                    fontFamily: 'Poppins',
                    fontSize: 34,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (alarm.dateTime != null)
                  Text(
                    "${weekDayHelper(alarm.dateTime!.weekday)}, ${alarm.dateTime!.day} ${monthHelper(alarm.dateTime!.month)}",
                    style: TextStyle(
                      color: (isDark)
                          ? const Color(0xFF8E98A1)
                          : const Color(0xFF646E82),
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      letterSpacing: 0.03,
                    ),
                  ),
                if (alarm.repeatDays != null) repeatDayText(isDark),
                const SizedBox(width: 12),
                GradientSwitch(value: alarm.isTurnedOn, onChanged: onChanged),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
