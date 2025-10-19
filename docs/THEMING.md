# Theming Documentation

Complete guide to theme management in the Jet framework.

## Overview

Jet provides built-in theme management with persistent storage using **JetStorage** and pre-built UI components. The system supports light mode, dark mode, and system theme following, with automatic persistence across app sessions.

**Packages Used:**
- **riverpod** - ^2.4.9 - [pub.dev](https://pub.dev/packages/riverpod) - State management for theme switching

**Storage:**
- **JetStorage** - Built-in Jet framework storage system for theme preference persistence

**Key Benefits:**
- ✅ Three theme modes: Light, Dark, and System
- ✅ Persistent theme storage across app sessions using JetStorage
- ✅ Pre-built UI components (toggle button, modal, segmented control)
- ✅ Riverpod state management integration
- ✅ Smooth theme transitions
- ✅ System theme detection and following
- ✅ Custom theme configuration support
- ✅ Material 3 design system support
- ✅ Easy programmatic theme switching

## Setup Themes

Configure themes in your app configuration:

```dart
class AppConfig extends JetConfig {
  @override
  ThemeData? get theme => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
  );

  @override
  ThemeData? get darkTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}
```

## Theme Switcher UI

### Toggle Button

```dart
AppBar(
  actions: [
    ThemeSwitcher.toggleButton(context),
  ],
)
```

### Selection Modal

```dart
ThemeSwitcher.show(context);
```

### Segmented Button

```dart
ThemeSwitcher.segmentedButton(context);
```

## Programmatic Control

### Using Riverpod

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeSwitcherProvider);
    final themeNotifier = ref.read(themeSwitcherProvider.notifier);
    
    return ElevatedButton(
      onPressed: () => themeNotifier.toggleTheme(),
      child: Text('Toggle Theme'),
    );
  }
}
```

### Theme Modes

- **Light** - Light theme
- **Dark** - Dark theme
- **System** - Follow system setting

## Features

- ✅ Light, dark, and system theme modes
- ✅ Persistent theme storage with JetStorage
- ✅ Pre-built UI components
- ✅ Riverpod state management integration

## See Also

- [Configuration Documentation](CONFIGURATION.md)
- [Extensions Documentation](EXTENSIONS.md)

