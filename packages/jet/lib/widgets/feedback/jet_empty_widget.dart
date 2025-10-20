import 'package:flutter/material.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/extensions/text.dart';
import 'package:jet/jet_framework.dart';

class JetEmptyWidget extends StatelessWidget {
  const JetEmptyWidget({
    super.key,
    this.icon,
    required this.title,
    this.message,
    this.onTap,
    this.showAction = false,
    this.actionText,
  });

  final Widget? icon;
  final String title;
  final String? message;
  final VoidCallback? onTap;
  final bool showAction;
  final String? actionText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon ??
              PhosphorIcon(
                PhosphorIcons.listBullets(),
                color: context.theme.colorScheme.outline,
                size: 60.sp,
              ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
          ).color(context.theme.colorScheme.onSurface).bold(),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message!,
              textAlign: TextAlign.center,
            ).color(context.theme.colorScheme.onSurfaceVariant),
          ],
          if (showAction && onTap != null) ...[
            const SizedBox(height: 20),
            JetButton(
              text: actionText ?? context.jetI10n.retry,
              onTap: onTap!,
            ),
          ],
        ],
      ),
    );
  }
}
