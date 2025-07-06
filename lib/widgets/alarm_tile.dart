import 'package:awake/models/alarm_model.dart';
import 'package:awake/theme/app_colors.dart';
import 'package:awake/widgets/gradient_switch.dart';
import 'package:flutter/material.dart';

class AlarmTile extends StatefulWidget {
  final AlarmModel alarmModel;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<List<int>> onDaysChanged;

  const AlarmTile({
    super.key,
    required this.alarmModel,
    required this.onEnabledChanged,
    required this.onDaysChanged,
  });

  @override
  State<AlarmTile> createState() => _AlarmTileState();
}

class _AlarmTileState extends State<AlarmTile> {
  bool _expanded = false;
  late bool _enabled;
  late Set<int> _selectedDays;

  @override
  void initState() {
    super.initState();
    _enabled = widget.alarmModel.enabled;
    _selectedDays = widget.alarmModel.days.toSet();
  }

  @override
  void didUpdateWidget(covariant AlarmTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    _enabled = widget.alarmModel.enabled;
    _selectedDays = widget.alarmModel.days.toSet();
  }

  Widget _repeatDayText(bool isDark) {
    const dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'Su'];
    final textSpans = <TextSpan>[];

    for (int i = 0; i < dayLabels.length; i++) {
      final isSelected = _selectedDays.contains(i + 1);
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

  Widget _daySelector(bool isDark) {
    const dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'Su'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int i = 0; i < dayLabels.length; i++)
          GestureDetector(
            onTap: () {
              setState(() {
                if (_selectedDays.contains(i + 1)) {
                  _selectedDays.remove(i + 1);
                } else {
                  _selectedDays.add(i + 1);
                }
              });
              widget.onDaysChanged(_selectedDays.toList());
            },
            child: SizedBox(
              height: 24,
              width: 24,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _selectedDays.contains(i + 1)
                          ? AppColors.primary
                          : Colors.transparent,
                  border:
                      _selectedDays.contains(i + 1)
                          ? null
                          : Border.all(
                            color:
                                isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBlueGrey,
                          ),
                ),
                child: Center(
                  child: Text(
                    dayLabels[i],
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color:
                          _selectedDays.contains(i + 1)
                              ? Colors.white
                              : isDark
                              ? AppColors.darkBackgroundText
                              : AppColors.lightBackgroundText,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: _expanded ? 120 : 74,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    "${widget.alarmModel.timeOfDay.hour.toString().padLeft(2, '0')}:${widget.alarmModel.timeOfDay.minute.toString().padLeft(2, '0')}",
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
                  _repeatDayText(isDark),
                  const SizedBox(width: 12),
                  GradientSwitch(
                    value: _enabled,
                    onChanged: (v) {
                      setState(() => _enabled = v);
                      widget.onEnabledChanged(v);
                    },
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 12),
                _daySelector(isDark),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
