import 'package:flutter/material.dart';
import 'package:jet_flutter_framework/extensions/build_context.dart';
import 'package:jet_flutter_framework/jet_framework.dart';

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
            icon: PhosphorIcon(PhosphorIcons.arrowClockwise()),
          ),
      ],
    );
  }
}
