import 'package:alarm/alarm.dart';
import 'package:awake/extensions/context_extensions.dart';
import 'package:awake/services/alarm_cubit.dart';
import 'package:awake/theme/app_colors.dart';
import 'package:awake/theme/app_text_styles.dart';
import 'package:awake/widgets/gradient_linear_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TapAlarmScreen extends StatefulWidget {
  final AlarmSettings alarmSettings;

  const TapAlarmScreen({super.key, required this.alarmSettings});

  @override
  State<TapAlarmScreen> createState() => _TapAlarmScreenState();
}

class _TapAlarmScreenState extends State<TapAlarmScreen> {
  int _tapCount = 0;
  static const int _requiredTaps = 50;

  Future<void> _onTap() async {
    setState(() => _tapCount++);
    if (_tapCount >= _requiredTaps) {
      await context.read<AlarmCubit>().stopAlarm(widget.alarmSettings.id);
      if (mounted) {
        context.pop();
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
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _onTap,
            child: Column(
              children: [
                const Spacer(),
                Text(
                  widget.alarmSettings.notificationSettings.body,
                  style: AppTextStyles.large(context),
                ),
                const SizedBox(height: 20),
                Text('Tap the screen!', style: AppTextStyles.large(context)),
                const SizedBox(height: 20),
                Text(
                  'Taps: $_tapCount / $_requiredTaps',
                  style: AppTextStyles.large(context),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: GradientLinearProgressIndicator(
                    value: _tapCount / _requiredTaps,
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
