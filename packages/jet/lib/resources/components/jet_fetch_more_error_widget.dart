import 'package:flutter/material.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class JetFetchMoreErrorWidget extends StatelessWidget {
  const JetFetchMoreErrorWidget({
    super.key,
    this.title,
    this.message,
    this.onTap,
    this.showAction = false,
    this.actionText,
  });

  final String? title;
  final String? message;
  final VoidCallback? onTap;
  final bool showAction;
  final String? actionText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title ?? context.jetI10n.somethingWentWrongWhileFetchingNewPage),
        Text(message ?? context.jetI10n.unknownError),
        if (showAction)
          IconButton.filledTonal(
            onPressed: onTap,
            icon: const Icon(LucideIcons.rotateCw),
          ),
      ],
    );
  }
}
