import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/extensions/text_extensions.dart';
import 'package:jet/widgets/widgets/buttons/jet_button.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
              Icon(
                LucideIcons.list,
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
