// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Awake - El Despertador';

  @override
  String get addAlarm => 'Agregar Alarma';

  @override
  String get editAlarm => 'Editar Alarma';

  @override
  String get noAlarms => 'No hay alarmas';

  @override
  String get alarms => 'Alarmas';

  @override
  String get settings => 'Configuración';

  @override
  String get back => 'Atrás';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteAlarm => 'Eliminar Alarma';

  @override
  String get deleteAlarmPrompt => '¿Seguro que deseas eliminar esta alarma?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get titleLabel => 'Título';

  @override
  String get wrongAnswer => 'Respuesta incorrecta';

  @override
  String alarmSnoozed(Object minutes) {
    return 'Alarma pospuesta por $minutes minutos';
  }

  @override
  String get scanQrInstruction => 'Escanea el código QR';

  @override
  String get wrongQr => 'Código QR incorrecto. Escanee el correcto.';

  @override
  String get shakePhone => '¡Agita el teléfono!';

  @override
  String shakesCount(Object count, Object required) {
    return 'Agitaciones: $count / $required';
  }

  @override
  String get tapScreen => '¡Toca la pantalla!';

  @override
  String tapsCount(Object count, Object required) {
    return 'Toques: $count / $required';
  }

  @override
  String get downloadQr => 'Descargar código QR';

  @override
  String fileSaved(Object path) {
    return 'Archivo guardado en $path';
  }

  @override
  String get cameraPermissionRequired =>
      'Se requiere permiso de cámara para escanear QR';

  @override
  String get vibration => 'Vibración';

  @override
  String get fadeIn => 'Aumento gradual';

  @override
  String get alarmScreen => 'Pantalla de alarma';

  @override
  String get defaultOption => 'Predeterminado';

  @override
  String get mathChallenge => 'Desafío matemático';

  @override
  String get shakeToStop => 'Agitar para detener';

  @override
  String get tapChallenge => 'Desafío de toques';

  @override
  String get qrCodeScan => 'Escanear código QR';

  @override
  String get alarmSound => 'Sonido de alarma';

  @override
  String get addSound => 'Agregar sonido';

  @override
  String get clearCustomSounds => 'Borrar sonidos personalizados';

  @override
  String get format24h => 'Formato 24 horas';

  @override
  String snoozeLabel(Object minutes) {
    return 'Posponer: $minutes min';
  }

  @override
  String solve(Object a, Object b, Object symbol) {
    return 'Resuelve: $a $symbol $b = ';
  }

  @override
  String numberLabel(Object label) {
    return 'Número $label';
  }

  @override
  String get deleteLabel => 'Eliminar';

  @override
  String get monday => 'Lunes';

  @override
  String get tuesday => 'Martes';

  @override
  String get wednesday => 'Miércoles';

  @override
  String get thursday => 'Jueves';

  @override
  String get friday => 'Viernes';

  @override
  String get saturday => 'Sábado';

  @override
  String get sunday => 'Domingo';
}
