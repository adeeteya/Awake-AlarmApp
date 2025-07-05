import 'package:alarm/alarm.dart';
import 'package:awake/theme/app_theme.dart';
import 'package:awake/screens/home.dart';
import 'package:awake/services/alarm_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Alarm.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AlarmCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Awake- The Alarm Clock',
        themeMode: ThemeMode.system,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const Home(),
      ),
    );
  }
}
