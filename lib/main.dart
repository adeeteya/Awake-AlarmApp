import 'package:alarm/alarm.dart';
import 'package:awake/app_router.dart';
import 'package:awake/services/alarm_cubit.dart';
import 'package:awake/services/alarm_database.dart';
import 'package:awake/services/custom_sounds_cubit.dart';
import 'package:awake/services/group_alarm_cubit.dart';
import 'package:awake/services/settings_cubit.dart';
import 'package:awake/services/shared_prefs_with_cache.dart';
import 'package:awake/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesWithCache.initialize();
  await AlarmDatabase.initialize();
  await Alarm.init();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GoRouter _router = createRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AlarmCubit()),
        BlocProvider(create: (_) => SettingsCubit()),
        BlocProvider(create: (_) => CustomSoundsCubit()),
        BlocProvider(
          create: (context) => GroupAlarmCubit(context.read<AlarmCubit>()),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Awake- The Alarm Clock',
            themeMode: state.mode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
