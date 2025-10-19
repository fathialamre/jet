import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/utils/theme_switcher/notifiers/theme_switcher_notifier.dart';
import 'package:jet/utils/theme_switcher/widgets/base_theme_switcher.dart';

class SegmentedButtonThemeSwitcher extends BaseThemeSwitcher {
  const SegmentedButtonThemeSwitcher({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    ThemeSwitcherNotifier notifier,
    ThemeMode state,
  ) {
    return SegmentedButton<ThemeMode>(
      segments: [
        ButtonSegment<ThemeMode>(
          value: ThemeMode.light,
          label: Text(context.jetI10n.lightTheme),
        ),
        ButtonSegment<ThemeMode>(
          value: ThemeMode.dark,
          label: Text(context.jetI10n.darkTheme),
        ),
        ButtonSegment<ThemeMode>(
          value: ThemeMode.system,
          label: Text(context.jetI10n.systemTheme),
        ),
      ],
      onSelectionChanged: (value) => notifier.switchTheme(value.first),
      selected: {state},
    );
  }
}
