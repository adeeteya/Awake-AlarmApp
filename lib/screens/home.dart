import 'dart:async';
import 'dart:math';
import 'package:alarm/alarm.dart';
import 'package:alarm/utils/alarm_set.dart';
import 'package:awake/extensions/context_extensions.dart';
import 'package:awake/theme/app_colors.dart';
import 'package:awake/models/alarm_model.dart';
import 'package:awake/screens/alarm_ringing_screen.dart';
import 'package:awake/screens/settings_screen.dart';
import 'package:awake/services/alarm_permissions.dart';
import 'package:awake/services/alarm_cubit.dart';
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
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: "Set Alarm Time",
      confirmText: "Confirm",
    );
    if (timeOfDay != null && mounted) {
      await context.read<AlarmCubit>().setPeriodicAlarms(timeOfDay: timeOfDay);
    }
  }

  @override
  void initState() {
    super.initState();
    AlarmPermissions.checkNotificationPermission().then(
      (_) => AlarmPermissions.checkAndroidScheduleExactAlarmPermission(),
    );
    _ringSubscription = Alarm.ringing.listen(_ringingAlarmsChanged);
  }

  @override
  void dispose() {
    _ringSubscription.cancel();
    super.dispose();
  }

  Future<void> _ringingAlarmsChanged(AlarmSet alarms) async {
    if (alarms.alarms.isEmpty) return;
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder:
            (context) => AlarmRingingScreen(alarmSettings: alarms.alarms.first),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: _addAlarm,
        child: AddButton(),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                (isDark)
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
                    double radius = min(
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
                              (isDark)
                                  ? [AppColors.darkClock1, AppColors.darkClock2]
                                  : [
                                    AppColors.lightClock1,
                                    AppColors.lightClock2,
                                  ],
                        ),
                        boxShadow:
                            (isDark)
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
                child: Hero(
                  tag: "InnerDecoratedBox",
                  child: Material(
                    type: MaterialType.transparency,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: (isDark) ? AppColors.darkBorder : Colors.white,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors:
                              (isDark)
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
                                      (isDark)
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
                                            (isDark)
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
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    const SettingsScreen(),
                                          ),
                                        );
                                      },
                                      style: IconButton.styleFrom(
                                        foregroundColor:
                                            (isDark)
                                                ? AppColors.darkBackgroundText
                                                : AppColors.lightBackgroundText,
                                      ),
                                      icon: Icon(Icons.settings),
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
                                      alarmModel: alarms[index],
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
