import 'package:awake/extensions/context_extensions.dart';
import 'package:awake/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('isDarkMode detects theme', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.dark,
        home: Builder(
          builder: (context) {
            final isDark = context.isDarkMode;
            return Text('$isDark', textDirection: TextDirection.ltr);
          },
        ),
      ),
    );

    expect(find.text('true'), findsOneWidget);
  });

  testWidgets('localization getter returns translations', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: const [Locale('en')],
        locale: const Locale('en'),
        home: Builder(
          builder: (context) {
            final text = context.localization.appTitle;
            return Text(text, textDirection: TextDirection.ltr);
          },
        ),
      ),
    );

    expect(find.text('Awake- The Alarm Clock'), findsOneWidget);
  });
}
