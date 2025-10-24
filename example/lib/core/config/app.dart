import 'package:example/core/config/app_theme.dart';
import 'package:example/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:jet/adapters/notifications_adapter.dart';
import 'package:jet/jet_framework.dart';

class AppConfig extends JetConfig {
  @override
  List<JetAdapter> get adapters => [
    NotificationsAdapter(),
  ];

  @override
  List<JetNotificationEvent> get notificationEvents => [];

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
  bool get showErrorStackTrace => false;

  @override
  ThemeData? get theme => ThemeData(
    colorScheme: MaterialTheme.lightScheme(),
  );

  @override
  ThemeData? get darkTheme => ThemeData(
    colorScheme: MaterialTheme.darkScheme(),
  );

  @override
  EnvironmentConfig? get environmentConfig => EnvironmentConfig(
    envPath: 'assets/.env',
  );
}
