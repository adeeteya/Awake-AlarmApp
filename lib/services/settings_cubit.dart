import 'package:awake/models/alarm_screen_type.dart';
import 'package:awake/services/shared_prefs_with_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsState {
  final ThemeMode mode;
  final bool use24HourFormat;
  final bool vibrationEnabled;
  final bool fadeInAlarm;
  final double alarmVolume;
  final String alarmAudioPath;
  final AlarmScreenType alarmScreenType;

  const SettingsState({
    required this.mode,
    required this.use24HourFormat,
    required this.vibrationEnabled,
    required this.fadeInAlarm,
    required this.alarmVolume,
    required this.alarmAudioPath,
    required this.alarmScreenType,
  });

  SettingsState copyWith({
    ThemeMode? mode,
    bool? use24HourFormat,
    bool? vibrationEnabled,
    bool? fadeInAlarm,
    double? alarmVolume,
    String? alarmAudioPath,
    AlarmScreenType? alarmScreenType,
  }) {
    return SettingsState(
      mode: mode ?? this.mode,
      use24HourFormat: use24HourFormat ?? this.use24HourFormat,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      fadeInAlarm: fadeInAlarm ?? this.fadeInAlarm,
      alarmVolume: alarmVolume ?? this.alarmVolume,
      alarmAudioPath: alarmAudioPath ?? this.alarmAudioPath,
      alarmScreenType: alarmScreenType ?? this.alarmScreenType,
    );
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
    : super(
        SettingsState(
          mode:
              ThemeMode.values[SharedPreferencesWithCache.instance.get<int>(
                    'themeMode',
                  ) ??
                  ThemeMode.system.index],
          use24HourFormat:
              (SharedPreferencesWithCache.instance.get<int>(
                    'use24HourFormat',
                  ) ??
                  0) ==
              1,
          vibrationEnabled:
              (SharedPreferencesWithCache.instance.get<int>(
                    'vibrationEnabled',
                  ) ??
                  1) ==
              1,
          fadeInAlarm:
              (SharedPreferencesWithCache.instance.get<int>('fadeInAlarm') ??
                  0) ==
              1,
          alarmVolume:
              SharedPreferencesWithCache.instance.get<double>('alarmVolume') ??
              1.0,
          alarmAudioPath:
              SharedPreferencesWithCache.instance.get<String>(
                'alarmAudioPath',
              ) ??
              'assets/alarm_ringtone.mp3',
          alarmScreenType:
              AlarmScreenType.values[SharedPreferencesWithCache.instance
                      .get<int>('alarmScreenType') ??
                  AlarmScreenType.ringing.index],
        ),
      );

  Future<void> setTheme(ThemeMode mode) async {
    await SharedPreferencesWithCache.instance.setInt('themeMode', mode.index);
    emit(state.copyWith(mode: mode));
  }

  Future<void> setUse24HourFormat(bool use24Hour) async {
    await SharedPreferencesWithCache.instance.setInt(
      'use24HourFormat',
      use24Hour ? 1 : 0,
    );
    emit(state.copyWith(use24HourFormat: use24Hour));
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    await SharedPreferencesWithCache.instance.setInt(
      'vibrationEnabled',
      enabled ? 1 : 0,
    );
    emit(state.copyWith(vibrationEnabled: enabled));
  }

  Future<void> setFadeInAlarm(bool enabled) async {
    await SharedPreferencesWithCache.instance.setInt(
      'fadeInAlarm',
      enabled ? 1 : 0,
    );
    emit(state.copyWith(fadeInAlarm: enabled));
  }

  Future<void> setAlarmVolume(double volume) async {
    await SharedPreferencesWithCache.instance.setDouble('alarmVolume', volume);
    emit(state.copyWith(alarmVolume: volume));
  }

  Future<void> setAlarmAudioPath(String path) async {
    await SharedPreferencesWithCache.instance.setString('alarmAudioPath', path);
    emit(state.copyWith(alarmAudioPath: path));
  }

  Future<void> setAlarmScreenType(AlarmScreenType type) async {
    await SharedPreferencesWithCache.instance.setInt(
      'alarmScreenType',
      type.index,
    );
    emit(state.copyWith(alarmScreenType: type));
  }
}
