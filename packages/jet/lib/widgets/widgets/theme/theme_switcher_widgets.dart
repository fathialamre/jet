import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/resources/theme/theme_switcher.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:jet/extensions/build_context.dart';

enum JetThemeSwitcherType { segmented, toggle }

class JetThemeSwitcher extends ConsumerWidget {
  /// Creates a segmented button with all theme options (light, dark, system)
  const JetThemeSwitcher.segmented({super.key})
    : type = JetThemeSwitcherType.segmented,
      showLabel = false,
      iconSize = null;

  /// Creates a toggle button to switch between light and dark modes
  const JetThemeSwitcher.toggle({
    Key? key,
    this.showLabel = false,
    this.iconSize,
  }) : type = JetThemeSwitcherType.toggle,
       super(key: key);

  /// The type of theme switcher to display
  final JetThemeSwitcherType type;

  /// Whether to show the theme label text (only applies to toggle type)
  final bool showLabel;

  /// Custom icon size (only applies to toggle type)
  final double? iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (type) {
      case JetThemeSwitcherType.segmented:
        return _buildSegmentedSwitcher(context, ref);
      case JetThemeSwitcherType.toggle:
        return _buildToggleSwitcher(context, ref);
    }
  }

  /// Builds the segmented button theme switcher
  Widget _buildSegmentedSwitcher(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeSwitcherProvider);

    // Labels and icons
    final labels = [
      context.jetI10n.lightTheme,
      context.jetI10n.darkTheme,
      context.jetI10n.systemTheme,
    ];
    final icons = [
      LucideIcons.sun,
      LucideIcons.moon,
      LucideIcons.laptopMinimal,
    ];

    return SegmentedButton<JetThemeMode>(
      segments: [
        ButtonSegment<JetThemeMode>(
          value: JetThemeMode.light,
          icon: Icon(icons[0]),
          label: Text(labels[0]),
        ),
        ButtonSegment<JetThemeMode>(
          value: JetThemeMode.dark,
          icon: Icon(icons[1]),
          label: Text(labels[1]),
        ),
        ButtonSegment<JetThemeMode>(
          value: JetThemeMode.system,
          icon: Icon(icons[2]),
          label: Text(labels[2]),
        ),
      ],
      selected: {currentTheme},
      onSelectionChanged: (Set<JetThemeMode> selection) {
        if (selection.isNotEmpty) {
          ref.read(themeSwitcherProvider.notifier).switchTheme(selection.first);
        }
      },
    );
  }

  /// Builds the toggle button theme switcher
  Widget _buildToggleSwitcher(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeSwitcherProvider);
    final isDark = ref.watch(isDarkThemeProvider);

    // Determine the current state for display
    final isCurrentlyDark =
        currentTheme == JetThemeMode.dark ||
        (currentTheme == JetThemeMode.system && isDark);

    final icon = isCurrentlyDark ? LucideIcons.moon : LucideIcons.sun;
    final label = isCurrentlyDark
        ? context.jetI10n.darkTheme
        : context.jetI10n.lightTheme;

    if (showLabel) {
      return TextButton.icon(
        onPressed: () {
          ref.read(themeSwitcherProvider.notifier).toggleTheme();
        },
        icon: Icon(icon, size: iconSize),
        label: Text(label),
      );
    }

    return IconButton(
      onPressed: () {
        ref.read(themeSwitcherProvider.notifier).toggleTheme();
      },
      icon: Icon(icon, size: iconSize),
      tooltip: label,
    );
  }
}
