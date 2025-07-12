import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Awake- The Alarm Clock'**
  String get appTitle;

  /// No description provided for @addAlarm.
  ///
  /// In en, this message translates to:
  /// **'Add Alarm'**
  String get addAlarm;

  /// No description provided for @editAlarm.
  ///
  /// In en, this message translates to:
  /// **'Edit Alarm'**
  String get editAlarm;

  /// No description provided for @noAlarms.
  ///
  /// In en, this message translates to:
  /// **'No Alarms Added Yet'**
  String get noAlarms;

  /// No description provided for @alarms.
  ///
  /// In en, this message translates to:
  /// **'Alarms'**
  String get alarms;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteAlarm.
  ///
  /// In en, this message translates to:
  /// **'Delete Alarm'**
  String get deleteAlarm;

  /// No description provided for @deleteAlarmPrompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this alarm?'**
  String get deleteAlarmPrompt;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleLabel;

  /// No description provided for @wrongAnswer.
  ///
  /// In en, this message translates to:
  /// **'Wrong answer'**
  String get wrongAnswer;

  /// No description provided for @alarmSnoozed.
  ///
  /// In en, this message translates to:
  /// **'Alarm snoozed for {minutes} minutes'**
  String alarmSnoozed(Object minutes);

  /// No description provided for @scanQrInstruction.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR Code'**
  String get scanQrInstruction;

  /// No description provided for @wrongQr.
  ///
  /// In en, this message translates to:
  /// **'Wrong QR Code. Please scan the correct one.'**
  String get wrongQr;

  /// No description provided for @shakePhone.
  ///
  /// In en, this message translates to:
  /// **'Shake the phone!'**
  String get shakePhone;

  /// No description provided for @shakesCount.
  ///
  /// In en, this message translates to:
  /// **'Shakes: {count} / {required}'**
  String shakesCount(Object count, Object required);

  /// No description provided for @tapScreen.
  ///
  /// In en, this message translates to:
  /// **'Tap the screen!'**
  String get tapScreen;

  /// No description provided for @tapsCount.
  ///
  /// In en, this message translates to:
  /// **'Taps: {count} / {required}'**
  String tapsCount(Object count, Object required);

  /// No description provided for @downloadQr.
  ///
  /// In en, this message translates to:
  /// **'Download QR Code'**
  String get downloadQr;

  /// No description provided for @fileSaved.
  ///
  /// In en, this message translates to:
  /// **'File saved to {path}'**
  String fileSaved(Object path);

  /// No description provided for @cameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required for QR Code Scan'**
  String get cameraPermissionRequired;

  /// No description provided for @vibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// No description provided for @fadeIn.
  ///
  /// In en, this message translates to:
  /// **'Gradual Fade In'**
  String get fadeIn;

  /// No description provided for @alarmScreen.
  ///
  /// In en, this message translates to:
  /// **'Alarm Screen'**
  String get alarmScreen;

  /// No description provided for @defaultOption.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultOption;

  /// No description provided for @mathChallenge.
  ///
  /// In en, this message translates to:
  /// **'Math Challenge'**
  String get mathChallenge;

  /// No description provided for @shakeToStop.
  ///
  /// In en, this message translates to:
  /// **'Shake to Stop'**
  String get shakeToStop;

  /// No description provided for @tapChallenge.
  ///
  /// In en, this message translates to:
  /// **'Tap Challenge'**
  String get tapChallenge;

  /// No description provided for @qrCodeScan.
  ///
  /// In en, this message translates to:
  /// **'QR Code Scan'**
  String get qrCodeScan;

  /// No description provided for @alarmSound.
  ///
  /// In en, this message translates to:
  /// **'Alarm Sound'**
  String get alarmSound;

  /// No description provided for @addSound.
  ///
  /// In en, this message translates to:
  /// **'Add Sound'**
  String get addSound;

  /// No description provided for @clearCustomSounds.
  ///
  /// In en, this message translates to:
  /// **'Clear Custom Sounds'**
  String get clearCustomSounds;

  /// No description provided for @format24h.
  ///
  /// In en, this message translates to:
  /// **'24-Hour Format'**
  String get format24h;

  /// No description provided for @snoozeLabel.
  ///
  /// In en, this message translates to:
  /// **'Snooze: {minutes} min'**
  String snoozeLabel(Object minutes);

  /// No description provided for @solve.
  ///
  /// In en, this message translates to:
  /// **'Solve: {a} {symbol} {b} = '**
  String solve(Object a, Object b, Object symbol);

  /// No description provided for @numberLabel.
  ///
  /// In en, this message translates to:
  /// **'Number {label}'**
  String numberLabel(Object label);

  /// No description provided for @deleteLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteLabel;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
