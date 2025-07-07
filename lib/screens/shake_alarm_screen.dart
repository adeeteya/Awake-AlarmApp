import 'dart:async';
import 'dart:math';

import 'package:alarm/alarm.dart';
import 'package:awake/extensions/context_extensions.dart';
import 'package:awake/services/alarm_cubit.dart';
import 'package:awake/theme/app_colors.dart';
import 'package:awake/widgets/gradient_linear_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeAlarmScreen extends StatefulWidget {
  final AlarmSettings alarmSettings;
  const ShakeAlarmScreen({super.key, required this.alarmSettings});

  @override
  State<ShakeAlarmScreen> createState() => _ShakeAlarmScreenState();
}

class _ShakeAlarmScreenState extends State<ShakeAlarmScreen> {
  late final StreamSubscription<AccelerometerEvent> _subscription;
  int _shakeCount = 0;
  static const int _requiredShakes = 10;
  static const double _threshold = 2;

  @override
  void initState() {
    super.initState();
    _subscription = accelerometerEventStream().listen(_onData);
  }

  Future<void> _onData(AccelerometerEvent event) async {
    final double gX = event.x / 9.81;
    final double gY = event.y / 9.81;
    final double gZ = event.z / 9.81;
    final double gForce = sqrt(gX * gX + gY * gY + gZ * gZ);
    if (gForce > _threshold) {
      setState(() {
        _shakeCount++;
      });
      if (_shakeCount >= _requiredShakes) {
        await _subscription.cancel();
        if (mounted) {
          await context.read<AlarmCubit>().stopAlarm(widget.alarmSettings.id);
          if (mounted) {
            Navigator.pop(context);
          }
        }
      }
    }
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
              colors:
                  isDark
                      ? [AppColors.darkScaffold1, AppColors.darkScaffold2]
                      : [AppColors.lightScaffold1, AppColors.lightScaffold2],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Lottie.asset("assets/lottie/phone_vibrate.json"),
                const SizedBox(height: 20),
                Text(
                  'Shake the phone!',
                  style: TextStyle(
                    color:
                        isDark
                            ? AppColors.darkBackgroundText
                            : AppColors.lightBackgroundText,
                    fontSize: 24,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Shakes: $_shakeCount / $_requiredShakes',
                  style: TextStyle(
                    color:
                        isDark
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
                    value: _shakeCount / _requiredShakes,
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
