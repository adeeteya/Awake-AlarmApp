import 'package:alarm/alarm.dart';
import 'package:awake/app_router.dart';
import 'package:awake/services/alarm_cubit.dart';
import 'package:awake/services/alarm_database.dart';
import 'package:awake/services/custom_sounds_cubit.dart';
import 'package:awake/services/settings_cubit.dart';
import 'package:awake/services/shared_prefs_with_cache.dart';
import 'package:awake/theme/app_theme.dart';
import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

Future<void> mainCommon({bool enableDevicePreview = false}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesWithCache.initialize();
  await AlarmDatabase.initialize();
  await Alarm.init();

  const app = MyApp();
  if (enableDevicePreview) {
    runApp(DevicePreview(builder: (context) => app));
  } else {
    runApp(app);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GoRouter _router = createRouter();

  @override
  Widget build(BuildContext context) {
    final bool previewEnabled = DevicePreview.isEnabled(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AlarmCubit()),
        BlocProvider(create: (_) => SettingsCubit()),
        BlocProvider(create: (_) => CustomSoundsCubit()),
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
            // ignore: deprecated_member_use
            useInheritedMediaQuery: previewEnabled,
            locale: previewEnabled ? DevicePreview.locale(context) : null,
            builder: previewEnabled ? DevicePreview.appBuilder : null,
          );
        },
      ),
    );
  }
}
