import 'package:flutter/material.dart';
import 'package:jet/adapters/jet_adapter.dart';
import 'package:jet/localization/models/locale_info.dart';
import 'package:jet/resources/components/jet_loader.dart';
import 'package:jet/networking/errors/errors.dart';

/// Configuration class for Jet framework that defines app-wide settings.
///
/// This abstract class provides a centralized way to configure various aspects
/// of your Flutter application including adapters, localization, and theming.
///
/// Example usage:
/// ```dart
/// class AppConfig extends JetConfig {
///   @override
///   List<JetAdapter> get adapters => [
///     RouterAdapter(),
///     DatabaseAdapter(),
///   ];
///
///   @override
///   List<Locale> get supportedLocales => [
///     const Locale('en'),
///     const Locale('es'),
///   ];
///
///   @override
///   Locale? get defaultLocale => const Locale('en');
///
///   @override
///   ThemeData? get theme => ThemeData(
///     colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
///   );
/// }
/// ```
abstract class JetConfig {
  /// List of adapters that provide additional functionality to the app.
  ///
  /// Adapters can handle routing, state management, networking, etc.
  /// Example: [RouterAdapter, DatabaseAdapter, AnalyticsAdapter]
  List<JetAdapter> get adapters;

  /// The default locale for the application.
  ///
  /// This locale will be used when the system locale is not supported
  /// or when the app first launches.
  /// Example: `const Locale('en')`
  Locale? get defaultLocale;

  /// List of locales that the application supports.
  ///
  /// These locales determine which translations and regional settings
  /// are available in the app.
  /// Example: `[const Locale('en'), const Locale('es'), const Locale('fr')]`
  List<LocaleInfo> get supportedLocales;

  /// List of localization delegates for custom localization.
  ///
  /// These delegates handle loading and managing localized resources
  /// like strings, dates, and numbers.
  /// Example: `[GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate]`
  List<LocalizationsDelegate<Object>> get localizationsDelegates;

  /// The light theme configuration for the application.
  ///
  /// Returns null by default, meaning no custom light theme is applied.
  /// Example: `ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue))`
  ThemeData? get theme => null;

  /// The dark theme configuration for the application.
  ///
  /// Returns null by default, meaning no custom dark theme is applied.
  /// Example: `ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark))`
  ThemeData? get darkTheme => null;

  /// The theme mode for the application.
  ///
  /// Controls whether the app uses light, dark, or system theme.
  /// Defaults to [ThemeMode.system] which follows the system preference.
  /// Examples: [ThemeMode.light], [ThemeMode.dark], [ThemeMode.system]
  ThemeMode? get themeMode => ThemeMode.system;

  /// The loader for the application.
  ///
  /// Returns null by default, meaning no custom loader is applied.
  /// Example: `JetLoader(color: Colors.blue)`
  JetLoader get loader => JetLoader();

  /// The error handler for the application.
  ///
  /// Returns the default JetErrorHandler by default.
  /// Override this to provide custom error handling logic.
  /// Example: `MyCustomErrorHandler()`
  JetBaseErrorHandler get errorHandler => JetErrorHandler.instance;
}
