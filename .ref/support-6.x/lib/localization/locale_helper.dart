import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class NyLocaleHelper {
  /// Get the current system locale
  static Locale getCurrentLocale({BuildContext? context}) {
    if (context != null) {
      // Preferred way - get locale from context
      return Localizations.localeOf(context);
    }

    // Fallback to platform dispatcher if context is not available
    return ui.PlatformDispatcher.instance.locale;
  }

  /// Get just the language code
  static String getLanguageCode({BuildContext? context}) {
    return getCurrentLocale(context: context).languageCode;
  }

  /// Get the country code if available
  static String? getCountryCode({BuildContext? context}) {
    return getCurrentLocale(context: context).countryCode;
  }

  /// Check if the current locale matches a specific locale
  static bool matchesLocale(BuildContext? context, String languageCode,
      [String? countryCode]) {
    final currentLocale = getCurrentLocale(context: context);
    if (countryCode != null) {
      return currentLocale.languageCode == languageCode &&
          currentLocale.countryCode == countryCode;
    }
    return currentLocale.languageCode == languageCode;
  }
}
