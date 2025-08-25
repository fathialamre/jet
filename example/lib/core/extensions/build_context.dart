import 'package:example/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  AppLocalizations get localizations =>
      Localizations.of(this, AppLocalizations)!;
}
