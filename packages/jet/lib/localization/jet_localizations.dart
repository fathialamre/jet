import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'messages/messages.dart';
import 'messages/messages_en.dart';
import 'messages/messages_ar.dart';
import 'messages/messages_fr.dart';

/// Localization support for Jet framework.
///
/// Use [JetLocalizations.of(context)] to access localized messages.
///
/// Example:
/// ```dart
/// final localizations = JetLocalizations.of(context);
/// print(localizations.messages.appName);
/// ```
class JetLocalizations {
  JetLocalizations._(this.messages, this.locale);

  /// The localized messages for the current locale.
  final JetMessages messages;

  /// The current locale.
  final Locale locale;

  /// Returns the [JetLocalizations] for the given context.
  ///
  /// Returns a default English instance if no localization is found.
  static JetLocalizations of(BuildContext context) {
    return Localizations.of<JetLocalizations>(
          context,
          JetLocalizations,
        ) ??
        _default;
  }

  static final JetLocalizations _default = JetLocalizations._(
    JetMessagesEn(),
    const Locale('en'),
  );

  static JetLocalizations? _current;

  /// Sets the current localization instance.
  ///
  /// This is automatically called by the delegate when loading localizations.
  static void _setCurrent(JetLocalizations localization) {
    _current = localization;
  }

  /// Internal method to set the current instance from the delegate.
  static void setCurrentInstance(JetMessages messages) {
    _current = JetLocalizations._(messages, const Locale('en'));
  }

  /// Returns the current localized messages.
  ///
  /// This can be used in contexts where BuildContext is not available.
  /// Falls back to English if not set.
  ///
  /// Example:
  /// ```dart
  /// final appName = JetLocalizations.current.appName;
  /// ```
  static JetMessages get current => _current?.messages ?? _default.messages;

  /// The delegate for loading localizations.
  static const LocalizationsDelegate<JetLocalizations> delegate =
      _JetLocalizationsDelegate();

  /// List of localization delegates needed for the app.
  ///
  /// Include this in your MaterialApp or CupertinoApp.
  ///
  /// Example:
  /// ```dart
  /// MaterialApp(
  ///   localizationsDelegates: [
  ///     ...JetLocalizations.localizationsDelegates,
  ///   ],
  ///   supportedLocales: JetLocalizations.supportedLocales,
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
  static JetMessages _loadMessages(Locale locale) {
    final String languageCode = locale.languageCode;

    switch (languageCode) {
      case 'ar':
        return JetMessagesAr();
      case 'fr':
        return JetMessagesFr();
      case 'en':
      default:
        return JetMessagesEn();
    }
  }

  /// Get text direction for a specific locale.
  static TextDirection getTextDirection(Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return TextDirection.rtl;
      default:
        return TextDirection.ltr;
    }
  }
}

class _JetLocalizationsDelegate
    extends LocalizationsDelegate<JetLocalizations> {
  const _JetLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return JetLocalizations.supportedLocales
        .map((l) => l.languageCode)
        .contains(locale.languageCode);
  }

  @override
  Future<JetLocalizations> load(Locale locale) {
    final messages = JetLocalizations._loadMessages(locale);
    final localization = JetLocalizations._(messages, locale);
    JetLocalizations._setCurrent(localization);
    return SynchronousFuture<JetLocalizations>(localization);
  }

  @override
  bool shouldReload(_JetLocalizationsDelegate old) => false;
}
