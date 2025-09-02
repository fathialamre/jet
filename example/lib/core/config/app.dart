import 'package:example/core/adapters/router_adapter.dart';
import 'package:example/core/resources/theme/app_theme.dart';
import 'package:example/core/router/app_router.gr.dart';
import 'package:example/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:jet/adapters/jet_adapter.dart';
import 'package:jet/config/jet_config.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/localization/models/locale_info.dart';

class AppConfig extends JetConfig {
  @override
  List<JetAdapter> get adapters => [
    RouterAdapter(),
  ];

  @override
  PageInfo? get authPageInfo => LoginRoute.page;

  @override
  List<LocaleInfo> get supportedLocales => [
    const LocaleInfo(
      locale: Locale('ar'),
      displayName: 'العربية',
      nativeName: 'Arabic',
    ),
    const LocaleInfo(
      locale: Locale('en'),
      displayName: 'English',
      nativeName: 'English',
    ),
    const LocaleInfo(
      locale: Locale('fr'),
      displayName: 'Français',
      nativeName: '',
    ),
  ];

  @override
  List<LocalizationsDelegate<Object>> get localizationsDelegates => [
    AppLocalizations.delegate,
  ];

  @override
  Locale? get defaultLocale => const Locale('en');

  @override
  ThemeData? get theme => ThemeData(
    colorScheme: MaterialTheme.lightScheme(),
  );

  @override
  ThemeData? get darkTheme => ThemeData(
    colorScheme: MaterialTheme.darkScheme(),
  );
}
