import 'package:isar/isar.dart';

part 'alarm.g.dart';

@collection
class Alarm {
  Id id = Isar.autoIncrement;

  int hour;

  int minute;

  DateTime? dateTime;

  bool repeat;

  List<bool>? repeatDays;

  bool isTurnedOn;

  Alarm(this.hour, this.minute,
      {this.dateTime,
      this.repeat = true,
      this.repeatDays,
      this.isTurnedOn = true});
}
