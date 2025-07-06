import 'package:awake/extensions/context_extensions.dart';
import 'package:awake/services/alarm_cubit.dart';
import 'package:awake/services/settings_cubit.dart';
import 'package:awake/theme/app_colors.dart';
import 'package:awake/widgets/gradient_switch.dart';
import 'package:awake/widgets/theme_list_tile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBorder : Colors.white,
      body: Hero(
        tag: 'InnerDecoratedBox',
        child: Material(
          type: MaterialType.transparency,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors:
                    isDark
                        ? [AppColors.darkScaffold1, AppColors.darkScaffold2]
                        : [
                          AppColors.lightContainer1,
                          AppColors.lightContainer2,
                        ],
              ),
            ),
            child: SafeArea(
              minimum: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        style: IconButton.styleFrom(
                          foregroundColor:
                              isDark
                                  ? AppColors.darkBackgroundText
                                  : AppColors.lightBackgroundText,
                        ),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      Text(
                        'Settings',
                        style: TextStyle(
                          color:
                              isDark
                                  ? AppColors.darkBackgroundText
                                  : AppColors.lightBackgroundText,
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.03,
                        ),
                      ),
                      const IconButton(onPressed: null, icon: Offstage()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                      final color =
                          isDark
                              ? AppColors.darkBackgroundText
                              : AppColors.lightBackgroundText;
                      return Column(
                        children: [
                          ThemeListTile(
                            mode: state.mode,
                            onChanged:
                                (m) =>
                                    context.read<SettingsCubit>().setTheme(m),
                          ),
                          GestureDetector(
                            onTap:
                                () => context
                                    .read<SettingsCubit>()
                                    .setUse24HourFormat(!state.use24HourFormat),
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              margin: const EdgeInsets.only(top: 23),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors:
                                      isDark
                                          ? [
                                            AppColors.darkBorder,
                                            AppColors.darkScaffold2,
                                          ]
                                          : [
                                            Colors.white,
                                            AppColors.lightScaffold2,
                                          ],
                                ),
                                boxShadow:
                                    isDark
                                        ? [
                                          BoxShadow(
                                            offset: const Offset(-5, -5),
                                            blurRadius: 20,
                                            color: AppColors.darkGrey
                                                .withValues(alpha: 0.35),
                                          ),
                                          BoxShadow(
                                            offset: const Offset(13, 14),
                                            blurRadius: 12,
                                            spreadRadius: -6,
                                            color: AppColors.shadowDark
                                                .withValues(alpha: 0.70),
                                          ),
                                        ]
                                        : [
                                          BoxShadow(
                                            offset: const Offset(-5, -5),
                                            blurRadius: 20,
                                            color: Colors.white.withValues(
                                              alpha: 0.53,
                                            ),
                                          ),
                                          BoxShadow(
                                            offset: const Offset(13, 14),
                                            blurRadius: 12,
                                            spreadRadius: -6,
                                            color: AppColors.shadowLight
                                                .withValues(alpha: 0.57),
                                          ),
                                        ],
                              ),
                              child: Container(
                                height: 74,
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors:
                                        isDark
                                            ? [
                                              AppColors.darkClock1,
                                              AppColors.darkScaffold1,
                                            ]
                                            : [
                                              AppColors.lightScaffold1,
                                              AppColors.lightGradient2,
                                            ],
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '24-Hour Format',
                                      style: TextStyle(
                                        color: color,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    const Spacer(),
                                    GradientSwitch(
                                      value: state.use24HourFormat,
                                      onChanged:
                                          (v) => context
                                              .read<SettingsCubit>()
                                              .setUse24HourFormat(v),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 23),
                          GestureDetector(
                            onTap: () async {
                              final settingsCubit =
                                  context.read<SettingsCubit>();
                              final alarmCubit = context.read<AlarmCubit>();
                              final newValue = !state.vibrationEnabled;
                              await settingsCubit.setVibrationEnabled(newValue);
                              await alarmCubit.updateVibrationForAll(newValue);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors:
                                      isDark
                                          ? [
                                            AppColors.darkBorder,
                                            AppColors.darkScaffold2,
                                          ]
                                          : [
                                            Colors.white,
                                            AppColors.lightScaffold2,
                                          ],
                                ),
                                boxShadow:
                                    isDark
                                        ? [
                                          BoxShadow(
                                            offset: const Offset(-5, -5),
                                            blurRadius: 20,
                                            color: AppColors.darkGrey
                                                .withValues(alpha: 0.35),
                                          ),
                                          BoxShadow(
                                            offset: const Offset(13, 14),
                                            blurRadius: 12,
                                            spreadRadius: -6,
                                            color: AppColors.shadowDark
                                                .withValues(alpha: 0.70),
                                          ),
                                        ]
                                        : [
                                          BoxShadow(
                                            offset: const Offset(-5, -5),
                                            blurRadius: 20,
                                            color: Colors.white.withValues(
                                              alpha: 0.53,
                                            ),
                                          ),
                                          BoxShadow(
                                            offset: const Offset(13, 14),
                                            blurRadius: 12,
                                            spreadRadius: -6,
                                            color: AppColors.shadowLight
                                                .withValues(alpha: 0.57),
                                          ),
                                        ],
                              ),
                              child: Container(
                                height: 74,
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors:
                                        isDark
                                            ? [
                                              AppColors.darkClock1,
                                              AppColors.darkScaffold1,
                                            ]
                                            : [
                                              AppColors.lightScaffold1,
                                              AppColors.lightGradient2,
                                            ],
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Vibration',
                                      style: TextStyle(
                                        color: color,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    const Spacer(),
                                    GradientSwitch(
                                      value: state.vibrationEnabled,
                                      onChanged: (v) async {
                                        final settingsCubit =
                                            context.read<SettingsCubit>();
                                        final alarmCubit =
                                            context.read<AlarmCubit>();
                                        await settingsCubit.setVibrationEnabled(
                                          v,
                                        );
                                        await alarmCubit.updateVibrationForAll(
                                          v,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 23),
                          GestureDetector(
                            onTap: () async {
                              final settingsCubit =
                                  context.read<SettingsCubit>();
                              final alarmCubit = context.read<AlarmCubit>();
                              final newValue = !state.fadeInAlarm;
                              await settingsCubit.setFadeInAlarm(newValue);
                              await alarmCubit.updateVolumeSettingsForAll(
                                fadeIn: newValue,
                                volume: state.alarmVolume,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors:
                                      isDark
                                          ? [
                                            AppColors.darkBorder,
                                            AppColors.darkScaffold2,
                                          ]
                                          : [
                                            Colors.white,
                                            AppColors.lightScaffold2,
                                          ],
                                ),
                                boxShadow:
                                    isDark
                                        ? [
                                          BoxShadow(
                                            offset: const Offset(-5, -5),
                                            blurRadius: 20,
                                            color: AppColors.darkGrey
                                                .withValues(alpha: 0.35),
                                          ),
                                          BoxShadow(
                                            offset: const Offset(13, 14),
                                            blurRadius: 12,
                                            spreadRadius: -6,
                                            color: AppColors.shadowDark
                                                .withValues(alpha: 0.70),
                                          ),
                                        ]
                                        : [
                                          BoxShadow(
                                            offset: const Offset(-5, -5),
                                            blurRadius: 20,
                                            color: Colors.white.withValues(
                                              alpha: 0.53,
                                            ),
                                          ),
                                          BoxShadow(
                                            offset: const Offset(13, 14),
                                            blurRadius: 12,
                                            spreadRadius: -6,
                                            color: AppColors.shadowLight
                                                .withValues(alpha: 0.57),
                                          ),
                                        ],
                              ),
                              child: Container(
                                height: 74,
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors:
                                        isDark
                                            ? [
                                              AppColors.darkClock1,
                                              AppColors.darkScaffold1,
                                            ]
                                            : [
                                              AppColors.lightScaffold1,
                                              AppColors.lightGradient2,
                                            ],
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Gradual Fade In',
                                      style: TextStyle(
                                        color: color,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    const Spacer(),
                                    GradientSwitch(
                                      value: state.fadeInAlarm,
                                      onChanged: (v) async {
                                        final settingsCubit =
                                            context.read<SettingsCubit>();
                                        final alarmCubit =
                                            context.read<AlarmCubit>();
                                        await settingsCubit.setFadeInAlarm(v);
                                        await alarmCubit
                                            .updateVolumeSettingsForAll(
                                              fadeIn: v,
                                              volume: state.alarmVolume,
                                            );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 23),
                          Container(
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors:
                                    isDark
                                        ? [
                                          AppColors.darkBorder,
                                          AppColors.darkScaffold2,
                                        ]
                                        : [
                                          Colors.white,
                                          AppColors.lightScaffold2,
                                        ],
                              ),
                              boxShadow:
                                  isDark
                                      ? [
                                        BoxShadow(
                                          offset: const Offset(-5, -5),
                                          blurRadius: 20,
                                          color: AppColors.darkGrey.withValues(
                                            alpha: 0.35,
                                          ),
                                        ),
                                        BoxShadow(
                                          offset: const Offset(13, 14),
                                          blurRadius: 12,
                                          spreadRadius: -6,
                                          color: AppColors.shadowDark
                                              .withValues(alpha: 0.70),
                                        ),
                                      ]
                                      : [
                                        BoxShadow(
                                          offset: const Offset(-5, -5),
                                          blurRadius: 20,
                                          color: Colors.white.withValues(
                                            alpha: 0.53,
                                          ),
                                        ),
                                        BoxShadow(
                                          offset: const Offset(13, 14),
                                          blurRadius: 12,
                                          spreadRadius: -6,
                                          color: AppColors.shadowLight
                                              .withValues(alpha: 0.57),
                                        ),
                                      ],
                            ),
                            child: Container(
                              height: 74,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors:
                                      isDark
                                          ? [
                                            AppColors.darkClock1,
                                            AppColors.darkScaffold1,
                                          ]
                                          : [
                                            AppColors.lightScaffold1,
                                            AppColors.lightGradient2,
                                          ],
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    state.alarmVolume > 0.7
                                        ? Icons.volume_up_rounded
                                        : state.alarmVolume > 0.1
                                        ? Icons.volume_down_rounded
                                        : Icons.volume_mute_rounded,
                                    color: color,
                                  ),
                                  Expanded(
                                    child: Slider(
                                      value: state.alarmVolume,
                                      onChanged: (v) async {
                                        final settingsCubit =
                                            context.read<SettingsCubit>();
                                        final alarmCubit =
                                            context.read<AlarmCubit>();
                                        await settingsCubit.setAlarmVolume(v);
                                        await alarmCubit
                                            .updateVolumeSettingsForAll(
                                              fadeIn: state.fadeInAlarm,
                                              volume: v,
                                            );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
