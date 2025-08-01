import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/resources/theme/notifiers/theme_switcher_notifier.dart';
import 'package:jet/resources/theme/widgets/base_theme_switcher.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

extension on ThemeMode {
  IconData get icon => switch (this) {
    ThemeMode.light => LucideIcons.sun,
    ThemeMode.dark => LucideIcons.moon,
    ThemeMode.system => LucideIcons.laptopMinimal,
  };

  String name(BuildContext context) => switch (this) {
    ThemeMode.light => context.jetI10n.lightTheme,
    ThemeMode.dark => context.jetI10n.darkTheme,
    ThemeMode.system => context.jetI10n.systemTheme,
  };
}

class BottomSheetThemeSwitcher extends BaseThemeSwitcher {
  const BottomSheetThemeSwitcher({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    ThemeSwitcherNotifier notifier,
    ThemeMode state,
  ) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  LucideIcons.palette,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  context.jetI10n.changeTheme,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                ),
              ],
            ),
          ),

          // Locale options
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ThemeMode.values.length,
            itemBuilder: (context, index) {
              final themeMode = ThemeMode.values[index];
              final isSelected = state == themeMode;

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                leading: Icon(
                  themeMode.icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 18,
                ),
                title: Text(
                  themeMode.name(context),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),

                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () async {
                  if (!isSelected) {
                    HapticFeedback.lightImpact();
                    await notifier.switchTheme(themeMode);
                  }
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              );
            },
          ),

          // Bottom padding
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
