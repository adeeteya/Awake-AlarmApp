import 'dart:async';
import 'dart:math';

import 'package:alarm/alarm.dart';
import 'package:awake/extensions/context_extensions.dart';
import 'package:awake/services/alarm_cubit.dart';
import 'package:awake/theme/app_colors.dart';
import 'package:awake/theme/app_text_styles.dart';
import 'package:awake/widgets/stop_alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MathAlarmScreen extends StatefulWidget {
  final AlarmSettings alarmSettings;
  const MathAlarmScreen({super.key, required this.alarmSettings});

  @override
  State<MathAlarmScreen> createState() => _MathAlarmScreenState();
}

enum _Operation { add, subtract, multiply, divide }

class _MathAlarmScreenState extends State<MathAlarmScreen> {
  late final int _a;
  late final int _b;
  late final _Operation _op;
  String _input = '';
  String? _error;

  @override
  void initState() {
    super.initState();
    final rnd = Random();
    _op = _Operation.values[rnd.nextInt(_Operation.values.length)];
    switch (_op) {
      case _Operation.add:
        _a = rnd.nextInt(20) + 1;
        _b = rnd.nextInt(20) + 1;
        break;
      case _Operation.subtract:
        _a = rnd.nextInt(20) + 10;
        _b = rnd.nextInt(_a) + 1;
        break;
      case _Operation.multiply:
        _a = rnd.nextInt(12) + 1;
        _b = rnd.nextInt(12) + 1;
        break;
      case _Operation.divide:
        _b = rnd.nextInt(9) + 2; // avoid divide by 1
        final res = rnd.nextInt(12) + 1;
        _a = res * _b;
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _tryStop() async {
    final answer = int.tryParse(_input);
    int correct;
    switch (_op) {
      case _Operation.add:
        correct = _a + _b;
        break;
      case _Operation.subtract:
        correct = _a - _b;
        break;
      case _Operation.multiply:
        correct = _a * _b;
        break;
      case _Operation.divide:
        correct = _a ~/ _b;
        break;
    }
    if (answer == correct) {
      await context.read<AlarmCubit>().stopAlarm(widget.alarmSettings.id);
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      setState(() => _error = 'Wrong answer');
    }
  }

  void _onKeyPressed(String value) {
    setState(() {
      _error = null;
      if (value == 'DEL') {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else if (_input.length < 3) {
        _input += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    final symbol = switch (_op) {
      _Operation.add => '+',
      _Operation.subtract => '-',
      _Operation.multiply => '×',
      _Operation.divide => '÷',
    };
    return PopScope(
      canPop: false,
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
              Text(
                widget.alarmSettings.notificationSettings.body,
                style: AppTextStyles.large(context),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Solve: $_a $symbol $_b = ',
                    style: AppTextStyles.large(context),
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                    width: 100,
                    height: 40,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBlueGrey,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          _input.isEmpty ? '?' : _input,
                          style: AppTextStyles.large(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 20),
              _NumberPad(onKeyTap: _onKeyPressed, isDark: isDark),
              const SizedBox(height: 20),
              GestureDetector(onTap: _tryStop, child: const StopButton()),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _NumberPad extends StatelessWidget {
  final void Function(String key) onKeyTap;
  final bool isDark;

  const _NumberPad({required this.onKeyTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor =
        isDark ? AppColors.darkBackgroundText : AppColors.lightBackgroundText;
    Widget buildButton(String label) {
      return Padding(
        padding: const EdgeInsets.all(6),
        child: IconButton(
          tooltip: label == 'DEL' ? 'Delete' : 'Number $label',
          style: IconButton.styleFrom(
            backgroundColor:
                isDark ? AppColors.darkScaffold1 : AppColors.lightContainer1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBlueGrey,
              ),
            ),
            fixedSize: const Size(70, 70),
          ),
          onPressed: () {
            unawaited(HapticFeedback.selectionClick());
            onKeyTap(label);
          },
          icon: Text(
            label == 'DEL' ? '⌫' : label,
            style: AppTextStyles.large(context).copyWith(color: textColor),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [buildButton('1'), buildButton('2'), buildButton('3')],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [buildButton('4'), buildButton('5'), buildButton('6')],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [buildButton('7'), buildButton('8'), buildButton('9')],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [buildButton('DEL'), buildButton('0')],
        ),
      ],
    );
  }
}
