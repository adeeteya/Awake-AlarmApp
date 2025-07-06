import 'package:awake/models/alarm_model.dart';
import 'package:awake/services/settings_cubit.dart';
import 'package:awake/theme/app_colors.dart';
import 'package:awake/widgets/gradient_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlarmTile extends StatefulWidget {
  final AlarmModel alarmModel;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<List<int>> onDaysChanged;
  final VoidCallback onDelete;

  const AlarmTile({
    super.key,
    required this.alarmModel,
    required this.onEnabledChanged,
    required this.onDaysChanged,
    required this.onDelete,
  });

  @override
  State<AlarmTile> createState() => _AlarmTileState();
}

class _AlarmTileState extends State<AlarmTile> {
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

  Widget _daySelector(
    Set<int> days,
    bool isDark,
    ValueChanged<Set<int>> onChanged,
  ) {
    const dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'Su'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int i = 0; i < dayLabels.length; i++)
          GestureDetector(
            onTap: () {
              final newDays = <int>{...days};
              if (newDays.contains(i + 1)) {
                newDays.remove(i + 1);
              } else {
                newDays.add(i + 1);
              }
              onChanged(newDays);
            },
            child: SizedBox(
              height: 24,
              width: 24,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      days.contains(i + 1)
                          ? AppColors.primary
                          : Colors.transparent,
                  border:
                      days.contains(i + 1)
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
                          days.contains(i + 1)
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

  Future<void> _showEditDialog() async {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool use24h = context.read<SettingsCubit>().state.use24HourFormat;
    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor:
                  isDark ? AppColors.darkScaffold1 : AppColors.lightScaffold1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        MaterialLocalizations.of(context).formatTimeOfDay(
                          widget.alarmModel.timeOfDay,
                          alwaysUse24HourFormat: use24h,
                        ),
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
                      GradientSwitch(
                        value: _enabled,
                        onChanged: (v) {
                          setState(() => _enabled = v);
                          setStateDialog(() {});
                          widget.onEnabledChanged(v);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _daySelector(_selectedDays, isDark, (d) {
                    setState(() => _selectedDays = d);
                    setStateDialog(() {});
                    widget.onDaysChanged(_selectedDays.toList());
                  }),
                  const SizedBox(height: 20),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onDelete();
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete Alarm'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool use24h = context.watch<SettingsCubit>().state.use24HourFormat;
    return Padding(
      padding: const EdgeInsets.only(top: 23),
      child: DecoratedBox(
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
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: SizedBox(
            height: 74,
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors:
                      isDark
                          ? [AppColors.darkClock1, AppColors.darkScaffold1]
                          : [
                            AppColors.lightScaffold1,
                            AppColors.lightGradient2,
                          ],
                ),
              ),
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: _showEditDialog,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        Text(
                          MaterialLocalizations.of(context).formatTimeOfDay(
                            widget.alarmModel.timeOfDay,
                            alwaysUse24HourFormat: use24h,
                          ),
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
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
