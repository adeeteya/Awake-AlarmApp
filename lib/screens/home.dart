import 'dart:async';
import 'dart:math';

import 'package:alarm/alarm.dart';
import 'package:alarm/utils/alarm_set.dart';
import 'package:awake/extensions/context_extensions.dart';
import 'package:awake/models/alarm_model.dart';
import 'package:awake/models/alarm_screen_type.dart';
import 'package:awake/screens/add_alarm_screen.dart';
import 'package:awake/screens/alarm_ringing_screen.dart';
import 'package:awake/screens/math_alarm_screen.dart';
import 'package:awake/screens/qr_alarm_screen.dart';
import 'package:awake/screens/settings_screen.dart';
import 'package:awake/screens/shake_alarm_screen.dart';
import 'package:awake/screens/tap_alarm_screen.dart';
import 'package:awake/services/alarm_cubit.dart';
import 'package:awake/services/alarm_permissions.dart';
import 'package:awake/services/settings_cubit.dart';
import 'package:awake/theme/app_colors.dart';
import 'package:awake/widgets/add_button.dart';
import 'package:awake/widgets/alarm_tile.dart';
import 'package:awake/widgets/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final StreamSubscription<AlarmSet> _ringSubscription;

  Future<void> _addAlarm() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AddAlarmScreen()));
  }

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

  Future<void> _ringingAlarmsChanged(AlarmSet alarms) async {
    if (alarms.alarms.isEmpty) return;
    final screenType = context.read<SettingsCubit>().state.alarmScreenType;
    Widget screen = AlarmRingingScreen(alarmSettings: alarms.alarms.first);
    if (screenType == AlarmScreenType.math) {
      screen = MathAlarmScreen(alarmSettings: alarms.alarms.first);
    } else if (screenType == AlarmScreenType.shake) {
      screen = ShakeAlarmScreen(alarmSettings: alarms.alarms.first);
    } else if (screenType == AlarmScreenType.qr) {
      screen = QrAlarmScreen(alarmSettings: alarms.alarms.first);
    } else if (screenType == AlarmScreenType.tap) {
      screen = TapAlarmScreen(alarmSettings: alarms.alarms.first);
    }
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: IconButton(
        tooltip: "Add Alarm",
        onPressed: _addAlarm,
        icon: const AddButton(),
      ),
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
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double radius = min(
                      constraints.maxHeight,
                      constraints.maxWidth,
                    );
                    return Container(
                      height: radius,
                      width: radius,
                      margin: const EdgeInsets.all(15),
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
                    );
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: DecoratedBox(
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
                          child: Text(
                            "No Alarms Added Yet",
                            style: TextStyle(
                              color:
                                  isDark
                                      ? AppColors.darkBackgroundText
                                      : AppColors.lightBackgroundText,
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.03,
                            ),
                          ),
                        );
                      } else {
                        return ListView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 24,
                          ),
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 15),
                                Text(
                                  "Alarms",
                                  style: TextStyle(
                                    color:
                                        isDark
                                            ? AppColors.darkBackgroundText
                                            : AppColors.lightBackgroundText,
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.03,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.settings),
                                  tooltip: "Settings",
                                  onPressed: () async {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const SettingsScreen(),
                                      ),
                                    );
                                  },
                                  style: IconButton.styleFrom(
                                    foregroundColor:
                                        isDark
                                            ? AppColors.darkBackgroundText
                                            : AppColors.lightBackgroundText,
                                  ),
                                ),
                                const SizedBox(width: 15),
                              ],
                            ),
                            ...[
                              for (
                                int index = 0;
                                index < alarms.length;
                                index++
                              )
                                AlarmTile(
                                  key: ValueKey(alarms[index].timeOfDay),
                                  alarmModel: alarms[index],
                                  onEnabledChanged:
                                      (v) => context
                                          .read<AlarmCubit>()
                                          .toggleAlarmEnabled(
                                            alarms[index].timeOfDay,
                                            v,
                                          ),
                                  onDaysChanged:
                                      (days) => context
                                          .read<AlarmCubit>()
                                          .updateAlarmDays(
                                            alarms[index].timeOfDay,
                                            days,
                                          ),
                                  onDelete:
                                      () => context
                                          .read<AlarmCubit>()
                                          .deleteAlarmModel(alarms[index]),
                                ),
                            ],
                          ],
                        );
                      }
                    },
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
