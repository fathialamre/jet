import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/widgets/theme/base_theme_switcher.dart';

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
      icon: Icon(
        state == ThemeMode.light ? PhosphorIcons.sun() : PhosphorIcons.moon(),
      ),
    );
  }
}
