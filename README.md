<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Jet Framework

A comprehensive Flutter framework package that provides essential building blocks for modern Flutter applications including routing, localization, theming, storage, and UI components.

## 📁 Project Structure

### `/lib` - Main Package Structure

```
lib/
├── jet.dart                    # Main package export file
├── jet_framework.dart          # Framework initialization
├── adapters/                   # Interface adapters
│   ├── adapters.dart          # Main adapters export
│   ├── jet_adapter.dart       # Core Jet adapter interface
│   └── storage_adapter.dart   # Storage adapter interface
├── bootstrap/                  # Application bootstrapping
│   └── boot.dart             # Bootstrap configuration
├── config/                    # Configuration management
│   └── jet_config.dart       # Main configuration class
├── extensions/                # Dart extensions
│   ├── build_context.dart    # BuildContext extensions
│   └── text_extensions.dart  # Text styling extensions
├── helpers/                   # Utility helpers
│   └── jet_logger.dart       # Logging utilities
├── localization/             # Internationalization
│   ├── i10n.dart            # Localization setup
│   ├── intl/                # Generated message files
│   │   ├── messages.dart    # Main messages class
│   │   ├── messages_en.dart # English messages
│   │   └── messages_ar.dart # Arabic messages
│   └── widgets/             # Localization widgets
│       └── language_switcher.dart
├── resources/               # App resources
│   └── theme/              # Theme management
│       └── theme_switcher.dart
├── router/                 # Navigation routing
│   └── jet_router.dart    # Router configuration
├── storage/               # Data storage
│   ├── local_storage.dart # Local storage implementation
│   └── model.dart        # Storage models
└── widgets/              # UI Components
    ├── jet_main.dart    # Main app widget
    └── widgets/         # Component library
        ├── buttons/     # Button components
        │   ├── jet_button.dart
        │   └── jet_cupertino_button.dart
        ├── dialogs/     # Dialog components
        │   ├── show_adaptive_confirmation_dialog.dart
        │   └── show_adaptive_simple_dialog.dart
        ├── sheets/      # Bottom sheet components
        │   └── show_confirmation_sheet.dart
        └── theme/       # Theme widgets
            └── theme_switcher_widgets.dart
```

## 🚀 Getting Started

### Installation

Add Jet to your `pubspec.yaml`:

```yaml
dependencies:
  jet:
    path: ../packages/jet  # Adjust path as needed
```

### Dependencies

Jet relies on the following key packages:
- `auto_route` (^10.1.0+1) - For routing
- `lucide_icons_flutter` (^3.0.6) - For icons
- `flutter_secure_storage` (^9.2.4) - For secure storage
- `shared_preferences` (^2.5.3) - For preferences
- `hooks_riverpod` (^2.6.1) - For state management
- `intl` (^0.20.2) - For internationalization

## 🏗️ Core Components

### 1. **Bootstrap (`/bootstrap`)**
Application initialization and configuration setup.

**Key Files:**
- `boot.dart` - Handles app bootstrapping and initial configuration

### 2. **Configuration (`/config`)**
Centralized configuration management for the entire application.

**Key Files:**
- `jet_config.dart` - Main configuration class with app settings

### 3. **Adapters (`/adapters`)**
Interface adapters that provide abstraction layers for various functionalities.

**Key Files:**
- `jet_adapter.dart` - Core adapter interface
- `storage_adapter.dart` - Storage abstraction layer

### 4. **Router (`/router`)**
Navigation and routing management built on top of auto_route.

**Key Files:**
- `jet_router.dart` - Router configuration and setup

### 5. **Storage (`/storage`)**
Data persistence layer with support for secure and regular storage.

**Key Files:**
- `local_storage.dart` - Local storage implementation
- `model.dart` - Storage model definitions

### 6. **Localization (`/localization`)**
Complete internationalization support with built-in language switching.

**Key Features:**
- Support for multiple languages (English, Arabic)
- Language switcher widget
- Automatic locale detection
- RTL support

**Key Files:**
- `i10n.dart` - Localization setup and configuration
- `language_switcher.dart` - Language switching UI component

### 7. **Extensions (`/extensions`)**
Useful Dart extensions for enhanced development experience.

**Key Files:**
- `build_context.dart` - BuildContext convenience methods
- `text_extensions.dart` - Rich text styling extensions

### 8. **Helpers (`/helpers`)**
Utility classes and helper functions.

