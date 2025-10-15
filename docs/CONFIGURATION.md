# Configuration Documentation

Complete guide to configuring your Jet application.

## Overview

Jet uses `JetConfig` for centralized application configuration including adapters, locales, themes, and network logging. This configuration-first approach ensures that all framework features are set up consistently and can be easily modified from a single location.

**Architecture:**
- **JetConfig Class** - Base configuration class to extend
- **Boot Process** - Initializes all adapters and services
- **Centralized Settings** - Single source of truth for app configuration

**Key Benefits:**
- ✅ Centralized configuration management
- ✅ Type-safe configuration options
- ✅ Easy environment-specific configs
- ✅ Compile-time configuration validation
- ✅ Hot reload friendly
- ✅ Clear separation of concerns
- ✅ Testable configuration

## Basic Configuration

Create a configuration class extending `JetConfig`:

```dart
import 'package:jet/jet.dart';
import 'package:flutter/material.dart';

class AppConfig extends JetConfig {
  @override
  List<JetAdapter> get adapters => [
    RouterAdapter(),
    StorageAdapter(),
    NotificationsAdapter(),
  ];

  @override
  List<LocaleInfo> get supportedLocales => [
    LocaleInfo(
      locale: const Locale('en'),
      displayName: 'English',
      nativeName: 'English',
    ),
    LocaleInfo(
      locale: const Locale('ar'),
      displayName: 'Arabic',
      nativeName: 'العربية',
    ),
  ];

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

## Configuration Properties

### adapters

List of framework extensions to initialize:

```dart
@override
List<JetAdapter> get adapters => [
  RouterAdapter(),
  StorageAdapter(),
  NotificationsAdapter(),
];
```

### supportedLocales

Languages supported by your app:

```dart
@override
List<LocaleInfo> get supportedLocales => [
  LocaleInfo(
    locale: const Locale('en'),
    displayName: 'English',
    nativeName: 'English',
  ),
  LocaleInfo(
    locale: const Locale('fr'),
    displayName: 'French',
    nativeName: 'Français',
  ),
];
```

### theme / darkTheme

App themes for light and dark modes:

```dart
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
```

### dioLoggerConfig

Network logging configuration:

```dart
@override
JetDioLoggerConfig get dioLoggerConfig => JetDioLoggerConfig(
  request: true,
  requestHeader: true,
  requestBody: kDebugMode,
  responseBody: true,
  responseHeader: false,
  error: true,
  compact: true,
  maxWidth: 90,
  enabled: kDebugMode,
);
```

### notificationEvents

Register notification events:

```dart
@override
List<JetNotificationEvent> get notificationEvents => [
  OrderNotificationEvent(),
  PaymentNotificationEvent(),
  MessageNotificationEvent(),
];
```

## Initialization

Initialize Jet with your configuration in `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:jet/jet.dart';
import 'core/config/app_config.dart';
import 'core/router/app_router.dart';

void main() async {
  final config = AppConfig();
  
  Jet.fly(
    setup: () => Boot.start(config),
    setupFinished: (jet) {
      jet.setRouter(appRouterProvider);
      Boot.finished(jet, config);
    },
  );
}
```

## See Also

- [Adapters Documentation](ADAPTERS.md)
- [Theming Documentation](THEMING.md)
- [Localization Documentation](LOCALIZATION.md)
- [Networking Documentation](NETWORKING.md)

