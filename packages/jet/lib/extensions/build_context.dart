import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jet/localization/intl/messages.dart';

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  JetLocalizationsImpl get jetI10n => JetLocalizationsImpl.of(this);

  bool get isAndroid => Platform.isAndroid;

  bool get isIOS => Platform.isIOS;

  void showToast(
    String message, {
    Duration? duration,
    bool clearOldToasts = true,
    void Function()? onPressed,
    String? actionLabel,
  }) {
    if (clearOldToasts) {
      ScaffoldMessenger.of(this).clearSnackBars();
    }
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        content: Text(
          message,
          style: TextStyle(
            fontFamily: theme.textTheme.bodyMedium?.fontFamily,
          ),
        ),
        duration: duration ?? const Duration(seconds: 3),
        action: onPressed != null
            ? SnackBarAction(
                label: actionLabel ?? jetI10n.retry,
                onPressed: onPressed,
              )
            : null,
      ),
    );
  }
}
