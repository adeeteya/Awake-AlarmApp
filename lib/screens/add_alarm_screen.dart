import 'package:awake/extensions/context_extensions.dart';
import 'package:awake/models/alarm_model.dart';
import 'package:awake/services/alarm_cubit.dart';
import 'package:awake/services/settings_cubit.dart';
import 'package:awake/theme/app_colors.dart';
import 'package:awake/theme/app_text_styles.dart';
import 'package:awake/widgets/add_button.dart';
import 'package:awake/widgets/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAlarmScreen extends StatefulWidget {
  final AlarmModel? alarmModel;

  const AddAlarmScreen({super.key, this.alarmModel});

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  late TimeOfDay _selectedTime;
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late Set<int> _selectedDays;
  final List<String> _dayNames = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  @override
  void initState() {
    super.initState();
    if (widget.alarmModel != null) {
      _selectedTime = widget.alarmModel!.timeOfDay;
      _selectedDays = widget.alarmModel!.days.toSet();
      _titleController.text = widget.alarmModel!.body;
    } else {
      _selectedTime = TimeOfDay.now();
      _selectedDays = <int>{
        DateTime.monday,
        DateTime.tuesday,
        DateTime.wednesday,
        DateTime.thursday,
        DateTime.friday,
        DateTime.saturday,
        DateTime.sunday,
      };
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleDay(int day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  Future<void> _addAlarm() async {
    if (_selectedDays.isEmpty) return;
    final title = _titleController.text.trim();
    final cubit = context.read<AlarmCubit>();
    if (widget.alarmModel != null) {
      final oldModel = widget.alarmModel!;
      await cubit.deleteAlarmModel(oldModel);
      await cubit.setPeriodicAlarms(
        timeOfDay: _selectedTime,
        days: _selectedDays.toList(),
        body: title,
      );
      if (!oldModel.enabled) {
        await cubit.toggleAlarmEnabled(_selectedTime, false);
      }
    } else {
      await cubit.setPeriodicAlarms(
        timeOfDay: _selectedTime,
        days: _selectedDays.toList(),
        body: title,
      );
    }
    if (mounted) Navigator.pop(context);
  }

  Future<void> _deleteAlarm() async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Delete Alarm'),
                content: const Text(
                  'Are you sure you want to delete this alarm?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
        ) ??
        false;

    if (!mounted || !confirmed) return;

    final cubit = context.read<AlarmCubit>();
    await cubit.deleteAlarmModel(widget.alarmModel!);
    if (mounted) Navigator.pop(context);
  }

  Widget _daySelector(bool isDark) {
    const dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'Su'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int i = 0; i < dayLabels.length; i++)
          IconButton(
            tooltip: _dayNames[i],
            onPressed: () => _toggleDay(i + 1),
            style: IconButton.styleFrom(
              backgroundColor:
                  _selectedDays.contains(i + 1) ? AppColors.primary : null,
              side:
                  _selectedDays.contains(i + 1)
                      ? BorderSide.none
                      : BorderSide(
                        color:
                            isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBlueGrey,
                      ),
            ),
            icon: Text(
              dayLabels[i],
              style: AppTextStyles.caption(context).copyWith(
                color:
                    _selectedDays.contains(i + 1)
                        ? Colors.white
                        : isDark
                        ? AppColors.darkBackgroundText
                        : AppColors.lightBackgroundText,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    return GestureDetector(
      onTap: _focusNode.unfocus,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBorder : Colors.white,
        appBar: AppBar(
          backgroundColor:
              isDark ? AppColors.darkScaffold1 : AppColors.lightScaffold1,
          leading: IconButton(
            tooltip: "Back",
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              foregroundColor:
                  isDark
                      ? AppColors.darkBackgroundText
                      : AppColors.lightBackgroundText,
            ),
            icon: const Icon(Icons.arrow_back),
          ),
          actions:
              widget.alarmModel == null
                  ? null
                  : [
                    IconButton(
                      tooltip: 'Delete',
                      onPressed: _deleteAlarm,
                      style: IconButton.styleFrom(
                        foregroundColor:
                            isDark
                                ? AppColors.darkBackgroundText
                                : AppColors.lightBackgroundText,
                      ),
                      icon: const Icon(Icons.delete),
                    ),
                  ],
          centerTitle: true,
          title: Text(widget.alarmModel == null ? 'Add Alarm' : 'Edit Alarm'),
          titleTextStyle: AppTextStyles.heading(context),
        ),
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors:
                  isDark
                      ? [AppColors.darkScaffold1, AppColors.darkScaffold2]
                      : [AppColors.lightContainer1, AppColors.lightContainer2],
            ),
          ),
          child: Form(
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      alwaysUse24HourFormat:
                          context.read<SettingsCubit>().state.use24HourFormat,
                    ),
                    child: TimePickerWidget(
                      initialTime: _selectedTime,
                      onTimeChanged: (time) {
                        setState(() {
                          _selectedTime = time;
                        });
                      },
                    ),
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _daySelector(isDark),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _titleController,
                        focusNode: _focusNode,
                        decoration: const InputDecoration(labelText: 'Title'),
                        onSubmitted: (_) => _addAlarm(),
                      ),
                      const SizedBox(height: 16),
                      IconButton(
                        tooltip:
                            widget.alarmModel == null
                                ? 'Add Alarm'
                                : 'Edit Alarm',
                        onPressed: _addAlarm,
                        icon: const AddButton(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
