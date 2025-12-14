import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:pink_ito/constants/app_theme.dart';
import 'package:pink_ito/l10n/app_localizations.dart';
import 'package:pink_ito/providers/game_provider.dart';

/// Creates a test widget with localization support
Widget createLocalizedTestWidget({
  required Widget child,
  GameProvider? provider,
  Locale locale = const Locale('ja'),
}) {
  return ChangeNotifierProvider.value(
    value: provider ?? GameProvider(),
    child: MaterialApp(
      theme: AppTheme.darkThemeForTest,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja'),
        Locale('en'),
        Locale('ko'),
      ],
      home: child,
    ),
  );
}
