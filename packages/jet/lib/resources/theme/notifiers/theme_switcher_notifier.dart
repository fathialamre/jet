import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/storage/local_storage.dart';
import 'package:jet/helpers/jet_logger.dart';

extension ThemeModeExtension on ThemeMode {
  static ThemeMode fromString(String value) {
    return ThemeMode.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ThemeMode.system,
    );
  }
}

/// Theme switcher state notifier
class ThemeSwitcherNotifier extends Notifier<ThemeMode> {
  static const String _storageKey = 'jet_theme_mode';

  @override
  ThemeMode build() {
    try {
      final savedTheme = JetStorage.read<String>(
        _storageKey,
        defaultValue: ThemeMode.system.name,
      );

      if (savedTheme != null) {
        final themeMode = ThemeMode.values.firstWhere(
          (e) => e.name == savedTheme,
          orElse: () => ThemeMode.system,
        );
        dump('[ThemeSwitcher] Loaded theme: ${themeMode.name}');
        return themeMode;
      }
    } catch (e, stackTrace) {
      dump('[ThemeSwitcher] Error loading theme: $e', stackTrace: stackTrace);
      // Fallback to system theme if loading fails
    }
    return ThemeMode.system;
  }

  /// Switch to a specific theme mode
  Future<void> switchTheme(ThemeMode themeMode) async {
    try {
      state = themeMode;
      await JetStorage.write(_storageKey, themeMode.name);
      dump('[ThemeSwitcher] Theme switched to: ${themeMode.name}');
    } catch (e, stackTrace) {
      dump('[ThemeSwitcher] Error saving theme: $e', stackTrace: stackTrace);
    }
  }

  /// Toggle between light and dark themes
  Future<void> toggleTheme() async {
    final newTheme = state == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await switchTheme(newTheme);
  }

  /// Switch to light theme
  Future<void> setLightTheme() => switchTheme(ThemeMode.light);

  /// Switch to dark theme
  Future<void> setDarkTheme() => switchTheme(ThemeMode.dark);

  /// Switch to system theme
  Future<void> setSystemTheme() => switchTheme(ThemeMode.system);

  /// Check if current theme is light
  bool get isLight => state == ThemeMode.light;

  /// Check if current theme is dark
  bool get isDark => state == ThemeMode.dark;

  /// Check if current theme is system
  bool get isSystem => state == ThemeMode.system;
}

/// Theme switcher provider
final themeSwitcherProvider =
    NotifierProvider<ThemeSwitcherNotifier, ThemeMode>(
      ThemeSwitcherNotifier.new,
    );

/// Convenience provider for accessing the current theme mode as Flutter's ThemeMode
final currentThemeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(themeSwitcherProvider);
});

/// Provider for checking if the current effective theme is dark
/// (useful for conditional UI rendering)
final isDarkThemeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeSwitcherProvider);

  if (themeMode == ThemeMode.dark) return true;
  if (themeMode == ThemeMode.light) return false;

  // For system theme, check the platform brightness
  return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
      Brightness.dark;
});

/// Extension on WidgetRef for easy theme switching
extension ThemeSwitcherExtension on WidgetRef {
  /// Get the theme switcher notifier
  ThemeSwitcherNotifier get themeSwitcher =>
      read(themeSwitcherProvider.notifier);

  /// Get the current theme mode
  ThemeMode get currentTheme => read(themeSwitcherProvider);

  /// Check if current theme is dark
  bool get isDarkMode => read(isDarkThemeProvider);
}
