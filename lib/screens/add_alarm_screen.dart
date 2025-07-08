import 'package:awake/extensions/context_extensions.dart';
import 'package:awake/services/alarm_cubit.dart';
import 'package:awake/services/settings_cubit.dart';
import 'package:awake/theme/app_colors.dart';
import 'package:awake/widgets/add_button.dart';
import 'package:awake/widgets/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAlarmScreen extends StatefulWidget {
  const AddAlarmScreen({super.key});

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final Set<int> _selectedDays = <int>{
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
    DateTime.saturday,
    DateTime.sunday,
  };

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
    await context.read<AlarmCubit>().setPeriodicAlarms(
      timeOfDay: _selectedTime,
      days: _selectedDays.toList(),
      body: title,
    );
    if (mounted) Navigator.pop(context);
  }

  Widget _daySelector(bool isDark) {
    const dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'Su'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int i = 0; i < dayLabels.length; i++)
          GestureDetector(
            onTap: () => _toggleDay(i + 1),
            child: SizedBox(
              height: 32,
              width: 32,
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
          centerTitle: true,
          title: const Text('Add Alarm'),
          titleTextStyle: TextStyle(
            color:
                isDark
                    ? AppColors.darkBackgroundText
                    : AppColors.lightBackgroundText,
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.03,
          ),
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
                      ),
                      const SizedBox(height: 16),
                      InkWell(onTap: _addAlarm, child: const AddButton()),
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
