import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/storage/local_storage.dart';
import 'package:jet/helpers/jet_logger.dart';

/// Enum for available theme modes
enum JetThemeMode {
  light,
  dark,
  system;

  /// Convert to Flutter's ThemeMode
  ThemeMode get flutterThemeMode {
    switch (this) {
      case JetThemeMode.light:
        return ThemeMode.light;
      case JetThemeMode.dark:
        return ThemeMode.dark;
      case JetThemeMode.system:
        return ThemeMode.system;
    }
  }

  /// Create from string for persistence
  static JetThemeMode fromString(String value) {
    switch (value.toLowerCase()) {
      case 'light':
        return JetThemeMode.light;
      case 'dark':
        return JetThemeMode.dark;
      case 'system':
        return JetThemeMode.system;
      default:
        return JetThemeMode.system;
    }
  }

  /// Convert to string for persistence
  String get value => name;
}

/// Theme switcher state notifier
class ThemeSwitcherNotifier extends StateNotifier<JetThemeMode> {
  static const String _storageKey = 'jet_theme_mode';

  ThemeSwitcherNotifier() : super(JetThemeMode.system) {
    _loadTheme();
  }

  /// Load theme from storage
  Future<void> _loadTheme() async {
    try {
      final savedTheme = JetStorage.read<String>(
        _storageKey,
        defaultValue: JetThemeMode.system.value,
      );

      if (savedTheme != null) {
        state = JetThemeMode.fromString(savedTheme);
        dump('[ThemeSwitcher] Loaded theme: ${state.value}');
      }
    } catch (e, stackTrace) {
      dump('[ThemeSwitcher] Error loading theme: $e', stackTrace: stackTrace);
      // Fallback to system theme if loading fails
      state = JetThemeMode.system;
    }
  }

  /// Switch to a specific theme mode
  Future<void> switchTheme(JetThemeMode themeMode) async {
    try {
      state = themeMode;
      await JetStorage.write(_storageKey, themeMode.value);
      dump('[ThemeSwitcher] Theme switched to: ${themeMode.value}');
    } catch (e, stackTrace) {
      dump('[ThemeSwitcher] Error saving theme: $e', stackTrace: stackTrace);
    }
  }

  /// Toggle between light and dark themes
  Future<void> toggleTheme() async {
    final newTheme = state == JetThemeMode.light
        ? JetThemeMode.dark
        : JetThemeMode.light;
    await switchTheme(newTheme);
  }

  /// Switch to light theme
  Future<void> setLightTheme() => switchTheme(JetThemeMode.light);

  /// Switch to dark theme
  Future<void> setDarkTheme() => switchTheme(JetThemeMode.dark);

  /// Switch to system theme
  Future<void> setSystemTheme() => switchTheme(JetThemeMode.system);

  /// Check if current theme is light
  bool get isLight => state == JetThemeMode.light;

  /// Check if current theme is dark
  bool get isDark => state == JetThemeMode.dark;

  /// Check if current theme is system
  bool get isSystem => state == JetThemeMode.system;
}

/// Theme switcher provider
final themeSwitcherProvider =
    StateNotifierProvider<ThemeSwitcherNotifier, JetThemeMode>(
      (ref) => ThemeSwitcherNotifier(),
    );

/// Convenience provider for accessing the current theme mode as Flutter's ThemeMode
final currentThemeModeProvider = Provider<ThemeMode>((ref) {
  final jetThemeMode = ref.watch(themeSwitcherProvider);
  return jetThemeMode.flutterThemeMode;
});

/// Provider for checking if the current effective theme is dark
/// (useful for conditional UI rendering)
final isDarkThemeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeSwitcherProvider);

  if (themeMode == JetThemeMode.dark) return true;
  if (themeMode == JetThemeMode.light) return false;

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
  JetThemeMode get currentTheme => read(themeSwitcherProvider);

  /// Check if current theme is dark
  bool get isDarkMode => read(isDarkThemeProvider);
}


