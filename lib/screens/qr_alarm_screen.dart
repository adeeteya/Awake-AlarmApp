import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:awake/constants.dart';
import 'package:awake/extensions/context_extensions.dart';
import 'package:awake/services/alarm_cubit.dart';
import 'package:awake/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QrAlarmScreen extends StatefulWidget {
  final AlarmSettings alarmSettings;
  const QrAlarmScreen({super.key, required this.alarmSettings});

  @override
  State<QrAlarmScreen> createState() => _QrAlarmScreenState();
}

class _QrAlarmScreenState extends State<QrAlarmScreen> {
  late final MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
    unawaited(_requestPermission());
  }

  Future<void> _requestPermission() async {
    final status = await Permission.camera.status;
    if (status.isDenied) {
      await Permission.camera.request();
    }
  }

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    final value = capture.barcodes.last.rawValue;
    if (value == kQRCodeText) {
      await context.read<AlarmCubit>().stopAlarm(widget.alarmSettings.id);
      if (mounted) {
        Navigator.pop(context);
      }
    } else if (value != null && value.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wrong QR Code. Please scan the correct one.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors:
                  isDark
                      ? [AppColors.darkScaffold1, AppColors.darkScaffold2]
                      : [AppColors.lightScaffold1, AppColors.lightScaffold2],
            ),
          ),
          child: Column(
            children: [
              const Spacer(),
              Text(
                widget.alarmSettings.notificationSettings.body,
                style: TextStyle(
                  color:
                      isDark
                          ? AppColors.darkBackgroundText
                          : AppColors.lightBackgroundText,
                  fontSize: 24,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                flex: 6,
                child: MobileScanner(
                  controller: _controller,
                  onDetect: _onDetect,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Scan the QR Code',
                style: TextStyle(
                  color:
                      isDark
                          ? AppColors.darkBackgroundText
                          : AppColors.lightBackgroundText,
                  fontSize: 24,
                  fontFamily: 'Poppins',
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
