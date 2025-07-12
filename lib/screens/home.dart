import 'dart:async';
import 'dart:math';

import 'package:alarm/alarm.dart';
import 'package:alarm/utils/alarm_set.dart';
import 'package:awake/app_router.dart';
import 'package:awake/extensions/context_extensions.dart';
import 'package:awake/models/alarm_model.dart';
import 'package:awake/models/alarm_screen_type.dart';
import 'package:awake/services/alarm_cubit.dart';
import 'package:awake/services/alarm_permissions.dart';
import 'package:awake/services/settings_cubit.dart';
import 'package:awake/theme/app_colors.dart';
import 'package:awake/theme/app_text_styles.dart';
import 'package:awake/widgets/add_button.dart';
import 'package:awake/widgets/alarm_tile.dart';
import 'package:awake/widgets/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final StreamSubscription<AlarmSet> _ringSubscription;
  bool _isFabVisible = true;

  DateTime _nextOccurrence(AlarmModel alarm) {
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final candidate = DateTime(
        now.year,
        now.month,
        now.day,
        alarm.timeOfDay.hour,
        alarm.timeOfDay.minute,
      ).add(Duration(days: i));
      if (!alarm.days.contains(candidate.weekday)) continue;
      if (i == 0 && candidate.isBefore(now)) continue;
      return candidate;
    }
    return DateTime(
      now.year,
      now.month,
      now.day,
      alarm.timeOfDay.hour,
      alarm.timeOfDay.minute,
    );
  }

  @override
  void initState() {
    super.initState();
    unawaited(
      AlarmPermissions.checkNotificationPermission()
          .then(
            (_) => AlarmPermissions.checkAndroidScheduleExactAlarmPermission(),
          )
          .then((_) => AlarmPermissions.checkAutoStartPermission())
          .then((_) => AlarmPermissions.checkBatteryOptimization()),
    );
    _ringSubscription = Alarm.ringing.listen(_ringingAlarmsChanged);
  }

  @override
  void dispose() {
    unawaited(_ringSubscription.cancel());
    super.dispose();
  }

  void _ringingAlarmsChanged(AlarmSet alarms) {
    if (alarms.alarms.isEmpty) return;
    final screenType = context.read<SettingsCubit>().state.alarmScreenType;
    final name = switch (screenType) {
      AlarmScreenType.math => AppRoute.mathAlarm.name,
      AlarmScreenType.shake => AppRoute.shakeAlarm.name,
      AlarmScreenType.qr => AppRoute.qrAlarm.name,
      AlarmScreenType.tap => AppRoute.tapAlarm.name,
      _ => AppRoute.alarmRinging.name,
    };
    context.goNamed(name, extra: alarms.alarms.first);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          _isFabVisible
              ? IconButton(
                tooltip: context.localization.addAlarm,
                onPressed: () => context.goNamed(AppRoute.addAlarm.name),
                icon: const AddButton(),
              )
              : null,
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
        child: SafeArea(
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: SizedBox(
                  height: size.height * 0.33,
                  width: size.height * 0.33,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors:
                              isDark
                                  ? [AppColors.darkClock1, AppColors.darkClock2]
                                  : [
                                    AppColors.lightClock1,
                                    AppColors.lightClock2,
                                  ],
                        ),
                        boxShadow:
                            isDark
                                ? [
                                  BoxShadow(
                                    offset: const Offset(19, 25),
                                    blurRadius: 92,
                                    spreadRadius: -32,
                                    color: AppColors.shadowDark.withValues(
                                      alpha: 0.35,
                                    ),
                                  ),
                                  BoxShadow(
                                    offset: const Offset(-20, -20),
                                    blurRadius: 61,
                                    color: AppColors.darkGrey.withValues(
                                      alpha: 0.25,
                                    ),
                                  ),
                                  BoxShadow(
                                    offset: const Offset(13, 14),
                                    blurRadius: 12,
                                    spreadRadius: -6,
                                    color: AppColors.shadowDark.withValues(
                                      alpha: 0.50,
                                    ),
                                  ),
                                ]
                                : [
                                  BoxShadow(
                                    offset: const Offset(19, 25),
                                    blurRadius: 92,
                                    spreadRadius: -32,
                                    color: AppColors.shadowLight.withValues(
                                      alpha: 0.45,
                                    ),
                                  ),
                                  BoxShadow(
                                    offset: const Offset(-20, -20),
                                    blurRadius: 61,
                                    color: Colors.white.withValues(alpha: 0.53),
                                  ),
                                  BoxShadow(
                                    offset: const Offset(13, 14),
                                    blurRadius: 12,
                                    spreadRadius: -6,
                                    color: AppColors.shadowLight.withValues(
                                      alpha: 0.57,
                                    ),
                                  ),
                                ],
                        shape: BoxShape.circle,
                      ),
                      child: RepaintBoundary(
                        child: Transform.rotate(
                          angle: -pi / 2,
                          child: const ClockWidget(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              NotificationListener<UserScrollNotification>(
                onNotification: (notification) {
                  final ScrollDirection direction = notification.direction;
                  setState(() {
                    if (direction == ScrollDirection.reverse) {
                      _isFabVisible = false;
                    } else if (direction == ScrollDirection.forward) {
                      _isFabVisible = true;
                    }
                  });
                  return true;
                },
                child: DraggableScrollableSheet(
                  minChildSize: 0.65,
                  initialChildSize: 0.65,
                  builder:
                      (context, scrollController) => DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : Colors.white,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors:
                                isDark
                                    ? [
                                      AppColors.darkScaffold1,
                                      AppColors.darkScaffold2,
                                    ]
                                    : [
                                      AppColors.lightContainer1,
                                      AppColors.lightContainer2,
                                    ],
                          ),
                        ),
                        child: BlocBuilder<AlarmCubit, List<AlarmModel>>(
                          buildWhen: (previous, current) => previous != current,
                          builder: (context, alarms) {
                            if (alarms.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Lottie.asset(
                                      "assets/lottie/monkey_head_nod.json",
                                      width: 150,
                                      fit: BoxFit.scaleDown,
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      context.localization.noAlarms,
                                      style: AppTextStyles.heading(context),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              final sortedAlarms = [...alarms]..sort(
                                (a, b) => _nextOccurrence(
                                  a,
                                ).compareTo(_nextOccurrence(b)),
                              );
                              return ListView(
                                controller: scrollController,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 24,
                                ),
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(width: 15),
                                      Text(
                                        context.localization.alarms,
                                        style: AppTextStyles.heading(context),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        icon: const Icon(Icons.settings),
                                        tooltip: context.localization.settings,
                                        onPressed:
                                            () => context.goNamed(
                                              AppRoute.settings.name,
                                            ),
                                        style: IconButton.styleFrom(
                                          foregroundColor:
                                              isDark
                                                  ? AppColors.darkBackgroundText
                                                  : AppColors
                                                      .lightBackgroundText,
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                    ],
                                  ),
                                  ...[
                                    for (
                                      int index = 0;
                                      index < sortedAlarms.length;
                                      index++
                                    )
                                      AlarmTile(
                                        key: ValueKey(
                                          sortedAlarms[index].timeOfDay,
                                        ),
                                        alarmModel: sortedAlarms[index],
                                        onEnabledChanged:
                                            (v) => context
                                                .read<AlarmCubit>()
                                                .toggleAlarmEnabled(
                                                  sortedAlarms[index].timeOfDay,
                                                  v,
                                                ),
                                        onDaysChanged:
                                            (days) => context
                                                .read<AlarmCubit>()
                                                .updateAlarmDays(
                                                  sortedAlarms[index].timeOfDay,
                                                  days,
                                                ),
                                        onDelete:
                                            () => context
                                                .read<AlarmCubit>()
                                                .deleteAlarmModel(
                                                  sortedAlarms[index],
                                                ),
                                      ),
                                  ],
                                ],
                              );
                            }
                          },
                        ),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