**Key Files:**
- `jet_logger.dart` - Comprehensive logging system

### 9. **Resources (`/resources`)**
App resources including themes and styling.

**Key Files:**
- `theme_switcher.dart` - Theme management and switching

### 10. **Widgets (`/widgets`)**
Comprehensive UI component library with adaptive design support.

**Component Categories:**

#### **Buttons**
- `jet_button.dart` - Primary button component
- `jet_cupertino_button.dart` - iOS-style button component

#### **Dialogs**
- `show_adaptive_confirmation_dialog.dart` - Confirmation dialogs
- `show_adaptive_simple_dialog.dart` - Simple alert dialogs

#### **Sheets**
- `show_confirmation_sheet.dart` - Bottom sheet confirmations

#### **Theme**
- `theme_switcher_widgets.dart` - Theme switching UI components

## 📖 Usage Examples

### Basic App Setup

```dart
import 'package:jet/jet.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetMain(
      // Your app configuration
    );
  }
}
```

### App Configuration

The Jet framework uses a centralized configuration approach through the `JetConfig` class. Create your own configuration by extending `JetConfig`:

```dart
import 'package:flutter/material.dart';
import 'package:jet/config/jet_config.dart';
import 'package:jet/adapters/jet_adapter.dart';

class AppConfig extends JetConfig {
  @override
  List<JetAdapter> get adapters => [
    RouterAdapter(),
    // Add more adapters as needed
  ];

  @override
  List<Locale> get supportedLocales => [
    const Locale('en'),
    const Locale('ar'),
    const Locale('es'),
  ];

  @override
  Locale? get defaultLocale => const Locale('en');

  @override
  ThemeData? get theme => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  );

  @override
  ThemeData? get darkTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
  );

  @override
  List<LocalizationsDelegate<Object>> get localizationsDelegates => [
    // Add custom localization delegates if needed
  ];
}
```

#### Configuration Options

| Property | Type | Description |
|----------|------|-------------|
| `adapters` | `List<JetAdapter>` | List of adapters for extending framework functionality (routing, API, analytics, etc.) |
| `supportedLocales` | `List<Locale>` | Languages your app supports |
| `defaultLocale` | `Locale?` | Fallback language when device locale isn't supported |
| `theme` | `ThemeData?` | Light mode theme configuration |
| `darkTheme` | `ThemeData?` | Dark mode theme configuration |
| `localizationsDelegates` | `List<LocalizationsDelegate>` | Additional localization delegates for third-party packages |

#### Advanced Configuration Examples

**Multi-language with RTL Support:**
```dart
@override
List<Locale> get supportedLocales => [
  const Locale('en', 'US'),    // English (US)
  const Locale('ar', 'LY'),    // Arabic (Libya)
];

@override
Locale? get defaultLocale => const Locale('en', 'US');
```

**Custom Theme with Material 3:**
```dart
@override
ThemeData? get theme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF6750A4),
  ),
  fontFamily: 'Roboto',
);

@override
ThemeData? get darkTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF6750A4),
    brightness: Brightness.dark,
  ),
  fontFamily: 'Roboto',
);
```

**Multiple Adapters Setup:**
```dart
@override
List<JetAdapter> get adapters => [
  RouterAdapter(),
  ApiAdapter(baseUrl: 'https://api.example.com'),
  AnalyticsAdapter(trackingId: 'GA-XXXXX-X'),
  NotificationAdapter(),
];
```

#### Setting Up main.dart

After creating your `AppConfig` class, set up your `main.dart` file to initialize the Jet framework:

```dart
import 'package:example/core/config/app.dart';
import 'package:jet/jet_framework.dart';

void main() async {
  final config = AppConfig();

  Jet.fly(
    setup: () => Boot.start(config),
    setupFinished: (jet) => Boot.finished(jet, config),
  );
}
```

#### Main.dart Setup Explanation

**1. Configuration Instance**
```dart
final config = AppConfig();
```
- Create an instance of your custom configuration class
- This contains all your app's configuration (themes, locales, adapters, etc.)

**2. Jet.fly() Method**
```dart
Jet.fly(
  setup: () => Boot.start(config),
  setupFinished: (jet) => Boot.finished(jet, config),
);
```

The `Jet.fly()` method is the main entry point that handles the complete app lifecycle:

| Parameter | Type | Description |
|-----------|------|-------------|
| `setup` | `Function` | Called during app initialization - sets up the framework with your config |
| `setupFinished` | `Function(JetFramework)` | Called after setup completes - finalizes the app launch |

