import 'dart:async';

import 'package:awake/services/alarm_cubit.dart';
import 'package:awake/services/shared_prefs_with_cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupAlarmCubit extends Cubit<String?> {
  final AlarmCubit alarmCubit;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _subscription;

  GroupAlarmCubit(this.alarmCubit)
    : super(SharedPreferencesWithCache.instance.get<String>('groupId')) {
    final id = state;
    if (id != null) {
      unawaited(_listenToGroup(id));
    }
  }

  Future<void> joinGroup(String groupId) async {
    await SharedPreferencesWithCache.instance.setString('groupId', groupId);
    emit(groupId);
    await _listenToGroup(groupId);
  }

  Future<void> leaveGroup() async {
    await SharedPreferencesWithCache.instance.remove('groupId');
    await _subscription?.cancel();
    emit(null);
  }

  Future<void> updateGroupAlarm({
    required TimeOfDay timeOfDay,
    required List<int> days,
    String body = '',
  }) async {
    final id = state;
    if (id == null) return;
    await FirebaseFirestore.instance.collection('groups').doc(id).set({
      'time': '${timeOfDay.hour}:${timeOfDay.minute}',
      'days': days,
      'body': body,
    });
  }

  Future<void> _listenToGroup(String groupId) async {
    await _subscription?.cancel();
    _subscription = FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .snapshots()
        .listen((doc) {
          if (!doc.exists) return;
          final data = doc.data();
          if (data == null) return;
          final timeString = data['time'] as String?;
          if (timeString == null) return;
          final parts = timeString.split(':');
          if (parts.length != 2) return;
          final time = TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          );
          final List<int> days =
              (data['days'] as List?)?.map((e) => e as int).toList() ?? [];
          final body = data['body'] as String? ?? '';
          unawaited(
            alarmCubit.setPeriodicAlarms(
              timeOfDay: time,
              days: days,
              body: body,
            ),
          );
        });
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
