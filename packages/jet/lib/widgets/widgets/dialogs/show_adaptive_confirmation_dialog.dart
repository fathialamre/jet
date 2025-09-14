import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/widgets/widgets/buttons/jet_button.dart';
import 'package:jet/widgets/widgets/buttons/jet_cupertino_button.dart';

showAdaptiveConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required Widget icon,
  required FutureOr<void> Function() onConfirm,
  bool barrierDismissible = true,
  final String? confirmText,
  final String? cancelText,
  final bool popOnConfirm = true,
  VoidCallback? onCancel,
}) {
  if (Platform.isIOS) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          JetCupertinoButton(
            text: cancelText ?? context.jetI10n.cancel,
            onTap: () {
              HapticFeedback.lightImpact();
              onCancel?.call();
              if (popOnConfirm && context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
          JetCupertinoButton(
            text: confirmText ?? context.jetI10n.confirm,
            isDefaultAction: true,
            onTap: () async {
              HapticFeedback.lightImpact();
              await onConfirm();
              if (popOnConfirm && context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  } else {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        icon: icon,
        title: Text(title),
        content: Text(message),
        actions: [
          JetButton.textButton(
            text: cancelText ?? context.jetI10n.cancel,
            onTap: () {
              HapticFeedback.lightImpact();
              onCancel?.call();
              if (popOnConfirm && context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
          JetButton.filled(
            text: confirmText ?? context.jetI10n.confirm,
            onTap: () async {
              HapticFeedback.lightImpact();
              await onConfirm();
              if (popOnConfirm && context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
