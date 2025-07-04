import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/resources/theme/notifiers/theme_switcher_notifier.dart';
import 'package:jet/resources/theme/widgets/base_theme_switcher.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ToggleButtonSwitcher extends BaseThemeSwitcher {
  const ToggleButtonSwitcher({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    ThemeSwitcherNotifier notifier,
    ThemeMode state,
  ) {
    return IconButton(
      onPressed: () => notifier.switchTheme(
        state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
      ),
      icon: Icon(state == ThemeMode.light ? LucideIcons.sun : LucideIcons.moon),
    );
  }
}
