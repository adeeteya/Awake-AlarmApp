import 'package:alarm/alarm.dart';
import 'package:awake/screens/home.dart';
import 'package:awake/services/alarm_cubit.dart';
import 'package:awake/services/alarm_database.dart';
import 'package:awake/services/custom_sounds_cubit.dart';
import 'package:awake/services/settings_cubit.dart';
import 'package:awake/services/shared_prefs_with_cache.dart';
import 'package:awake/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesWithCache.initialize();
  await AlarmDatabase.initialize();
  await Alarm.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AlarmCubit()),
        BlocProvider(create: (_) => SettingsCubit()),
        BlocProvider(create: (_) => CustomSoundsCubit()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Awake- The Alarm Clock',
            themeMode: state.mode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const Home(),
          );
        },
      ),
    );
  }
}
