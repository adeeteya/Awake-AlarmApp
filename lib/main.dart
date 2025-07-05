import 'package:alarm/alarm.dart';
import 'package:awake/theme/app_theme.dart';
import 'package:awake/screens/home.dart';
import 'package:awake/services/alarm_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'services/shared_prefs_with_cache.dart';
import 'services/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesWithCache.initialize();
  await Alarm.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AlarmCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Awake- The Alarm Clock',
            themeMode: mode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const Home(),
          );
        },
      ),
    );
  }
}
