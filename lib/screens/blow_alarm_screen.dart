import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:awake/extensions/context_extensions.dart';
import 'package:awake/services/alarm_cubit.dart';
import 'package:awake/theme/app_colors.dart';
import 'package:awake/widgets/gradient_linear_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';

class BlowAlarmScreen extends StatefulWidget {
  final AlarmSettings alarmSettings;
  const BlowAlarmScreen({super.key, required this.alarmSettings});

  @override
  State<BlowAlarmScreen> createState() => _BlowAlarmScreenState();
}

class _BlowAlarmScreenState extends State<BlowAlarmScreen> {
  final AudioRecorder _recorder = AudioRecorder();
  StreamSubscription<Amplitude>? _subscription;
  int _blowCount = 0;
  static const int _requiredBlows = 3;
  static const double _thresholdDb = -10.0;
  DateTime? _lastBlow;

  @override
  void initState() {
    super.initState();
    unawaited(_start());
  }

  Future<void> _start() async {
    if (await _recorder.hasPermission()) {
      await _recorder.startStream(const RecordConfig());
      _subscription = _recorder
          .onAmplitudeChanged(const Duration(milliseconds: 100))
          .listen(_onAmplitude);
    }
  }

  Future<void> _onAmplitude(Amplitude amplitude) async {
    if (amplitude.current > _thresholdDb) {
      final now = DateTime.now();
      if (_lastBlow == null ||
          now.difference(_lastBlow!) > const Duration(milliseconds: 500)) {
        _lastBlow = now;
        setState(() => _blowCount++);
        if (_blowCount >= _requiredBlows) {
          await _subscription?.cancel();
          await _recorder.stop();
          if (!mounted) return;
          await context.read<AlarmCubit>().stopAlarm(widget.alarmSettings.id);
          if (mounted) {
            Navigator.pop(context);
          }
        }
      }
    }
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    unawaited(_recorder.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [AppColors.darkScaffold1, AppColors.darkScaffold2]
                  : [AppColors.lightScaffold1, AppColors.lightScaffold2],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Icon(
                  Icons.mic,
                  size: 120,
                  color: isDark
                      ? AppColors.darkBackgroundText
                      : AppColors.lightBackgroundText,
                ),
                const SizedBox(height: 20),
                Text(
                  widget.alarmSettings.notificationSettings.body,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkBackgroundText
                        : AppColors.lightBackgroundText,
                    fontSize: 24,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Blow on the microphone!',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkBackgroundText
                        : AppColors.lightBackgroundText,
                    fontSize: 24,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Blows: $_blowCount / $_requiredBlows',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkBackgroundText
                        : AppColors.lightBackgroundText,
                    fontSize: 24,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: GradientLinearProgressIndicator(
                    value: _blowCount / _requiredBlows,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
