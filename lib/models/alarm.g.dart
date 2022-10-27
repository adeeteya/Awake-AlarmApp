// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetAlarmCollection on Isar {
  IsarCollection<Alarm> get alarms => this.collection();
}

const AlarmSchema = CollectionSchema(
  name: r'Alarm',
  id: -6172094888861729789,
  properties: {
    r'dateTime': PropertySchema(
      id: 0,
      name: r'dateTime',
      type: IsarType.dateTime,
    ),
    r'hour': PropertySchema(
      id: 1,
      name: r'hour',
      type: IsarType.long,
    ),
    r'isTurnedOn': PropertySchema(
      id: 2,
      name: r'isTurnedOn',
      type: IsarType.bool,
    ),
    r'minute': PropertySchema(
      id: 3,
      name: r'minute',
      type: IsarType.long,
    ),
    r'repeat': PropertySchema(
      id: 4,
      name: r'repeat',
      type: IsarType.bool,
    ),
    r'repeatDays': PropertySchema(
      id: 5,
      name: r'repeatDays',
      type: IsarType.boolList,
    )
  },
  estimateSize: _alarmEstimateSize,
  serialize: _alarmSerialize,
  deserialize: _alarmDeserialize,
  deserializeProp: _alarmDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _alarmGetId,
  getLinks: _alarmGetLinks,
  attach: _alarmAttach,
  version: '3.0.2',
);

int _alarmEstimateSize(
  Alarm object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.repeatDays;
    if (value != null) {
      bytesCount += 3 + value.length;
    }
  }
  return bytesCount;
}

void _alarmSerialize(
  Alarm object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.dateTime);
  writer.writeLong(offsets[1], object.hour);
  writer.writeBool(offsets[2], object.isTurnedOn);
  writer.writeLong(offsets[3], object.minute);
  writer.writeBool(offsets[4], object.repeat);
  writer.writeBoolList(offsets[5], object.repeatDays);
}

Alarm _alarmDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Alarm(
    reader.readLong(offsets[1]),
    reader.readLong(offsets[3]),
    dateTime: reader.readDateTimeOrNull(offsets[0]),
    isTurnedOn: reader.readBoolOrNull(offsets[2]) ?? true,
    repeat: reader.readBoolOrNull(offsets[4]) ?? true,
    repeatDays: reader.readBoolList(offsets[5]),
  );
  object.id = id;
  return object;
}

P _alarmDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 5:
      return (reader.readBoolList(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _alarmGetId(Alarm object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _alarmGetLinks(Alarm object) {
  return [];
}

void _alarmAttach(IsarCollection<dynamic> col, Id id, Alarm object) {
  object.id = id;
}

extension AlarmQueryWhereSort on QueryBuilder<Alarm, Alarm, QWhere> {
  QueryBuilder<Alarm, Alarm, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AlarmQueryWhere on QueryBuilder<Alarm, Alarm, QWhereClause> {
  QueryBuilder<Alarm, Alarm, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AlarmQueryFilter on QueryBuilder<Alarm, Alarm, QFilterCondition> {
  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> dateTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateTime',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> dateTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateTime',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> dateTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> dateTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> dateTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> dateTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> hourEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hour',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> hourGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hour',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> hourLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hour',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> hourBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> isTurnedOnEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isTurnedOn',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> minuteEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'minute',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> minuteGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'minute',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> minuteLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'minute',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> minuteBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'minute',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> repeatEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repeat',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> repeatDaysIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'repeatDays',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> repeatDaysIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'repeatDays',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> repeatDaysElementEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repeatDays',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> repeatDaysLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'repeatDays',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> repeatDaysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'repeatDays',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> repeatDaysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'repeatDays',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> repeatDaysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'repeatDays',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> repeatDaysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'repeatDays',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> repeatDaysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'repeatDays',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension AlarmQueryObject on QueryBuilder<Alarm, Alarm, QFilterCondition> {}

extension AlarmQueryLinks on QueryBuilder<Alarm, Alarm, QFilterCondition> {}

extension AlarmQuerySortBy on QueryBuilder<Alarm, Alarm, QSortBy> {
  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hour', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hour', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByIsTurnedOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTurnedOn', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByIsTurnedOnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTurnedOn', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minute', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minute', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByRepeat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeat', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByRepeatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeat', Sort.desc);
    });
  }
}

extension AlarmQuerySortThenBy on QueryBuilder<Alarm, Alarm, QSortThenBy> {
  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hour', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hour', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByIsTurnedOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTurnedOn', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByIsTurnedOnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTurnedOn', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minute', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minute', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByRepeat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeat', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByRepeatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeat', Sort.desc);
    });
  }
}

extension AlarmQueryWhereDistinct on QueryBuilder<Alarm, Alarm, QDistinct> {
  QueryBuilder<Alarm, Alarm, QDistinct> distinctByDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateTime');
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hour');
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByIsTurnedOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isTurnedOn');
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'minute');
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByRepeat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'repeat');
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByRepeatDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'repeatDays');
    });
  }
}

extension AlarmQueryProperty on QueryBuilder<Alarm, Alarm, QQueryProperty> {
  QueryBuilder<Alarm, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Alarm, DateTime?, QQueryOperations> dateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateTime');
    });
  }

  QueryBuilder<Alarm, int, QQueryOperations> hourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hour');
    });
  }

  QueryBuilder<Alarm, bool, QQueryOperations> isTurnedOnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isTurnedOn');
    });
  }

  QueryBuilder<Alarm, int, QQueryOperations> minuteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'minute');
    });
  }

  QueryBuilder<Alarm, bool, QQueryOperations> repeatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repeat');
    });
  }

  QueryBuilder<Alarm, List<bool>?, QQueryOperations> repeatDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repeatDays');
    });
  }
}
