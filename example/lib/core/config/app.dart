import 'package:example/core/adapters/router_adapter.dart';
import 'package:example/core/resources/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:jet/adapters/jet_adapter.dart';
import 'package:jet/config/jet_config.dart';
import 'package:jet/localization/models/locale_info.dart';
import 'package:jet/localization/widgets/language_switcher.dart';

/// Application configuration class that extends [JetConfig] to provide
/// centralized configuration for the entire Flutter application.
///
/// This class defines:
/// - Available adapters for extended functionality
/// - Supported locales and internationalization settings
/// - Theme configuration for light and dark modes
/// - Default locale preferences
///
/// Usage:
/// ```dart
/// void main() {
///   JetFramework.initialize(AppConfig());
///   runApp(MyApp());
/// }
/// ```
///
/// The configuration is automatically applied throughout the app when
/// using JetMain widget or initializing the Jet framework.
class AppConfig extends JetConfig {
  /// List of adapters that provide extended functionality to the Jet framework.
  ///
  /// Adapters are used to integrate third-party services or custom functionality
  /// into the Jet framework. Currently includes:
  /// - [RouterAdapter]: Handles application routing and navigation
  ///
  /// To add more adapters:
  /// ```dart
  /// @override
  /// List<JetAdapter> get adapters => [
  ///   RouterAdapter(),
  ///   CustomApiAdapter(),
  ///   AnalyticsAdapter(),
  /// ];
  /// ```
  @override
  List<JetAdapter> get adapters => [
    RouterAdapter(),
  ];

  /// List of locales supported by the application.
  ///
  /// Defines which languages the app can display content in.
  /// The order doesn't affect priority - use [defaultLocale] for that.
  ///
  /// Currently supports:
  /// - Arabic (ar)
  /// - English (en)
  ///
  /// To add more locales, ensure corresponding message files exist
  /// in the localization directory.
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
  ];

  /// Additional localization delegates for custom or third-party localizations.
  ///
  /// Use this to add delegates that aren't included in Jet's default
  /// localization setup. For example:
  /// ```dart
  /// @override
  /// List<LocalizationsDelegate<Object>> get localizationsDelegates => [
  ///   GlobalMaterialLocalizations.delegate,
  ///   GlobalCupertinoLocalizations.delegate,
  ///   CustomLocalizations.delegate,
  /// ];
  /// ```
  ///
  /// Currently empty as Jet provides the basic delegates by default.
  @override
  List<LocalizationsDelegate<Object>> get localizationsDelegates => [];

  /// The default locale to use when the device locale is not supported
  /// or when explicitly setting a fallback language.
  ///
  /// Set to Arabic (ar) as the primary language for this application.
  /// If the user's device is set to an unsupported language, the app
  /// will fall back to Arabic.
  ///
  /// Set to `null` to always use the device's locale if supported,
  /// or the first locale in [supportedLocales] as fallback.
  @override
  Locale? get defaultLocale => const Locale('ar');

  /// Light theme configuration for the application.
  ///
  /// Uses Material 3 design system with a custom color scheme defined
  /// in [MaterialTheme.lightScheme()]. The theme is applied when the
  /// device is in light mode or when explicitly set by the user.
  ///
  /// Customize by modifying the color scheme or adding additional
  /// theme properties like fonts, shapes, etc.
  @override
  ThemeData? get theme => ThemeData(
    colorScheme: MaterialTheme.lightScheme(),
  );

  /// Dark theme configuration for the application.
  ///
  /// Uses Material 3 design system with a custom dark color scheme defined
  /// in [MaterialTheme.darkScheme()]. The theme is applied when the
  /// device is in dark mode or when explicitly set by the user.
  ///
  /// Should complement the light theme while providing good contrast
  /// and readability in low-light conditions.
  @override
  ThemeData? get darkTheme => ThemeData(
    colorScheme: MaterialTheme.darkScheme(),
  );
}
