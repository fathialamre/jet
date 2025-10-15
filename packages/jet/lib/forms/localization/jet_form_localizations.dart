import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'messages/messages.dart';
import 'messages/messages_en.dart';
import 'messages/messages_ar.dart';
import 'messages/messages_fr.dart';

/// Localization support for Jet Form validation messages.
///
/// Use [JetFormLocalizations.of(context)] to access localized messages.
///
/// Example:
/// ```dart
/// final localizations = JetFormLocalizations.of(context);
/// print(localizations.messages.requiredErrorText);
/// ```
class JetFormLocalizations {
  JetFormLocalizations._(this.messages, this.locale);

  /// The localized messages for the current locale.
  final JetFormMessages messages;

  /// The current locale.
  final Locale locale;

  /// Returns the [JetFormLocalizations] for the given context.
  ///
  /// Returns a default English instance if no localization is found.
  static JetFormLocalizations of(BuildContext context) {
    return Localizations.of<JetFormLocalizations>(
          context,
          JetFormLocalizations,
        ) ??
        _default;
  }

  static final JetFormLocalizations _default = JetFormLocalizations._(
    const JetFormMessagesEn(),
    const Locale('en'),
  );

  /// The delegate for loading localizations.
  static const LocalizationsDelegate<JetFormLocalizations> delegate =
      _JetFormLocalizationsDelegate();

  /// List of localization delegates needed for the app.
  ///
  /// Include this in your MaterialApp or CupertinoApp.
  ///
  /// Example:
  /// ```dart
  /// MaterialApp(
  ///   localizationsDelegates: [
  ///     ...JetFormLocalizations.localizationsDelegates,
  ///   ],
  ///   supportedLocales: JetFormLocalizations.supportedLocales,
  /// )
  /// ```
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// List of supported locales.
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('ar'), // Arabic
    Locale('fr'), // French
  ];

  /// Load messages for a specific locale.
  static JetFormMessages _loadMessages(Locale locale) {
    final String languageCode = locale.languageCode;

    switch (languageCode) {
      case 'ar':
        return const JetFormMessagesAr();
      case 'fr':
        return const JetFormMessagesFr();
      case 'en':
      default:
        return const JetFormMessagesEn();
    }
  }
}

class _JetFormLocalizationsDelegate
    extends LocalizationsDelegate<JetFormLocalizations> {
  const _JetFormLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return JetFormLocalizations.supportedLocales
        .map((l) => l.languageCode)
        .contains(locale.languageCode);
  }

  @override
  Future<JetFormLocalizations> load(Locale locale) {
    final messages = JetFormLocalizations._loadMessages(locale);
    return SynchronousFuture<JetFormLocalizations>(
      JetFormLocalizations._(messages, locale),
    );
  }

  @override
  bool shouldReload(_JetFormLocalizationsDelegate old) => false;
}

