import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jet_flutter_framework/extensions/build_context.dart';

void showAdaptiveSimpleDialog({
  required BuildContext context,
  required String title,
  required String message,
  final String? doneText,
  final bool popOnDone = true,
  bool barrierDismissible = true,
  VoidCallback? onDone,
}) {
  if (Platform.isIOS) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              onDone?.call();
              if (popOnDone && context.mounted) {
                Navigator.pop(context);
              }
            },
            isDefaultAction: true,
            child: Text(doneText ?? context.jetI10n.ok),
          ),
        ],
      ),
    );
  } else {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              onDone?.call();
              if (popOnDone && context.mounted) {
                Navigator.pop(context);
              }
            },
            child: Text(doneText ?? context.jetI10n.ok),
          ),
        ],
      ),
    );
  }
}
