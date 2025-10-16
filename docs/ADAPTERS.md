# Adapters Documentation

Complete guide to Jet adapters for framework extensions.

## Overview

Adapters integrate third-party services with Jet through a unified interface. All adapters implement the `JetAdapter` interface, which provides lifecycle hooks (`boot` and `afterBoot`) for initialization. This pattern allows clean integration of external packages and services while maintaining separation of concerns.

**Architecture:**
- **JetAdapter Interface** - Base interface all adapters must implement
- **Boot Lifecycle** - Two-phase initialization (boot → afterBoot)
- **Dependency Injection** - Access to Jet instance for configuration

**Key Benefits:**
- ✅ Clean separation of concerns
- ✅ Two-phase initialization for dependency management
- ✅ Easy to test and mock
- ✅ Extensible for custom services
- ✅ Centralized configuration
- ✅ Lazy loading support
- ✅ No coupling between adapters

## Adapter Interface

```dart
abstract class JetAdapter {
  Future<Jet?> boot(Jet jet);
  Future<void> afterBoot(Jet jet);
}
```

## Built-in Adapters

### RouterAdapter

Integrates AutoRoute for navigation:

```dart
class RouterAdapter implements JetAdapter {
  @override
  Future<Jet?> boot(Jet jet) async {
    jet.setRouter(appRouter);
    return jet;
  }

  @override
  Future<void> afterBoot(Jet jet) async {}
}
```

### StorageAdapter

Initializes local storage:

```dart
@override
List<JetAdapter> get adapters => [
  StorageAdapter(),
];
```

### NotificationsAdapter

Sets up local notifications:

```dart
@override
List<JetAdapter> get adapters => [
  NotificationsAdapter(),
];
```

## Custom Adapters

Create custom adapters for your integrations:

```dart
class FirebaseAdapter implements JetAdapter {
  @override
  Future<Jet?> boot(Jet jet) async {
    await Firebase.initializeApp();
    return jet;
  }

  @override
  Future<void> afterBoot(Jet jet) async {
    // Setup after all adapters loaded
    await FirebaseMessaging.instance.requestPermission();
  }
}

// Use in config
@override
List<JetAdapter> get adapters => [
  RouterAdapter(),
  FirebaseAdapter(),
];
```

## See Also

- [Configuration Documentation](CONFIGURATION.md)
- [Notifications Documentation](NOTIFICATIONS.md)

