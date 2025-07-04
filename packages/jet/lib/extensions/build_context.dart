import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jet/localization/intl/messages.dart';

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  JetLocalizationsImpl get jetI10n => JetLocalizationsImpl.of(this);

  bool get isAndroid => Platform.isAndroid;

  bool get isIOS => Platform.isIOS;
}
