import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'shared_prefs_with_cache.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit()
    : super(
        ThemeMode.values[SharedPreferencesWithCache.instance.get<int>(
              'themeMode',
            ) ??
            ThemeMode.system.index],
      );

  Future<void> setTheme(ThemeMode mode) async {
    await SharedPreferencesWithCache.instance.setInt('themeMode', mode.index);
    emit(mode);
  }
}
