import 'dart:async';

import 'package:awake/extensions/context_extensions.dart';
import 'package:awake/l10n/app_localizations.dart';
import 'package:awake/models/alarm_screen_type.dart';
import 'package:awake/services/alarm_cubit.dart';
import 'package:awake/services/alarm_permissions.dart';
import 'package:awake/services/custom_sounds_cubit.dart';
import 'package:awake/services/settings_cubit.dart';
import 'package:awake/theme/app_colors.dart';
import 'package:awake/theme/app_text_styles.dart';
import 'package:awake/widgets/gradient_slider.dart';
import 'package:awake/widgets/gradient_switch.dart';
import 'package:awake/widgets/settings_tile.dart';
import 'package:awake/widgets/theme_list_tile.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _pickAndAddAudio(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (!context.mounted ||
        result == null ||
        result.files.single.path == null) {
      return;
    }
    final path = result.files.single.path!;

    final soundsCubit = context.read<CustomSoundsCubit>();
    final settingsCubit = context.read<SettingsCubit>();
    final alarmCubit = context.read<AlarmCubit>();

    final newPath = await soundsCubit.addSound(path);
    if (newPath == null) return;
    await settingsCubit.setAlarmAudioPath(newPath);
    await alarmCubit.updateAudioPathForAll(newPath);
  }

  Future<void> _downloadQrCode(BuildContext context) async {
    final byteData = await rootBundle.load("assets/qr_code.png");
    final saveLocation = await FilePicker.platform.saveFile(
      fileName: 'awake_qr.png',
      type: FileType.image,
      bytes: byteData.buffer.asUint8List(),
    );
    if (context.mounted && saveLocation != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.fileSaved(saveLocation)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBorder : Colors.white,
      appBar: AppBar(
        backgroundColor:
            isDark ? AppColors.darkScaffold1 : AppColors.lightScaffold1,
        leading: IconButton(
          tooltip: AppLocalizations.of(context)!.back,
          onPressed: () => context.pop(),
          style: IconButton.styleFrom(
            foregroundColor:
                isDark
                    ? AppColors.darkBackgroundText
                    : AppColors.lightBackgroundText,
          ),
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.settings),
        titleTextStyle: AppTextStyles.heading(context),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                isDark
                    ? [AppColors.darkScaffold1, AppColors.darkScaffold2]
                    : [AppColors.lightContainer1, AppColors.lightContainer2],
          ),
        ),
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final color =
                isDark
                    ? AppColors.darkBackgroundText
                    : AppColors.lightBackgroundText;
            return ListView(
              padding: const EdgeInsets.all(10),
              children: [
                ThemeListTile(
                  mode: state.mode,
                  onChanged: (m) => context.read<SettingsCubit>().setTheme(m),
                ),
                const SizedBox(height: 23),
                SettingsTile(
                  onTap:
                      () => context.read<SettingsCubit>().setUse24HourFormat(
                        !state.use24HourFormat,
                      ),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.format24h,
                        style: AppTextStyles.body(
                          context,
                        ).copyWith(color: color),
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
                const SizedBox(height: 23),
                SettingsTile(
                  onTap: () async {
                    final settingsCubit = context.read<SettingsCubit>();
                    final alarmCubit = context.read<AlarmCubit>();
                    final newValue = !state.vibrationEnabled;
                    await settingsCubit.setVibrationEnabled(newValue);
                    await alarmCubit.updateVibrationForAll(newValue);
                  },
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.vibration,
                        style: AppTextStyles.body(
                          context,
                        ).copyWith(color: color),
                      ),
                      const Spacer(),
                      GradientSwitch(
                        value: state.vibrationEnabled,
                        onChanged: (v) async {
                          final settingsCubit = context.read<SettingsCubit>();
                          final alarmCubit = context.read<AlarmCubit>();
                          await settingsCubit.setVibrationEnabled(v);
                          await alarmCubit.updateVibrationForAll(v);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 23),
                SettingsTile(
                  onTap: () async {
                    final settingsCubit = context.read<SettingsCubit>();
                    final alarmCubit = context.read<AlarmCubit>();
                    final newValue = !state.fadeInAlarm;
                    await settingsCubit.setFadeInAlarm(newValue);
                    await alarmCubit.updateVolumeSettingsForAll(
                      fadeIn: newValue,
                      volume: state.alarmVolume,
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.fadeIn,
                        style: AppTextStyles.body(
                          context,
                        ).copyWith(color: color),
                      ),
                      const Spacer(),
                      GradientSwitch(
                        value: state.fadeInAlarm,
                        onChanged: (v) async {
                          final settingsCubit = context.read<SettingsCubit>();
                          final alarmCubit = context.read<AlarmCubit>();
                          await settingsCubit.setFadeInAlarm(v);
                          await alarmCubit.updateVolumeSettingsForAll(
                            fadeIn: v,
                            volume: state.alarmVolume,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 23),
                SettingsTile(
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.alarmScreen,
                        style: AppTextStyles.body(
                          context,
                        ).copyWith(color: color),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: DropdownButton<AlarmScreenType>(
                          value: state.alarmScreenType,
                          underline: const SizedBox(),
                          isExpanded: true,
                          dropdownColor:
                              isDark
                                  ? AppColors.darkScaffold1
                                  : AppColors.lightScaffold1,
                          items: [
                            DropdownMenuItem(
                              value: AlarmScreenType.ringing,
                              child: Text(
                                AppLocalizations.of(context)!.defaultOption,
                              ),
                            ),
                            DropdownMenuItem(
                              value: AlarmScreenType.math,
                              child: Text(
                                AppLocalizations.of(context)!.mathChallenge,
                              ),
                            ),
                            DropdownMenuItem(
                              value: AlarmScreenType.shake,
                              child: Text(
                                AppLocalizations.of(context)!.shakeToStop,
                              ),
                            ),
                            DropdownMenuItem(
                              value: AlarmScreenType.tap,
                              child: Text(
                                AppLocalizations.of(context)!.tapChallenge,
                              ),
                            ),
                            DropdownMenuItem(
                              value: AlarmScreenType.qr,
                              child: Text(
                                AppLocalizations.of(context)!.qrCodeScan,
                              ),
                            ),
                          ],
                          onChanged: (v) async {
                            if (v == null) return;
                            if (v == AlarmScreenType.qr) {
                              final granted =
                                  await AlarmPermissions.checkCameraPermission();
                              if (!granted) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.cameraPermissionRequired,
                                      ),
                                    ),
                                  );
                                }
                                return;
                              }
                            }
                            if (!context.mounted) return;
                            await context
                                .read<SettingsCubit>()
                                .setAlarmScreenType(v);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 23),
                if (state.alarmScreenType == AlarmScreenType.qr)
                  SettingsTile(
                    onTap: () async {
                      await _downloadQrCode(context);
                    },
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.downloadQr,
                          style: AppTextStyles.body(
                            context,
                          ).copyWith(color: color),
                        ),
                      ],
                    ),
                  ),
                if (state.alarmScreenType == AlarmScreenType.qr)
                  const SizedBox(height: 23),
                BlocBuilder<CustomSoundsCubit, List<String>>(
                  builder: (context, files) {
                    final items = <DropdownMenuItem<String>>[
                      DropdownMenuItem(
                        value: 'assets/alarm_ringtone.mp3',
                        child: Text(
                          AppLocalizations.of(context)!.defaultOption,
                        ),
                      ),
                      ...files.map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(basename(e)),
                        ),
                      ),
                      DropdownMenuItem(
                        value: '__add__',
                        child: Text(AppLocalizations.of(context)!.addSound),
                      ),
                    ];
                    final values =
                        items
                            .where((e) => e.value != '__add__')
                            .map((e) => e.value)
                            .whereType<String>()
                            .toList();
                    String dropdownValue = state.alarmAudioPath;
                    if (files.isEmpty &&
                        dropdownValue != 'assets/alarm_ringtone.mp3') {
                      dropdownValue = 'assets/alarm_ringtone.mp3';
                    } else if (files.isNotEmpty &&
                        !values.contains(dropdownValue)) {
                      dropdownValue = 'assets/alarm_ringtone.mp3';
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        unawaited(
                          context.read<SettingsCubit>().setAlarmAudioPath(
                            dropdownValue,
                          ),
                        );
                      });
                    }

                    final alarmSoundTile = SettingsTile(
                      child: Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.alarmSound,
                            style: AppTextStyles.body(
                              context,
                            ).copyWith(color: color),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              underline: const SizedBox(),
                              enableFeedback: true,
                              isExpanded: true,
                              dropdownColor:
                                  isDark
                                      ? AppColors.darkScaffold1
                                      : Colors.white,
                              items: items,
                              onChanged: (v) async {
                                if (v == null) return;
                                if (v == '__add__') {
                                  await _pickAndAddAudio(context);
                                } else {
                                  final settingsCubit =
                                      context.read<SettingsCubit>();
                                  final alarmCubit = context.read<AlarmCubit>();
                                  await settingsCubit.setAlarmAudioPath(v);
                                  await alarmCubit.updateAudioPathForAll(v);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );

                    if (files.isEmpty) {
                      return alarmSoundTile;
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        alarmSoundTile,
                        const SizedBox(height: 23),
                        SettingsTile(
                          onTap: () async {
                            await context
                                .read<CustomSoundsCubit>()
                                .clearSounds();
                          },
                          child: Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.clearCustomSounds,
                                style: AppTextStyles.body(
                                  context,
                                ).copyWith(color: color),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 23),
                SettingsTile(
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
                      const SizedBox(width: 10),
                      Expanded(
                        child: GradientSlider(
                          value: state.alarmVolume,
                          onChanged: (v) async {
                            final settingsCubit = context.read<SettingsCubit>();
                            final alarmCubit = context.read<AlarmCubit>();
                            await settingsCubit.setAlarmVolume(v);
                            await alarmCubit.updateVolumeSettingsForAll(
                              fadeIn: state.fadeInAlarm,
                              volume: v,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 23),
              ],
            );
          },
        ),
      ),
    );
  }
}