**3. Boot Process**
- `Boot.start(config)` - Initializes the Jet framework with your configuration
- `Boot.finished(jet, config)` - Completes the setup and launches your app

#### Boot Lifecycle

The boot process follows this sequence:

1. **App Start** → `main()` function called
2. **Configuration** → `AppConfig()` instance created
3. **Framework Setup** → `Boot.start(config)` initializes Jet framework
4. **Services Loading** → Adapters, storage, routing, themes initialized
5. **App Launch** → `Boot.finished()` launches the Flutter app
6. **UI Ready** → Your app is ready for user interaction

#### Best Practices

- **Keep main.dart simple** - All configuration should be in your `AppConfig` class
- **Async initialization** - Use `async/await` for any setup that requires it
- **Environment-specific configs** - Create different config classes for dev/staging/prod

### Using Routing

Jet Framework uses a router to manage navigation within the application by relying on the **[Auto Route](https://pub.dev/packages/auto_route)** package, which provides a flexible and clear way to define routes and handle navigation safely and efficiently. 

Additionally, we use **[Riverpod](https://pub.dev/packages/hooks_riverpod)** to create a `RouterProvider`, allowing us to integrate routing with the app's state management and dependency injection system.

**AutoRoute integration:**

Auto Route is a powerful routing solution for Flutter that automatically generates route definitions and navigation-related code. It simplifies navigation, reduces boilerplate, and helps maintain clean, scalable architecture, especially in large or complex applications.

For more information about the library:
[https://pub.dev/packages/auto_route](https://pub.dev/packages/auto_route)

#### Setting Up Your Router

Create your app router by extending `RootStackRouter`:

```dart
import 'package:example/features/login/pages/login_page.dart';
import 'package:jet/jet_framework.dart';

class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    NamedRouteDef(
      name: 'LoginRoute',
      builder: (context, args) => LoginPage(),
      initial: true,
    ),
  ];
}

final appRouter = AutoDisposeProvider<AppRouter>(
  (ref) => AppRouter(),
);
```

#### Router Configuration

| Component | Description |
|-----------|-------------|
| `RootStackRouter` | Base class for your main router configuration |
| `NamedRouteDef` | Defines a named route with a builder function |
| `AutoDisposeProvider` | Riverpod provider for dependency injection |
| `initial: true` | Sets the route as the initial/home route |

#### Adding More Routes

```dart
@override
List<AutoRoute> get routes => [
  NamedRouteDef(
    name: 'LoginRoute',
    builder: (context, args) => LoginPage(),
    initial: true,
  ),
  NamedRouteDef(
    name: 'DashboardRoute',
    builder: (context, args) => DashboardPage(),
  ),
  NamedRouteDef(
    name: 'ProfileRoute',
    builder: (context, args) => ProfilePage(),
  ),
];
```

#### Navigation Examples

```dart
// Navigate to a route
context.router.pushNamed('/dashboard');

// Navigate with parameters
context.router.pushNamed('/profile', arguments: {'userId': 123});

// Replace current route
context.router.replaceNamed('/dashboard');

// Pop back
context.router.pop();
```

**Note:**
As I mentioned earlier, you can take advantage of the power of [AutoRoute](https://pub.dev/packages/auto_route) and use code generation.

### Adapters

Adapters are a powerful tool that helps structure the **Jet framework** by organizing and registering the usage of third-party packages in a clean and scalable way. They serve as an integration layer, allowing external libraries and services to be smoothly plugged into the project without tightly coupling them to the core logic.

With Adapters, we can manage dependencies, centralize configurations, and simplify the process of replacing or updating packages when needed. This ensures that our application remains modular, maintainable, and ready to scale.

A clear example of this is how we can create Adapters for services like **Firebase**, **analytics libraries**, or any other external tool, ensuring that the integration follows the project standards and can be easily maintained.

Even libraries like **[AutoRoute](https://pub.dev/packages/auto_route)** can be integrated through Adapters, allowing route definitions, guards, and navigation logic to be structured separately from the core application logic, which enhances testability and flexibility.

By adopting the Adapter pattern, we ensure that our project remains clean, modular, and easy to extend as new tools or services are introduced.

#### Adapter Interface

All adapters implement the `JetAdapter` interface:

```dart
abstract class JetAdapter {
  Future<Jet?> boot(Jet jet);
  Future<void> afterBoot(Jet jet);
}
```

| Method | Description |
|--------|-------------|
| `boot(Jet jet)` | Called during **the Jet framework** initialization - register services, configure dependencies |
| `afterBoot(Jet jet)` | Called after all adapters have booted - perform final setup tasks |

#### Router Adapter Example

Here's how the RouterAdapter integrates [AutoRoute](https://pub.dev/packages/auto_route) with the **Jet framework**:

```dart
import 'package:example/core/router/app_router.dart';
import 'package:jet/jet_framework.dart';

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

#### Adapter Lifecycle

1. **Registration** → Adapters are added to your `AppConfig`
2. **Boot Phase** → `boot()` method called for each adapter in sequence
3. **After Boot** → `afterBoot()` method called for final setup
4. **Ready** → The ** Jet framework** is fully configured and ready

#### Creating Custom Adapters

**Firebase Adapter Example:**
```dart
class FirebaseAdapter implements JetAdapter {
  @override
  Future<Jet?> boot(Jet jet) async {
    await Firebase.initializeApp();
    
    // Configure Firebase services
    FirebaseAuth.instance.setSettings(
      appVerificationDisabledForTesting: false,
    );
    
    return jet;
  }

  @override
  Future<void> afterBoot(Jet jet) async {
    // Setup crash reporting after all adapters are loaded
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }
}
```

**Analytics Adapter Example:**
```dart
class AnalyticsAdapter implements JetAdapter {
  final String trackingId;
  
  AnalyticsAdapter({required this.trackingId});

  @override
  Future<Jet?> boot(Jet jet) async {
    await GoogleAnalytics.initialize(trackingId);
    
    // Register analytics service globally
    jet.registerService<AnalyticsService>(
      AnalyticsService(trackingId: trackingId),
    );
    
    return jet;
  }

  @override
  Future<void> afterBoot(Jet jet) async {
    // Track app launch after everything is ready
    await jet.getService<AnalyticsService>().trackEvent('app_launched');
  }
}
```

#### Using Multiple Adapters

In your `AppConfig`, register all your adapters:

```dart
@override
List<JetAdapter> get adapters => [
  RouterAdapter(),
  FirebaseAdapter(),
  AnalyticsAdapter(trackingId: 'GA-XXXXX-X'),
];
```

#### Adapter Best Practices

- **Single Responsibility** - Each adapter should handle one specific integration
- **Error Handling** - Wrap setup code in try-catch blocks for graceful failures
- **Dependencies** - Use `afterBoot()` for setup that depends on other adapters
- **Service Registration** - Register reusable services in the `boot()` method
- **Configuration** - Accept configuration through constructor parameters
- **Testing** - Create mock adapters for testing environments

### JetStorage

JetStorage is a tool for securely storing data locally. It provides a set of simple and clear methods for reading, writing, and managing key-value pairs. It is designed for storing lightweight data such as tokens, user preferences, small JSON objects, and other essential configurations.

JetStorage ensures that data is stored securely and provides easy-to-use functions for saving and retrieving information without complexity.

**Important Note:**
JetStorage is not designed for storing large amounts of data or handling massive files. It is intended for small, essential pieces of data only. For large datasets or files, other storage solutions should be used.

#### Storage Types

JetStorage provides two types of storage:

| Storage Type | Method Prefix | Description | Use Cases |
|--------------|---------------|-------------|-----------|
| **Regular Storage** | `write()`, `read()` | Uses SharedPreferences for general data | User preferences, app settings, non-sensitive data |
| **Secure Storage** | `writeSecure()`, `readSecure()` | Uses FlutterSecureStorage with encryption | Tokens, passwords, sensitive user data |

#### Basic Usage

**Storing Data:**
```dart
import 'package:jet/storage/local_storage.dart';

// Store different data types
await JetStorage.write('user_name', 'John Doe');
await JetStorage.write('user_age', 25);
await JetStorage.write('is_premium', true);
await JetStorage.write('user_score', 89.5);
```

**Reading Data:**
```dart
// Read with type inference
String? userName = JetStorage.read<String>('user_name');
int? userAge = JetStorage.read<int>('user_age');
bool? isPremium = JetStorage.read<bool>('is_premium');
double? userScore = JetStorage.read<double>('user_score');

// Read with default values
String userName = JetStorage.read<String>('user_name', defaultValue: 'Guest');
int userAge = JetStorage.read<int>('user_age', defaultValue: 0);
```

#### Secure Storage

For sensitive data that requires encryption:

```dart
// Store secure data
await JetStorage.writeSecure('auth_token', 'your-jwt-token');
await JetStorage.writeSecure('user_password', 'encrypted-password');

// Read secure data
String? authToken = await JetStorage.readSecure('auth_token');
String? userPassword = await JetStorage.readSecure('user_password');

// Delete secure data
await JetStorage.deleteSecure('auth_token');

// Clear all secure data
await JetStorage.clearSecure();
```

#### Working with JSON Objects

Store and retrieve complex objects:

```dart
// Store JSON data
Map<String, dynamic> userProfile = {
  'name': 'John Doe',
  'email': 'john@example.com',
  'preferences': {
    'theme': 'dark',
    'language': 'en'
  }
};

await JetStorage.write('user_profile', userProfile);

// Read JSON data
Map<String, dynamic>? profile = JetStorage.read<Map<String, dynamic>>('user_profile');
```

#### Custom Models

For custom objects, implement the `Model` interface:

```dart
class UserModel implements Model {
  final String name;
  final String email;
  final int age;

  UserModel({required this.name, required this.email, required this.age});

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'age': age,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      age: json['age'],
    );
  }
}

// Store custom model
UserModel user = UserModel(name: 'John', email: 'john@example.com', age: 25);
await JetStorage.write('user', user);

// Read custom model
UserModel? user = JetStorage.read<UserModel>(
  'user',
  decoder: (json) => UserModel.fromJson(json),
);
```

#### Storage Management

```dart
// Delete specific data
await JetStorage.delete('user_name');

// Clear all regular storage
await JetStorage.clear();

// Initialize storage (call this in your app startup)
await JetStorage.init();
```

#### Complete Example

```dart
class UserPreferences {
  static Future<void> saveUserData({
    required String name,
    required String email,
    required bool isDarkMode,
    String? authToken,
  }) async {
    // Save regular preferences
    await JetStorage.write('user_name', name);
    await JetStorage.write('user_email', email);
    await JetStorage.write('dark_mode', isDarkMode);
    
    // Save sensitive data securely
    if (authToken != null) {
      await JetStorage.writeSecure('auth_token', authToken);
    }
  }
  
  static Future<Map<String, dynamic>> getUserData() async {
    return {
      'name': JetStorage.read<String>('user_name', defaultValue: 'Guest'),
      'email': JetStorage.read<String>('user_email', defaultValue: ''),
      'isDarkMode': JetStorage.read<bool>('dark_mode', defaultValue: false),
      'authToken': await JetStorage.readSecure('auth_token'),
    };
  }
  
  static Future<void> clearUserData() async {
    await JetStorage.delete('user_name');
    await JetStorage.delete('user_email');
    await JetStorage.delete('dark_mode');
    await JetStorage.deleteSecure('auth_token');
  }
}
```

#### Key Features

- **Type Safety** - Automatic type conversion and inference
- **Secure Storage** - Encrypted storage for sensitive data
- **JSON Support** - Built-in JSON serialization/deserialization
- **Custom Models** - Support for custom objects implementing `Model` interface
- **Default Values** - Fallback values when data doesn't exist
- **Cross-platform** - Works on both iOS and Android
- **Error Handling** - Built-in error logging and graceful failures

### Using Localization

```dart
import 'package:jet/jet.dart';

// In your widget
Text(context.l10n.welcomeMessage)

// Language switcher
LanguageSwitcher()
```

### Using Theme Switching

```dart
import 'package:jet/jet.dart';

// Theme switcher widget
ThemeSwitcherWidget()
```

### Using Jet Buttons

```dart
import 'package:jet/jet.dart';

JetButton(
  text: 'Click Me',
  onPressed: () {
    // Handle button press
  },
)
```

## 🎨 Features

- **🎯 Adaptive UI** - Components that adapt to iOS and Android design guidelines
- **🌍 Internationalization** - Built-in support for multiple languages with RTL support
- **🎨 Theming** - Complete theme management with light/dark mode support
- **💾 Storage** - Secure and regular storage solutions
- **🧭 Routing** - Powerful routing system built on auto_route
- **📱 Responsive** - Mobile-first responsive design
- **🔧 Extensible** - Easy to extend and customize
- **📚 Well-documented** - Comprehensive documentation and examples

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For support and questions, please open an issue in the repository.
