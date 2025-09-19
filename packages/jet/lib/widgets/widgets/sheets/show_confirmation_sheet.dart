import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jet_flutter_framework/extensions/build_context.dart';
import 'package:jet_flutter_framework/extensions/text_extensions.dart';
import 'package:jet_flutter_framework/widgets/widgets/buttons/jet_button.dart';

enum ConfirmationSheetType {
  normal,
  info,
  success,
  error,
  warning,
}

extension ConfirmationSheetTypeX on ConfirmationSheetType {
  Color color(BuildContext context) {
    switch (this) {
      case ConfirmationSheetType.normal:
        return Theme.of(context).colorScheme.primary;
      case ConfirmationSheetType.info:
        return Colors.blue;
      case ConfirmationSheetType.success:
        return Colors.green;
      case ConfirmationSheetType.error:
        return Colors.red;
      case ConfirmationSheetType.warning:
        return Colors.orange;
    }
  }
}

void showConfirmationSheet({
  required BuildContext context,
  required String title,
  required String message,
  final popOnConfirm = true,
  ConfirmationSheetType type = ConfirmationSheetType.normal,
  IconData icon = Icons.info_outline,
  required FutureOr<void> Function() onConfirm,
  VoidCallback? onCancel,
  final String? confirmText,
  final String? cancelText,
  final Axis buttonLayout = Axis.horizontal,
}) {
  showModalBottomSheet(
    showDragHandle: true,
    context: context,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 22,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 65, color: type.color(context)),
            Text(title).titleLarge(context).bold(),
            const SizedBox(height: 4),
            Text(message),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 16, top: 16),
              child: buttonLayout == Axis.horizontal
                  ? Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        JetButton.outlined(
                          text: cancelText ?? context.jetI10n.cancel,
                          onTap: onCancel ?? () => Navigator.pop(context),
                          foregroundColor: type.color(context),
                          borderColor: type.color(context),
                        ),
                        JetButton.filled(
                          text: confirmText ?? context.jetI10n.confirm,
                          onTap: () async {
                            await onConfirm();
                            if (popOnConfirm && context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                          backgroundColor: type.color(context),
                        ),
                      ],
                    )
                  : Column(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        JetButton.filled(
                          text: confirmText ?? context.jetI10n.confirm,
                          onTap: () async {
                            await onConfirm();
                            if (popOnConfirm && context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                          backgroundColor: type.color(context),
                        ),
                        JetButton.textButton(
                          text: cancelText ?? context.jetI10n.cancel,
                          onTap: onCancel ?? () => Navigator.pop(context),
                          foregroundColor: type.color(context),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    ),
  );
}
