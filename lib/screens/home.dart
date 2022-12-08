import 'dart:math';
import 'package:awake/constants.dart';
import 'package:awake/models/alarm.dart';
import 'package:awake/services/notification_service.dart';
import 'package:awake/widgets/add_alarm.dart';
import 'package:awake/widgets/alarm_tile.dart';
import 'package:awake/widgets/clock.dart';
import 'package:awake/widgets/weekday_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:isar/isar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final Isar isar;
  late IsarCollection<Alarm> alarmsCollection;
  NotificationService notificationService = NotificationService();
  List<Alarm> alarmsList = [];

  Future loadData() async {
    isar = await Isar.open([AlarmSchema]);
    alarmsCollection = isar.alarms;
    alarmsList = await alarmsCollection.where().findAll();
    FlutterNativeSplash.remove();
    if (mounted) {
      setState(() {});
    }
  }

  Future setPeriodic(Alarm alarm) async {
    List<DateTime> daysUpcoming = [
      DateTime.now(),
      DateTime.now().add(const Duration(days: 1)),
      DateTime.now().add(const Duration(days: 2)),
      DateTime.now().add(const Duration(days: 3)),
      DateTime.now().add(const Duration(days: 4)),
      DateTime.now().add(const Duration(days: 5)),
      DateTime.now().add(const Duration(days: 6)),
    ];
    for (int i = 0; i < 7; i++) {
      if (alarm.repeatDays![i] == true) {
        DateTime matchingDay;
        if (i == 0) {
          //for sunday
          matchingDay =
              daysUpcoming.firstWhere((element) => element.weekday == 7);
        } else {
          matchingDay =
              daysUpcoming.firstWhere((element) => element.weekday == i);
        }
        await notificationService.showWeeklyRepeatNotification(
          int.parse("${i + 2}${alarm.id}"),
          DateTime(matchingDay.year, matchingDay.month, matchingDay.day,
              alarm.hour, alarm.minute),
        );
      }
    }
  }

  Future cancelPeriodic(int id) async {
    for (int i = 2; i <= 9; i++) {
      notificationService.cancelNotification(int.parse("$i$id"));
    }
  }

  Future addAlarm() async {
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: "Set Alarm Time",
      confirmText: "Next",
    );
    if (timeOfDay == null) return;
    List<bool>? weekDaySelectedList = await weekDayPicker(context: context);
    if (weekDaySelectedList == null) {
      DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        helpText: "Select Alarm Date",
        confirmText: "Set Alarm",
      );
      if (dateTime == null) return;
      //insert into db
      dateTime = dateTime
          .add(Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute));
      Alarm newAlarm = Alarm(timeOfDay.hour, timeOfDay.minute,
          dateTime: dateTime, repeat: false);
      await isar.writeTxn(() async {
        await isar.alarms.put(newAlarm);
      });
      setState(() {
        alarmsList.add(newAlarm);
      });
      notificationService.showScheduledNotification(
          newAlarm.id, newAlarm.dateTime!);
    } else if (weekDaySelectedList.every((element) => element == false)) {
      //no repeat day selected error handling
      return;
    } else {
      //insert into db
      Alarm newAlarm = Alarm(timeOfDay.hour, timeOfDay.minute,
          repeatDays: weekDaySelectedList);
      await isar.writeTxn(() async {
        await isar.alarms.put(newAlarm);
      });
      setState(() {
        alarmsList.add(newAlarm);
      });
      setPeriodic(newAlarm);
    }
  }

  Future updateAlarmState(Alarm alarm, bool isTurnedOn) async {
    await isar.writeTxn(() async {
      alarm.isTurnedOn = isTurnedOn;
      if (isTurnedOn) {
        if (alarm.repeat) {
          setPeriodic(alarm);
        } else {
          notificationService.showScheduledNotification(
              alarm.id, alarm.dateTime!);
        }
      } else {
        if (alarm.repeat) {
          cancelPeriodic(alarm.id);
        } else {
          notificationService.cancelNotification(int.parse("1${alarm.id}"));
        }
      }
      await isar.alarms.put(alarm);
      setState(() {});
    });
  }

  Future deleteAlarm(Alarm alarm) async {
    bool isSuccessful = false;
    await isar.writeTxn(() async {
      isSuccessful = await isar.alarms.delete(alarm.id);
    }).then((value) {
      if (isSuccessful) {
        if (alarm.repeat) {
          cancelPeriodic(alarm.id);
        } else {
          notificationService.cancelNotification(int.parse("1${alarm.id}"));
        }
        setState(() {
          alarmsList.remove(alarm);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Unable To Delete, Some Unknown Error Ocurred")));
      }
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: addAlarm,
        child: const AddAlarmButton(),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: (isDark)
                ? [darkScaffoldGradient1Color, darkScaffoldGradient2Color]
                : [lightScaffoldGradient1Color, lightScaffoldGradient2Color],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double radius =
                        min(constraints.maxHeight, constraints.maxWidth);
                    return Container(
                      height: radius,
                      width: radius,
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: (isDark)
                              ? [
                                  const Color(0xFF3E464F),
                                  const Color(0xFF424A53),
                                ]
                              : [
                                  const Color(0xFFF1F2F7),
                                  const Color(0xFFECEEF3),
                                ],
                        ),
                        boxShadow: (isDark)
                            ? [
                                BoxShadow(
                                  offset: const Offset(19, 25),
                                  blurRadius: 92,
                                  spreadRadius: -32,
                                  color:
                                      const Color(0xFF23282D).withOpacity(0.35),
                                ),
                                BoxShadow(
                                  offset: const Offset(-20, -20),
                                  blurRadius: 61,
                                  color:
                                      const Color(0xFF48535C).withOpacity(0.25),
                                ),
                                BoxShadow(
                                  offset: const Offset(13, 14),
                                  blurRadius: 12,
                                  spreadRadius: -6,
                                  color:
                                      const Color(0xFF23282D).withOpacity(0.50),
                                ),
                              ]
                            : [
                                BoxShadow(
                                  offset: const Offset(19, 25),
                                  blurRadius: 92,
                                  spreadRadius: -32,
                                  color:
                                      const Color(0xFFA6B4C8).withOpacity(0.45),
                                ),
                                BoxShadow(
                                  offset: const Offset(-20, -20),
                                  blurRadius: 61,
                                  color: Colors.white.withOpacity(0.53),
                                ),
                                BoxShadow(
                                  offset: const Offset(13, 14),
                                  blurRadius: 12,
                                  spreadRadius: -6,
                                  color:
                                      const Color(0xFFA6B4C8).withOpacity(0.57),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                      colors: (isDark)
                          ? [
                              darkScaffoldGradient1Color,
                              darkScaffoldGradient2Color,
                            ]
                          : [
                              lightContainerGradient1Color,
                              lightContainerGradient2Color
                            ],
                    ),
                  ),
                  child: (alarmsList.isEmpty)
                      ? Center(
                          child: Text(
                            "No Alarms Added Yet",
                            style: TextStyle(
                              color: (isDark)
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
                          physics: const BouncingScrollPhysics(),
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 15),
                                Text(
                                  "Alarms",
                                  style: TextStyle(
                                    color: (isDark)
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
                                  color: (isDark)
                                      ? const Color(0xFF8E98A1)
                                      : const Color(0xFF646E82),
                                ),
                                const SizedBox(width: 15),
                              ],
                            ),
                            ...[
                              for (int index = 0;
                                  index < alarmsList.length;
                                  index++)
                                AlarmTile(
                                  alarm: alarmsList[index],
                                  onChanged: (val) {
                                    updateAlarmState(alarmsList[index], val);
                                  },
                                  onDelete: () =>
                                      deleteAlarm(alarmsList[index]),
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
