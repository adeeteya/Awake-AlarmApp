import 'dart:async';
import 'dart:math';
import 'package:alarm/alarm.dart';
import 'package:alarm/utils/alarm_set.dart';
import 'package:awake/constants.dart';
import 'package:awake/services/alarm_permissions.dart';
import 'package:awake/services/alarm_service.dart';
import 'package:awake/widgets/add_alarm.dart';
import 'package:awake/widgets/alarm_tile.dart';
import 'package:awake/widgets/clock.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<AlarmSettings> _alarms = [];
  final _alarmService = AlarmService();
  static StreamSubscription<AlarmSet>? _ringSubscription;
  static StreamSubscription<AlarmSet>? _updateSubscription;

  Future<void> _loadAlarms() async {
    final updatedAlarms = await Alarm.getAlarms();
    updatedAlarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    setState(() {
      _alarms = updatedAlarms;
    });
  }

  Future<void> _ringingAlarmsChanged(AlarmSet alarms) async {
    debugPrint("Ringing Alarms Changed: $alarms");
  }

  Future<void> _addAlarm() async {
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: "Set Alarm Time",
      confirmText: "Confirm",
    );
    if (timeOfDay != null && mounted) {
      await _alarmService.setPeriodicAlarms(time: timeOfDay);
      unawaited(_loadAlarms());
    }
  }

  Future<void> _deleteAlarm(int id) async {
    await _alarmService.cancelAlarm(id);
  }

  @override
  void initState() {
    super.initState();
    AlarmPermissions.checkNotificationPermission().then(
      (_) => AlarmPermissions.checkAndroidScheduleExactAlarmPermission(),
    );
    unawaited(_loadAlarms());
    _ringSubscription ??= Alarm.ringing.listen(_ringingAlarmsChanged);
    _updateSubscription ??= Alarm.scheduled.listen((_) {
      unawaited(_loadAlarms());
    });
  }

  @override
  void dispose() {
    _ringSubscription?.cancel();
    _updateSubscription?.cancel();
    super.dispose();
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
                      child: Transform.rotate(
                        angle: -pi / 2,
                        child: const ClockWidget(),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: (isDark) ? const Color(0xFF5D666D) : Colors.white,
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
                  child:
                      (_alarms.isEmpty)
                          ? Center(
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
                          )
                          : ListView(
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
                                  Icon(
                                    Icons.more_horiz_rounded,
                                    color:
                                        (isDark)
                                            ? const Color(0xFF8E98A1)
                                            : const Color(0xFF646E82),
                                  ),
                                  const SizedBox(width: 15),
                                ],
                              ),
                              ...[
                                for (
                                  int index = 0;
                                  index < _alarms.length;
                                  index++
                                )
                                  AlarmTile(
                                    alarmSettings: _alarms[index],
                                    onDelete:
                                        () => _deleteAlarm(_alarms[index].id),
                                  ),
                              ],
                            ],
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
