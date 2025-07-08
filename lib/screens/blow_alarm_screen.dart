import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:awake/extensions/context_extensions.dart';
import 'package:awake/services/alarm_cubit.dart';
import 'package:awake/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';

class BlowAlarmScreen extends StatefulWidget {
  final AlarmSettings alarmSettings;
  const BlowAlarmScreen({super.key, required this.alarmSettings});

  @override
  State<BlowAlarmScreen> createState() => _BlowAlarmScreenState();
}

class _BlowAlarmScreenState extends State<BlowAlarmScreen> {
  late final NoiseMeter _noiseMeter;
  StreamSubscription<NoiseReading>? _subscription;
  int _blowCount = 0;
  static const int _requiredBlows = 3;
  static const double _threshold = 80; // decibels

  @override
  void initState() {
    super.initState();
    _noiseMeter = NoiseMeter();
    unawaited(_startListening());
  }

  Future<void> _startListening() async {
    final status = await Permission.microphone.status;
    if (status.isDenied) await Permission.microphone.request();
    if (!mounted) return;
    try {
      _subscription = _noiseMeter.noise.listen(_onData);
    } catch (_) {}
  }

  Future<void> _onData(NoiseReading reading) async {
    if (reading.meanDecibel > _threshold) {
      await _subscription?.cancel();
      setState(() => _blowCount++);
      if (_blowCount >= _requiredBlows) {
        // ignore: use_build_context_synchronously
        final cubit = context.read<AlarmCubit>();
        await cubit.stopAlarm(widget.alarmSettings.id);
        if (!mounted) return;
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        await _startListening();
      }
    }
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Icon(
                Icons.mic,
                color: isDark
                    ? AppColors.darkBackgroundText
                    : AppColors.lightBackgroundText,
                size: 100,
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
                'Blows: $_blowCount / $_requiredBlows',
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkBackgroundText
                      : AppColors.lightBackgroundText,
                  fontSize: 24,
                  fontFamily: 'Poppins',
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
