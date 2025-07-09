import 'package:alarm/alarm.dart';
import 'package:awake/extensions/context_extensions.dart';
import 'package:awake/services/alarm_cubit.dart';
import 'package:awake/theme/app_colors.dart';
import 'package:awake/theme/app_text_styles.dart';
import 'package:awake/widgets/snooze_button.dart';
import 'package:awake/widgets/stop_alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class AlarmRingingScreen extends StatelessWidget {
  final AlarmSettings alarmSettings;
  const AlarmRingingScreen({super.key, required this.alarmSettings});

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Lottie.asset(
                "assets/lottie/clock.json",
                fit: BoxFit.scaleDown,
                width: 150,
              ),
              const SizedBox(height: 20),
              Text(
                alarmSettings.notificationSettings.body,
                style: AppTextStyles.large(context),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  await context.read<AlarmCubit>().stopAlarm(alarmSettings.id);
                  if (context.mounted) {
                    context.pop();
                  }
                },
                child: const StopButton(),
              ),
              const Spacer(),
              SnoozeButton(
                onSnoozePressed: (snoozeMinutes) async {
                  await context.read<AlarmCubit>().snoozeAlarm(
                    alarmSettings: alarmSettings,
                    snoozeMinutes: snoozeMinutes,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Alarm snoozed for $snoozeMinutes minutes",
                        ),
                      ),
                    );
                    context.pop();
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
