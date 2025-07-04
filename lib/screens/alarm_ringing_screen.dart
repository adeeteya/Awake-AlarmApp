import 'package:alarm/alarm.dart';
import 'package:awake/constants.dart';
import 'package:awake/services/alarm_cubit.dart';
import 'package:awake/widgets/snooze_button.dart';
import 'package:awake/widgets/stop_alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class AlarmRingingScreen extends StatelessWidget {
  final AlarmSettings alarmSettings;
  const AlarmRingingScreen({super.key, required this.alarmSettings});

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                (isDark)
                    ? [darkScaffoldGradient1Color, darkScaffoldGradient2Color]
                    : [
                      lightScaffoldGradient1Color,
                      lightScaffoldGradient2Color,
                    ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset("assets/lottie/clock.json"),
              Spacer(),
              GestureDetector(
                onTap: () {
                  context.read<AlarmCubit>().stopAlarm(alarmSettings.id);
                  Navigator.pop(context);
                },
                child: StopButton(),
              ),
              Spacer(flex: 2),
              SnoozeButton(
                onSnoozePressed: (snoozeMinutes) {
                  context.read<AlarmCubit>().snoozeAlarm(
                    alarmSettings: alarmSettings,
                    snoozeMinutes: snoozeMinutes,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Alarm snoozed for $snoozeMinutes minutes"),
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
