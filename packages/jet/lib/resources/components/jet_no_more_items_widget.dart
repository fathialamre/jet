import 'package:flutter/material.dart';
import 'package:jet_flutter_framework/extensions/build_context.dart';
import 'package:jet_flutter_framework/jet_framework.dart';

class JetNoMoreItemsWidget extends StatelessWidget {
  const JetNoMoreItemsWidget({
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title ?? context.jetI10n.noMoreItemsTitle),
            Text(message ?? context.jetI10n.noMoreItemsMessage),
            if (showAction)
              IconButton.filledTonal(
                onPressed: onTap,
                icon: PhosphorIcon(PhosphorIcons.arrowClockwise()),
              ),
          ],
        ),
      ),
    );
  }
}
