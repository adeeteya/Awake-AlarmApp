import 'package:awake/extensions/context_extensions.dart';
import 'package:awake/services/alarm_cubit.dart';
import 'package:awake/services/settings_cubit.dart';
import 'package:awake/theme/app_colors.dart';
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
    super.dispose();
  }

  Future<void> _pickTime() async {
    final bool use24h = context.read<SettingsCubit>().state.use24HourFormat;
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      helpText: 'Set Alarm Time',
      confirmText: 'Confirm',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: use24h),
          child: child!,
        );
      },
    );
    if (time != null) setState(() => _selectedTime = time);
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
      body: title.isEmpty ? 'Time to Wake Up' : title,
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
    final bool isDark = context.isDarkMode;
    final bool use24h = context.watch<SettingsCubit>().state.use24HourFormat;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBorder : Colors.white,
      appBar: AppBar(
        backgroundColor:
            isDark ? AppColors.darkScaffold1 : AppColors.lightScaffold1,
        leading: IconButton(
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              TextButton(
                onPressed: _pickTime,
                style: TextButton.styleFrom(
                  foregroundColor:
                      isDark
                          ? AppColors.darkBackgroundText
                          : AppColors.lightBackgroundText,
                ),
                child: Text(
                  MaterialLocalizations.of(context).formatTimeOfDay(
                    _selectedTime,
                    alwaysUse24HourFormat: use24h,
                  ),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 34,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.03,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 16),
              _daySelector(isDark),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _addAlarm,
                child: const Text('Add Alarm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
