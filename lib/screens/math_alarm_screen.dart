import 'dart:math';

import 'package:alarm/alarm.dart';
import 'package:awake/extensions/context_extensions.dart';
import 'package:awake/services/alarm_cubit.dart';
import 'package:awake/theme/app_colors.dart';
import 'package:awake/widgets/stop_alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MathAlarmScreen extends StatefulWidget {
  final AlarmSettings alarmSettings;
  const MathAlarmScreen({super.key, required this.alarmSettings});

  @override
  State<MathAlarmScreen> createState() => _MathAlarmScreenState();
}

class _MathAlarmScreenState extends State<MathAlarmScreen> {
  late final int _a;
  late final int _b;
  final TextEditingController _controller = TextEditingController();
  String? _error;

  @override
  void initState() {
    super.initState();
    final rnd = Random();
    _a = rnd.nextInt(10) + 1;
    _b = rnd.nextInt(10) + 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _tryStop() async {
    final answer = int.tryParse(_controller.text);
    if (answer == _a + _b) {
      await context.read<AlarmCubit>().stopAlarm(widget.alarmSettings.id);
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      setState(() => _error = 'Wrong answer');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors:
                  isDark
                      ? [AppColors.darkScaffold1, AppColors.darkScaffold2]
                      : [AppColors.lightScaffold1, AppColors.lightScaffold2],
            ),
          ),
          child: Column(
            children: [
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Solve: $_a + $_b = ',
                    style: TextStyle(
                      color:
                          isDark
                              ? AppColors.darkBackgroundText
                              : AppColors.lightBackgroundText,
                      fontSize: 24,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      autofocus: true,
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onEditingComplete: _tryStop,
                      onSubmitted: (_) => _tryStop,
                      style: TextStyle(
                        color:
                            isDark
                                ? AppColors.darkBackgroundText
                                : AppColors.lightBackgroundText,
                      ),
                      decoration: InputDecoration(
                        hintText: '?',
                        errorText: _error,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              GestureDetector(onTap: _tryStop, child: const StopButton()),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
