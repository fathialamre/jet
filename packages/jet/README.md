# 🚀 Jet Framework

**Jet** is a lightweight, modular Flutter framework for scalable app architecture, providing dependency injection, lifecycle management, and streamlined setup for rapid development. Built with **Riverpod 3** for enhanced state management and code generation capabilities.

## 📦 Installation

Add Jet to your Flutter project:

```yaml
dependencies:
  jet: ^0.0.3-alpha.2
```

## 🚀 Quick Start

1. **Create your app configuration:**

```dart
import 'package:jet/jet.dart';

class AppConfig extends JetConfig {
  @override
  List<JetAdapter> get adapters => [RouterAdapter()];

  @override
  List<LocaleInfo> get supportedLocales => [
    LocaleInfo(locale: const Locale('en'), displayName: 'English', nativeName: 'English'),
  ];
}
```

2. **Set up main.dart:**

```dart
import 'package:jet/jet.dart';
import 'core/config/app_config.dart';

void main() async {
  final config = AppConfig();
  Jet.fly(
    setup: () => Boot.start(config),
    setupFinished: (jet) => Boot.finished(jet, config),
  );
}
```

## 🎯 Key Features

- **🚀 Rapid Development** - Get started in minutes with comprehensive setup
- **📱 Modern Architecture** - Built on Riverpod 3 with code generation support
- **🔧 Type Safety** - Full type safety across forms, networking, and state management
- **🌐 Internationalization** - Built-in localization with RTL support
- **🎨 Theming** - Complete theme management with persistent storage
- **🔐 Security** - App locking with biometric authentication
- **📝 Forms** - Advanced form management with validation and error handling
- **🌐 Networking** - Type-safe HTTP client with configurable logging
- **💾 Storage** - Secure storage for sensitive data and regular preferences
- **🗄️ Caching** - TTL-based caching with Hive for offline capabilities
- **🔄 State Management** - Unified state widgets with automatic loading/error states
- **🔔 Notifications** - Cross-platform local notifications with scheduling and management
- **🐛 Debugging** - Enhanced debugging tools with stack trace formatting
- **🔐 Sessions** - Built-in authentication and session management
- **🧩 Components** - Pre-built UI components for common patterns

## 📚 Documentation

For complete documentation, visit our [GitHub repository](https://github.com/fathialamre/jet).

## 🤝 Contributing

We welcome contributions! Please see our [contributing guidelines](https://github.com/fathialamre/jet/blob/main/CONTRIBUTING.md) for details.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
