import 'package:flutter/material.dart';

/// Model class for locale information
class LocaleInfo {
  final Locale locale;
  final String displayName;
  final String nativeName;

  const LocaleInfo({
    required this.locale,
    required this.displayName,
    required this.nativeName,
  });
}
