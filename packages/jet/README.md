# Jet Framework

A production-ready, lightweight Flutter framework for building scalable, maintainable applications.

## Overview

This is the core Jet framework package. For complete documentation, examples, and getting started guides, please visit the main project repository.

## Documentation

**📖 [Complete Documentation](../../README.md)** - Main README with quick start guide

**📚 [Detailed Documentation](../../docs/)** - Comprehensive guides for all features

### Quick Links

- [Configuration](../../docs/CONFIGURATION.md)
- [Routing](../../docs/ROUTING.md)
- [Forms](../../docs/FORMS.md)
- [State Management](../../docs/STATE_MANAGEMENT.md)
- [Networking](../../docs/NETWORKING.md)
- [Components](../../docs/COMPONENTS.md)

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  jet:
    path: ../packages/jet
```

## Quick Example

```dart
import 'package:jet/jet.dart';

class MyApp extends JetConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Jet Framework')),
      body: Center(
        child: Text('Hello from Jet!').titleLarge(context).bold(),
      ),
    );
  }
}
```

## Features

- 🎯 Batteries Included - Everything you need from day one
- 📐 Opinionated Architecture - Best practices built-in
- ⚡ Developer Experience - Minimal boilerplate, fluent APIs
- 🔐 Production Ready - Security, error handling, logging
- 🌍 Global Ready - Built-in i18n and RTL support
- 🧩 Modular Design - Use what you need

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

For contribution guidelines and development setup, please see the main project repository.
