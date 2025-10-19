import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jet/localization/jet_localizations.dart';

import 'messages_ar.dart';
import 'messages_en.dart';
import 'messages_fr.dart';

abstract class JetMessages {
  static JetMessages of(BuildContext context) {
    return Localizations.of<JetMessages>(
          context,
          JetMessages,
        ) ??
        _default;
  }

  static const LocalizationsDelegate<JetMessages> delegate =
      JetMessagesDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ar'),
    Locale('fr'),
  ];

  static final JetMessages _default = JetMessagesEn();

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
  String get requestTimeout;
  String get badCertificate;
  String get badResponse;
  String get requestCancelled;
  String get someFieldsAreInvalid;
  String get passwordNotIdentical;
  String get submit;
  String get connectionError;
  String get serverError;
  String get requestError;
  String get validationError;
  String get somethingWentWrong;
  String get pleaseFixTheFormErrors;

  // Detailed error descriptions
  String get connectionTimeoutDescription;
  String get sendTimeoutDescription;
  String get receiveTimeoutDescription;
  String get badCertificateDescription;
  String get requestCancelledDescription;
  String get connectionErrorDescription;
  String get checkConnection;
  String get restart;

  // HTTP error messages
  String get badRequest;
  String get authenticationFailed;
  String get accessDenied;
  String get notFound;
  String get validationFailed;
  String get tooManyRequests;
  String get clientError;

  // HTTP error descriptions
  String get badRequestDescription;
  String get authenticationFailedDescription;
  String get accessDeniedDescription;
  String get notFoundDescription;
  String get validationFailedDescription;
  String get tooManyRequestsDescription;
  String get clientErrorDescription;
  String get serverErrorDescription;
  String get badGatewayDescription;
  String get serviceUnavailableDescription;
  String get gatewayTimeoutDescription;
}

class JetMessagesDelegate extends LocalizationsDelegate<JetMessages> {
  const JetMessagesDelegate();

  @override
  bool isSupported(Locale locale) => JetMessages.supportedLocales
      .map((Locale e) => e.languageCode)
      .contains(locale.languageCode);

  @override
  Future<JetMessages> load(Locale locale) {
    final JetMessages instance = lookupJetMessages(locale);
    JetLocalizations.setCurrentInstance(instance);
    return SynchronousFuture<JetMessages>(instance);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<JetMessages> old) {
    return false;
  }
}

JetMessages lookupJetMessages(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return JetMessagesAr();
    case 'fr':
      return JetMessagesFr();
    case 'en':
    default:
      return JetMessagesEn();
  }
}
