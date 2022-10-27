import 'package:flutter/material.dart';

Future<List<bool>?> weekDayPicker({required BuildContext context}) async {
  final bool isDark =
      MediaQuery.of(context).platformBrightness == Brightness.dark;
  List<bool> selectedDays = List.generate(7, (index) => false);
  selectedDays[DateTime.now().weekday] = true;
  return await showDialog<List<bool>?>(
    context: context,
    barrierDismissible: false,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(
          "Repeat On",
          style: TextStyle(
            color: (isDark) ? const Color(0xFF8E98A1) : const Color(0xFF646E82),
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.03,
          ),
        ),
        titlePadding: const EdgeInsets.only(top: 10, bottom: 10, left: 16),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        content: Row(
          children: [
            GestureDetector(
              onTap: () => setState(() => selectedDays[0] = !selectedDays[0]),
              child: daySelectionWidget("S", selectedDays[0], isDark),
            ),
            GestureDetector(
              onTap: () => setState(() => selectedDays[1] = !selectedDays[1]),
              child: daySelectionWidget("M", selectedDays[1], isDark),
            ),
            GestureDetector(
              onTap: () => setState(() => selectedDays[2] = !selectedDays[2]),
              child: daySelectionWidget("T", selectedDays[2], isDark),
            ),
            GestureDetector(
              onTap: () => setState(() => selectedDays[3] = !selectedDays[3]),
              child: daySelectionWidget("W", selectedDays[3], isDark),
            ),
            GestureDetector(
              onTap: () => setState(() => selectedDays[4] = !selectedDays[4]),
              child: daySelectionWidget("T", selectedDays[4], isDark),
            ),
            GestureDetector(
              onTap: () => setState(() => selectedDays[5] = !selectedDays[5]),
              child: daySelectionWidget("F", selectedDays[5], isDark),
            ),
            GestureDetector(
              onTap: () => setState(() => selectedDays[6] = !selectedDays[6]),
              child: daySelectionWidget("S", selectedDays[6], isDark),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: const Text("Select Specific Date"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, selectedDays);
            },
            child: const Text("Set Alarm"),
          ),
        ],
      ),
    ),
  );
}

Widget daySelectionWidget(String dayLetter, bool isSelected, bool isDark) {
  return Container(
    height: 30,
    width: 30,
    alignment: Alignment.center,
    margin: const EdgeInsets.only(right: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: (isDark)
          ? const Color(0xFF282F35)
          : const Color(0xFFA6B4C8).withOpacity(0.25),
    ),
    child: Text(
      dayLetter,
      style: TextStyle(
        color: (isSelected)
            ? const Color(0xFFFD251E)
            : (isDark)
                ? const Color(0xFF8E98A1)
                : const Color(0xFF646E82),
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
