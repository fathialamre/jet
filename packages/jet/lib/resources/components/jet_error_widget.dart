import 'package:flutter/material.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/extensions/text_extensions.dart';
import 'package:jet/widgets/widgets/buttons/jet_button.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class JetErrorWidget extends StatelessWidget {
  const JetErrorWidget({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.onTap,
    this.showRetry = true,
    this.retryText,
  });

  final IconData icon;
  final String title;
  final String? message;
  final VoidCallback? onTap;
  final bool showRetry;
  final String? retryText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.circleAlert, color: Colors.red, size: 60),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
          ).color(context.theme.colorScheme.inverseSurface).bold(),
          if (message != null)
            Text(
              message!,
              textAlign: TextAlign.center,
            ).color(context.theme.colorScheme.inverseSurface),
          const SizedBox(height: 12),
          if (showRetry)
            JetButton(
              text: retryText ?? context.jetI10n.retry,
              onTap: onTap ?? () {},
            ),
        ],
      ),
    );
  }
}
