import 'package:awake/services/shared_prefs_with_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeState {
  final ThemeMode mode;
  final bool use24HourFormat;

  const ThemeState({required this.mode, required this.use24HourFormat});

  ThemeState copyWith({ThemeMode? mode, bool? use24HourFormat}) {
    return ThemeState(
      mode: mode ?? this.mode,
      use24HourFormat: use24HourFormat ?? this.use24HourFormat,
    );
  }
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
      : super(
          ThemeState(
            mode: ThemeMode.values[
              SharedPreferencesWithCache.instance.get<int>('themeMode') ??
                  ThemeMode.system.index
            ],
            use24HourFormat:
                (SharedPreferencesWithCache.instance.get<int>('use24HourFormat') ?? 0) == 1,
          ),
        );

  Future<void> setTheme(ThemeMode mode) async {
    await SharedPreferencesWithCache.instance.setInt('themeMode', mode.index);
    emit(state.copyWith(mode: mode));
  }

  Future<void> setUse24HourFormat(bool use24Hour) async {
    await SharedPreferencesWithCache.instance
        .setInt('use24HourFormat', use24Hour ? 1 : 0);
    emit(state.copyWith(use24HourFormat: use24Hour));
  }
}
