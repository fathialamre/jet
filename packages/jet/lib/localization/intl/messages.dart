import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jet/localization/i10n.dart';

import 'messages_ar.dart';
import 'messages_en.dart';

abstract class JetLocalizationsImpl {
  static JetLocalizationsImpl of(BuildContext context) {
    return Localizations.of<JetLocalizationsImpl>(
          context,
          JetLocalizationsImpl,
        ) ??
        _default;
  }

  static const LocalizationsDelegate<JetLocalizationsImpl> delegate =
      JetLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('ar'),
    Locale('en'),
  ];

  static final JetLocalizationsImpl _default = JetLocalizationsImplEn();

  String get appName;
  String get cancel;
  String get confirm;
  String get ok;
  String get yes;
  String get no;

  // Theme related translations
  String get lightTheme;
  String get darkTheme;
  String get systemTheme;
  String get switchToDarkTheme;
  String get switchToLightTheme;
  String get switchToSystemTheme;
  String get changeTheme;
  // Language related translations
  String get changeLanguage;
  String get retry;

  // Paginator related translations
  String get noItemsFound;
  String get noItemsFoundMessage;
  String get noMoreItemsTitle;
  String get noMoreItemsMessage;
  String get loadMore;
  String get somethingWentWrongWhileFetchingNewPage;
  String get loadingMore;

  // Error handling related translations
  String get noInternetConnection;
  String get unknownError;
  String get connectionTimeout;
  String get sendTimeout;
  String get receiveTimeout;
  String get badCertificate;
  String get badResponse;
  String get requestCancelled;
  String get someFieldsAreInvalid;
  String get passwordNotIdentical;
  String get submit;
}

class JetLocalizationsDelegate
    extends LocalizationsDelegate<JetLocalizationsImpl> {
  const JetLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => JetLocalizationsImpl.supportedLocales
      .map((Locale e) => e.languageCode)
      .contains(locale.languageCode);

  @override
  Future<JetLocalizationsImpl> load(Locale locale) {
    final JetLocalizationsImpl instance = lookupJetLocalizationsImpl(locale);
    JetLocalizations.setCurrentInstance(instance);
    return SynchronousFuture<JetLocalizationsImpl>(instance);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<JetLocalizationsImpl> old) {
    return false;
  }
}

JetLocalizationsImpl lookupJetLocalizationsImpl(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return JetLocalizationsImplAr();
    case 'en':
      return JetLocalizationsImplEn();
    default:
      return JetLocalizationsImplEn();
  }
}
