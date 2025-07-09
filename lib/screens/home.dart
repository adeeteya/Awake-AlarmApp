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
  bool _isFabVisibile = true;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<AlarmModel> _alarms = <AlarmModel>[];

  @override
  void initState() {
    super.initState();
    unawaited(
      AlarmPermissions.checkNotificationPermission().then(
        (_) => AlarmPermissions.checkAndroidScheduleExactAlarmPermission(),
      ),
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

  void _updateAlarms(List<AlarmModel> newAlarms) {
    final AnimatedListState? list = _listKey.currentState;
    for (int i = _alarms.length - 1; i >= 0; i--) {
      final alarm = _alarms[i];
      final exists = newAlarms.any((a) => a.timeOfDay == alarm.timeOfDay);
      if (!exists) {
        final removed = _alarms.removeAt(i);
        list?.removeItem(
          i,
          (context, animation) => SizeTransition(
            sizeFactor: animation,
            child: AlarmTile(
              key: ValueKey(removed.timeOfDay),
              alarmModel: removed,
              onEnabledChanged:
                  (v) => context.read<AlarmCubit>().toggleAlarmEnabled(
                    removed.timeOfDay,
                    v,
                  ),
              onDaysChanged:
                  (days) => context.read<AlarmCubit>().updateAlarmDays(
                    removed.timeOfDay,
                    days,
                  ),
              onDelete:
                  () => context.read<AlarmCubit>().deleteAlarmModel(removed),
            ),
          ),
        );
      }
    }

    for (int i = 0; i < newAlarms.length; i++) {
      final alarm = newAlarms[i];
      final index = _alarms.indexWhere((a) => a.timeOfDay == alarm.timeOfDay);
      if (index == -1) {
        _alarms.insert(i, alarm);
        list?.insertItem(i);
      } else {
        _alarms[index] = alarm;
        if (index != i) {
          final moved = _alarms.removeAt(index);
          _alarms.insert(i, moved);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          _isFabVisibile
              ? IconButton(
                tooltip: "Add Alarm",
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
                      _isFabVisibile = false;
                    } else if (direction == ScrollDirection.forward) {
                      _isFabVisibile = true;
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
                        child: BlocConsumer<AlarmCubit, List<AlarmModel>>(
                          listenWhen:
                              (previous, current) => previous != current,
                          listener: (context, alarms) {
                            WidgetsBinding.instance.addPostFrameCallback(
                              (_) => _updateAlarms(alarms),
                            );
                          },
                          buildWhen: (previous, current) => previous != current,
                          builder: (context, alarms) {
                            if (_alarms.isEmpty) {
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
                                      "No Alarms Added Yet",
                                      style: AppTextStyles.heading(context),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return CustomScrollView(
                                controller: scrollController,
                                slivers: [
                                  SliverPadding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      top: 24,
                                    ),
                                    sliver: SliverToBoxAdapter(
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 15),
                                          Text(
                                            "Alarms",
                                            style: AppTextStyles.heading(
                                              context,
                                            ),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            icon: const Icon(Icons.settings),
                                            tooltip: "Settings",
                                            onPressed:
                                                () => context.goNamed(
                                                  AppRoute.settings.name,
                                                ),
                                            style: IconButton.styleFrom(
                                              foregroundColor:
                                                  isDark
                                                      ? AppColors
                                                          .darkBackgroundText
                                                      : AppColors
                                                          .lightBackgroundText,
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SliverPadding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    sliver: SliverAnimatedList(
                                      key: _listKey,
                                      initialItemCount: _alarms.length,
                                      itemBuilder: (context, index, animation) {
                                        final alarm = _alarms[index];
                                        return SizeTransition(
                                          sizeFactor: animation,
                                          child: AlarmTile(
                                            key: ValueKey(alarm.timeOfDay),
                                            alarmModel: alarm,
                                            onEnabledChanged:
                                                (v) => context
                                                    .read<AlarmCubit>()
                                                    .toggleAlarmEnabled(
                                                      alarm.timeOfDay,
                                                      v,
                                                    ),
                                            onDaysChanged:
                                                (days) => context
                                                    .read<AlarmCubit>()
                                                    .updateAlarmDays(
                                                      alarm.timeOfDay,
                                                      days,
                                                    ),
                                            onDelete:
                                                () => context
                                                    .read<AlarmCubit>()
                                                    .deleteAlarmModel(alarm),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SliverPadding(
                                    padding: EdgeInsets.only(bottom: 24),
                                  ),
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
