import 'dart:async';
import 'dart:math';
import 'package:alarm/alarm.dart';
import 'package:alarm/utils/alarm_set.dart';
import 'package:awake/constants.dart';
import 'package:awake/models/alarm_model.dart';
import 'package:awake/screens/alarm_ringing_screen.dart';
import 'package:awake/screens/settings_screen.dart';
import 'package:awake/services/alarm_permissions.dart';
import 'package:awake/services/alarm_cubit.dart';
import 'package:awake/widgets/add_alarm.dart';
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
    final bool isDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: _addAlarm,
        child: const AddAlarmButton(),
      ),
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
                                  ? [
                                    const Color(0xFF3E464F),
                                    const Color(0xFF424A53),
                                  ]
                                  : [
                                    const Color(0xFFF1F2F7),
                                    const Color(0xFFECEEF3),
                                  ],
                        ),
                        boxShadow:
                            (isDark)
                                ? [
                                  BoxShadow(
                                    offset: const Offset(19, 25),
                                    blurRadius: 92,
                                    spreadRadius: -32,
                                    color: const Color(
                                      0xFF23282D,
                                    ).withValues(alpha: 0.35),
                                  ),
                                  BoxShadow(
                                    offset: const Offset(-20, -20),
                                    blurRadius: 61,
                                    color: const Color(
                                      0xFF48535C,
                                    ).withValues(alpha: 0.25),
                                  ),
                                  BoxShadow(
                                    offset: const Offset(13, 14),
                                    blurRadius: 12,
                                    spreadRadius: -6,
                                    color: const Color(
                                      0xFF23282D,
                                    ).withValues(alpha: 0.50),
                                  ),
                                ]
                                : [
                                  BoxShadow(
                                    offset: const Offset(19, 25),
                                    blurRadius: 92,
                                    spreadRadius: -32,
                                    color: const Color(
                                      0xFFA6B4C8,
                                    ).withValues(alpha: 0.45),
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
                                    color: const Color(
                                      0xFFA6B4C8,
                                    ).withValues(alpha: 0.57),
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
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            (isDark) ? const Color(0xFF5D666D) : Colors.white,
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
                                  darkScaffoldGradient1Color,
                                  darkScaffoldGradient2Color,
                                ]
                                : [
                                  lightContainerGradient1Color,
                                  lightContainerGradient2Color,
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
                                        ? const Color(0xFF8E98A1)
                                        : const Color(0xFF646E82),
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
                                              ? const Color(0xFF8E98A1)
                                              : const Color(0xFF646E82),
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
                                              (context) => SettingsScreen(),
                                        ),
                                      );
                                    },
                                    style: IconButton.styleFrom(
                                      foregroundColor:
                                          (isDark)
                                              ? const Color(0xFF8E98A1)
                                              : const Color(0xFF646E82),
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
            ],
          ),
        ),
      ),
    );
  }
}
