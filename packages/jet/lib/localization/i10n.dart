import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jet/localization/intl/messages.dart';
import 'package:jet/localization/intl/messages_en.dart';

// Export the locale provider from local_switcher.dart
export 'package:jet/localization/widgets/language_switcher.dart'
    show localeProvider, LocaleNotifier;

class JetLocalizations {
  JetLocalizations._();

  /// The [JetLocalizationsImpl] instance for the current context.
  static JetLocalizationsImpl of(BuildContext context) {
    return Localizations.of<JetLocalizationsImpl>(
          context,
          JetLocalizationsImpl,
        ) ??
        _default;
  }

  /// The [JetLocalizationsImpl] instance delegate.
  static const LocalizationsDelegate<JetLocalizationsImpl> delegate =
      JetLocalizationsDelegate();

  /// The [GlobalMaterialLocalizations.delegate],
  /// [GlobalCupertinoLocalizations.delegate], and
  /// [GlobalWidgetsLocalizations.delegate] delegates.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// The supported locales.
  static const List<Locale> supportedLocales =
      JetLocalizationsImpl.supportedLocales;

  static final JetLocalizationsImplEn _default = JetLocalizationsImplEn();

  static JetLocalizationsImpl? _current;

  /// Set the current [JetLocalizationsImpl] instance.
  static void setCurrentInstance(JetLocalizationsImpl? current) =>
      _current = current;

  /// The current [JetLocalizationsImpl] instance.
  static JetLocalizationsImpl get current => _current ?? _default;

  static TextDirection getTextDirection(Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return TextDirection.rtl;
      default:
        return TextDirection.ltr;
    }
  }
}
