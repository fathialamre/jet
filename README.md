# 🚀 Jet Framework

**Jet** is a powerful, lightweight Flutter framework designed to accelerate mobile app development with a focus on clean architecture, modularity, and developer experience. Built with modern Flutter best practices, Jet provides a comprehensive toolkit for building scalable, maintainable, and feature-rich mobile applications.

Jet Framework emphasizes **convention over configuration**, offering pre-built solutions for common mobile development challenges while maintaining the flexibility to customize and extend functionality as needed.


## 📦 Installation

Add Jet to your Flutter project by adding it to your `pubspec.yaml` file:

```yaml
dependencies:
  jet:
    path: packages/jet  # For local development
    # git:
    #   url: https://github.com/your-org/jet.git  # For git dependency
    #   ref: main
```

Then run:

```bash
flutter pub get
```



### Quick Start

1. **Create your app configuration:**

```dart
// lib/core/config/app_config.dart
import 'package:jet/jet.dart';

class AppConfig extends JetConfig {
  @override
  List<JetAdapter> get adapters => [
    RouterAdapter(),
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
}
```

2. **Set up your main.dart:**

```dart
// lib/main.dart
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

3. **Create your first page:**

```dart
// lib/features/home/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:jet/jet.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appTitle),
      ),
      body: Center(
        child: JetButton(
          text: 'Welcome to Jet!',
          onPressed: () {
            // Your app logic here
          },
        ),
      ),
    );
  }
}
```

4. **Run your app:**

```bash
flutter run
```

## Table of Contents

- [Jet Framework](#-jet-framework)
- [Installation](#-installation)
  - [Quick Start](#quick-start)
- [App Configuration](#️-app-configuration)
  - [Configuration Options](#configuration-options)
  - [Advanced Configuration Examples](#advanced-configuration-examples)
  - [Setting Up main.dart](#setting-up-maindart)
  - [Main.dart Setup Explanation](#maindart-setup-explanation)
  - [Boot Lifecycle](#boot-lifecycle)
  - [Best Practices](#best-practices)
- [Using Routing](#-using-routing)
  - [Setting Up Your Router](#setting-up-your-router)
  - [Router Configuration](#router-configuration)
  - [Adding More Routes](#adding-more-routes)
  - [Navigation Examples](#navigation-examples)
- [Adapters](#-adapters)
  - [Adapter Interface](#adapter-interface)
  - [Router Adapter Example](#router-adapter-example)
  - [Adapter Lifecycle](#adapter-lifecycle)
  - [Creating Custom Adapters](#creating-custom-adapters)
  - [Using Multiple Adapters](#using-multiple-adapters)
  - [Adapter Best Practices](#adapter-best-practices)
- [JetStorage](#-jetstorage)
  - [Storage Types](#storage-types)
  - [Basic Usage](#basic-usage)
  - [Secure Storage](#secure-storage)
  - [Working with JSON Objects](#working-with-json-objects)
  - [Custom Models](#custom-models)
  - [Storage Management](#storage-management)
  - [Complete Example](#complete-example)
  - [Key Features](#key-features)
- [Using Theme Switching](#-using-theme-switching)
  - [Theme Switcher Components](#theme-switcher-components)
  - [Basic Usage](#basic-usage-2)
  - [Custom Theme Switcher using BaseThemeSwitcher](#custom-theme-switcher-using-basethemeswitcher)
  - [Advanced Usage with State Management](#advanced-usage-with-state-management-1)
  - [Complete Integration Example](#complete-integration-example-1)
  - [ThemeSwitcherNotifier Methods](#themeswitchernotifier-methods)
  - [Key Features](#key-features-2)
- [Using Localization](#-using-localization)
  - [Language Switcher Components](#language-switcher-components)
  - [Basic Usage](#basic-usage-3)
  - [Custom Language Switcher using BaseLanguageSwitcher](#custom-language-switcher-using-baselanguageswitcher)
  - [Advanced Usage with State Management](#advanced-usage-with-state-management-2)
  - [Adding Custom Locales](#adding-custom-locales)
  - [Integration with App Configuration](#integration-with-app-configuration)
  - [Complete Integration Example](#complete-integration-example-2)
  - [Key Features](#key-features-3)
- [Networking](#-networking)
  - [Core Components](#core-components)
  - [JetApiService - HTTP Client](#jetapiservice---http-client)
  - [ResponseModel - Standardized Responses](#responsemodel---standardized-responses)
  - [HTTP Methods](#http-methods)
  - [File Operations](#file-operations)
  - [Error Handling Integration](#error-handling-integration)
  - [Custom Interceptors](#custom-interceptors)
  - [Request Management](#request-management)
  - [Authentication Integration](#authentication-integration)
  - [Complete Examples](#complete-examples)
  - [Key Features](#key-features-7)
- [Exception Handling](#-exception-handling)
  - [Exception System Overview](#exception-system-overview)
  - [Exception Hierarchy](#exception-hierarchy)
  - [JetResult Pattern](#jetresult-pattern)
  - [Error Handler Configuration](#error-handler-configuration)
  - [Custom Error Handlers](#custom-error-handlers)
  - [Framework Integration](#framework-integration)
  - [Migration Guide](#migration-guide)
  - [Exception Handling Examples](#exception-handling-examples)
  - [Key Features](#key-features-4)
- [Forms](#-forms)
  - [Core Components](#core-components-2)
  - [AsyncFormValue - Form State Management](#asyncformvalue---form-state-management)
  - [JetFormNotifier - Form Controller](#jetformnotifier---form-controller)
  - [JetFormBuilder - Form Widget](#jetformbuilder---form-widget)
  - [Form Input Components](#form-input-components)
  - [Form Examples](#form-examples)
  - [Error Handling in Forms](#error-handling-in-forms)
  - [Key Features](#key-features-6)
- [State Management](#-state-management)
  - [Core Components](#core-components-1)
  - [JetBuilder - Unified State Management](#jetbuilder---unified-state-management)
  - [Family Provider Support](#family-provider-support)
  - [JetPaginator - Infinite Scroll Pagination](#jetpaginator---infinite-scroll-pagination)
  - [JetConsumer Widgets](#jetconsumer-widgets)
  - [Pagination Models](#pagination-models)
  - [Provider Extensions](#provider-extensions)
  - [Performance Optimizations](#performance-optimizations)
  - [Complete Example](#complete-example-1)
  - [Key Features](#key-features-5)

## ⚙️ App Configuration

The Jet framework uses a centralized configuration approach through the `JetConfig` class. Create your own configuration by extending `JetConfig`:

```dart
import 'package:flutter/material.dart';
import 'package:jet/config/jet_config.dart';
import 'package:jet/adapters/jet_adapter.dart';
import 'package:jet/localization/models/locale_info.dart';

class AppConfig extends JetConfig {
  @override
  List<JetAdapter> get adapters => [
    RouterAdapter(),
    // Add more adapters as needed
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
| `supportedLocales` | `List<LocaleInfo>` | Languages your app supports with display names |
| `defaultLocale` | `Locale?` | Fallback language when device locale isn't supported |
| `theme` | `ThemeData?` | Light mode theme configuration |
| `darkTheme` | `ThemeData?` | Dark mode theme configuration |
| `localizationsDelegates` | `List<LocalizationsDelegate>` | Additional localization delegates for third-party packages |

#### Advanced Configuration Examples

**Multi-language with RTL Support:**
```dart
@override
List<LocaleInfo> get supportedLocales => [
  LocaleInfo(
    locale: const Locale('en', 'US'),
    displayName: 'English (US)',
    nativeName: 'English',
  ),
  LocaleInfo(
    locale: const Locale('ar', 'LY'),
    displayName: 'Arabic (Libya)',
    nativeName: 'العربية',
  ),
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

## 🧭 Using Routing

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

## 🔌 Adapters

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
4. **Ready** → The **Jet framework** is fully configured and ready

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

## 💾 JetStorage

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

## 🎨 Using Theme Switching

Jet Framework provides comprehensive theme management with built-in dark mode, light mode, and system theme support. The theme switcher system includes persistent theme storage, beautiful theme selection interfaces, and seamless integration with Flutter's theme system.

### Theme Switcher Components

The Jet framework includes several components for managing themes:

| Component | Description |
|-----------|-------------|
| `ThemeSwitcherNotifier` | State manager for theme mode with persistent storage |
| `BaseThemeSwitcher` | Abstract base class for creating custom theme switcher widgets |
| `ThemeSwitcher` | Utility class with pre-built theme switcher widgets |
| `SegmentedButtonThemeSwitcher` | Segmented button for theme selection |
| `ToggleButtonSwitcher` | Toggle button for quick theme switching |
| `BottomSheetThemeSwitcher` | Modal bottom sheet for theme selection |

### Basic Usage

#### 1. Simple Theme Toggle Button

Add a theme toggle button to your app bar or anywhere in your UI:

```dart
import 'package:flutter/material.dart';
import 'package:jet/resources/theme/widgets/theme_switcher.dart';

class MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('My App'),
      actions: [
        // Simple theme toggle button
        ThemeSwitcher.toggleButton(context),
        SizedBox(width: 8),
      ],
    );
  }
}
```

#### 2. Segmented Theme Switcher

Use a segmented button to display all theme options:

```dart
import 'package:flutter/material.dart';
import 'package:jet/resources/theme/widgets/theme_switcher.dart';

class ThemeSettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Settings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 12),
            // Segmented theme switcher
            ThemeSwitcher.segmentedButton(context),
          ],
        ),
      ),
    );
  }
}
```

#### 3. Show Theme Switcher Modal

Programmatically show the theme selection modal:

```dart
import 'package:flutter/material.dart';
import 'package:jet/resources/theme/widgets/theme_switcher.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Show theme selection modal
            ThemeSwitcher.show(context);
          },
          child: Text('Change Theme'),
        ),
      ),
    );
  }
}
```

### Custom Theme Switcher using BaseThemeSwitcher

Create your own theme switcher by extending `BaseThemeSwitcher`. This gives you access to the current theme state, notifier for changing themes, and all available theme modes:

```dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/resources/theme/widgets/base_theme_switcher.dart';
import 'package:jet/resources/theme/theme_switcher.dart';

class CustomThemeDropdown extends BaseThemeSwitcher {
  const CustomThemeDropdown({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    ThemeSwitcherNotifier notifier,
    ThemeMode state,
  ) {
    return DropdownButton<ThemeMode>(
      value: state,
      underline: Container(),
      icon: Icon(Icons.keyboard_arrow_down),
      items: ThemeMode.values.map((ThemeMode themeMode) {
        return DropdownMenuItem<ThemeMode>(
          value: themeMode,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_getThemeIcon(themeMode)),
              SizedBox(width: 8),
              Text(_getThemeLabel(themeMode)),
            ],
          ),
        );
      }).toList(),
      onChanged: (ThemeMode? newTheme) {
        if (newTheme != null) {
          notifier.switchTheme(newTheme);
        }
      },
    );
  }

  IconData _getThemeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.auto_mode;
    }
  }

  String _getThemeLabel(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }
}
```

### Advanced Usage with State Management

Since we are using **[Riverpod](https://pub.dev/packages/hooks_riverpod)**, we can increase the level of customization and flexibility by leveraging its providers.

For example, we can use the `themeSwitcherProvider` anywhere in the app to manage and react to theme changes:

```dart
final currentTheme = ref.watch(themeSwitcherProvider);
final themeNotifier = ref.read(themeSwitcherProvider.notifier);
```

This approach allows you to easily access the current theme and control theme switching in a clean and scalable way.

**Watching and Changing Theme with Riverpod:**

```dart
class ThemeManagementWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current theme - widget rebuilds when theme changes
    final currentTheme = ref.watch(themeSwitcherProvider);
    // Get the notifier to change theme
    final themeNotifier = ref.read(themeSwitcherProvider.notifier);
    // Check if current effective theme is dark
    final isDark = ref.watch(isDarkThemeProvider);
    
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display current theme info
            Row(
              children: [
                Icon(
                  isDark ? Icons.dark_mode : Icons.light_mode,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8),
                Text(
                  'Current Theme: ${currentTheme.name.toUpperCase()}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            SizedBox(height: 8),
            
            // Theme status indicator
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark 
                    ? Colors.indigo.withOpacity(0.1)
                    : Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark 
                      ? Colors.indigo.withOpacity(0.3)
                      : Colors.amber.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isDark ? Icons.nights_stay : Icons.wb_sunny,
                    size: 16,
                    color: isDark ? Colors.indigo : Colors.amber,
                  ),
                  SizedBox(width: 8),
                  Text(
                    isDark 
                        ? 'Dark theme is currently active' 
                        : 'Light theme is currently active',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.indigo : Colors.amber.shade700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            
            // Theme switching buttons
            Text(
              'Quick Theme Actions:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 12),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => themeNotifier.setLightTheme(),
                  icon: Icon(Icons.light_mode),
                  label: Text('Light'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentTheme == ThemeMode.light 
                        ? Theme.of(context).colorScheme.primary 
                        : null,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => themeNotifier.setDarkTheme(),
                  icon: Icon(Icons.dark_mode),
                  label: Text('Dark'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentTheme == ThemeMode.dark 
                        ? Theme.of(context).colorScheme.primary 
                        : null,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => themeNotifier.setSystemTheme(),
                  icon: Icon(Icons.auto_mode),
                  label: Text('System'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentTheme == ThemeMode.system 
                        ? Theme.of(context).colorScheme.primary 
                        : null,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => themeNotifier.toggleTheme(),
                  icon: Icon(Icons.swap_horiz),
                  label: Text('Toggle'),
                ),
              ],
            ),
            SizedBox(height: 20),
            
            // Theme-aware content example
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark 
                      ? [Colors.purple.shade900, Colors.blue.shade900]
                      : [Colors.blue.shade100, Colors.purple.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.palette,
                    size: 32,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This content adapts to your theme!',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Complete Integration Example

Here's how to integrate theme switching with your app configuration:

```dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/jet.dart';

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeSwitcherProvider);
    
    return MaterialApp(
      title: 'Jet App',
      themeMode: themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
```

### ThemeSwitcherNotifier Methods

The `ThemeSwitcherNotifier` provides several convenient methods:

| Method | Description |
|--------|-------------|
| `switchTheme(ThemeMode)` | Switch to a specific theme mode |
| `toggleTheme()` | Toggle between light and dark themes |
| `setLightTheme()` | Switch to light theme |
| `setDarkTheme()` | Switch to dark theme |
| `setSystemTheme()` | Switch to system theme |
| `isLight` | Check if current theme is light |
| `isDark` | Check if current theme is dark |
| `isSystem` | Check if current theme is system |

### Key Features

- **Persistent Theme Storage** - Remembers user's theme choice across app restarts
- **BaseThemeSwitcher** - Abstract base class for creating custom theme switchers
- **Built-in UI Components** - Pre-built theme switcher widgets (toggle, segmented, modal)
- **State Management** - Riverpod integration for reactive theme switching
- **System Theme Support** - Automatically follows system dark/light mode preferences
- **Three Theme Modes** - Light, dark, and system theme options
- **Custom Styling** - Full control over UI appearance and behavior
- **Theme Detection** - Utility providers for checking current effective theme

## 🌍 Using Localization

Jet Framework provides comprehensive internationalization (i18n) support with built-in language switching capabilities. The localization system includes persistent locale storage, a beautiful language switcher interface, and seamless integration with Flutter's localization delegates.

### Language Switcher Components

The Jet framework includes several components for managing localization:

| Component | Description |
|-----------|-------------|
| `LanguageSwitcherNotifier` | State manager for locale with persistent storage |
| `LocaleInfo` | Model class containing locale display information (locale, displayName, nativeName) |
| `BaseLanguageSwitcher` | Abstract base class for creating custom language switcher widgets |
| `LanguageSwitcher` | Modal bottom sheet for language selection |
| `LanguageSwitcherButton` | Simple icon button to trigger language switcher |

### Basic Usage

#### 1. Simple Language Switcher Button

Add a language switcher button to your app bar or anywhere in your UI:

```dart
import 'package:flutter/material.dart';
import 'package:jet/localization/widgets/language_switcher.dart';

class MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('My App'),
      actions: [
        // Simple language switcher button
        LanguageSwitcher.toggleButton(),
        SizedBox(width: 8),
      ],
    );
  }
}
```

#### 2. Show Language Switcher Modal

Programmatically show the language selection modal:

```dart
import 'package:flutter/material.dart';
import 'package:jet/localization/widgets/language_switcher.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Show language selection modal
            LanguageSwitcher.show(context);
          },
          child: Text('Change Language'),
        ),
      ),
    );
  }
}
```

#### 3. Embedded Language Switcher

Use the language switcher widget directly in your layout:

```dart
import 'package:flutter/material.dart';
import 'package:jet/localization/widgets/language_switcher.dart';

class LanguageSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Language Settings')),
      body: Column(
        children: [
          // Other settings widgets...
          
          // Embedded language switcher
          const LanguageSwitcher(),
          
          // More settings...
        ],
      ),
    );
  }
}
```

### Custom Language Switcher using BaseLanguageSwitcher

Create your own language switcher by extending `BaseLanguageSwitcher`. This gives you access to the current locale state, notifier for changing locales, and the list of supported locales from your app configuration:

```dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/localization/widgets/base_language_switcher.dart';
import 'package:jet/localization/models/locale_info.dart';
import 'package:jet/localization/notifiers/language_switcher_notifier.dart';

class CustomLanguageDropdown extends BaseLanguageSwitcher {
  const CustomLanguageDropdown({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    Locale state,
    LanguageSwitcherNotifier notifier,
    List<LocaleInfo> supportedLocales,
  ) {
    // Find current locale info
    final currentLocaleInfo = supportedLocales.firstWhere(
      (info) => info.locale.languageCode == state.languageCode,
      orElse: () => supportedLocales.first,
    );
    
    return DropdownButton<LocaleInfo>(
      value: currentLocaleInfo,
      underline: Container(),
      icon: Icon(Icons.keyboard_arrow_down),
      items: supportedLocales.map((LocaleInfo localeInfo) {
        return DropdownMenuItem<LocaleInfo>(
          value: localeInfo,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Center(
                  child: Text(
                    localeInfo.locale.languageCode.toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(localeInfo.displayName),
            ],
          ),
        );
      }).toList(),
      onChanged: (LocaleInfo? newLocaleInfo) {
        if (newLocaleInfo != null) {
          notifier.changeLocale(newLocaleInfo.locale);
        }
      },
    );
  }
}
```

### Advanced Usage with State Management

Since we are using **[Riverpod](https://pub.dev/packages/hooks_riverpod)**, we can increase the level of customization and flexibility by leveraging its providers.

For example, we can use the `languageSwitcherProvider` anywhere in the app to manage and react to language changes:

```dart
final currentLocale = ref.watch(languageSwitcherProvider);
final localeNotifier = ref.read(languageSwitcherProvider.notifier);
```

This approach allows you to easily access the current language and control language switching in a clean and scalable way.


**Watching and Changing Locale with Riverpod:**

```dart
class LocaleManagementWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current locale - widget rebuilds when locale changes
    final currentLocale = ref.watch(languageSwitcherProvider);
    // Get the notifier to change locale
    final localeNotifier = ref.read(languageSwitcherProvider.notifier);
    
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display current language
            Text(
              'Current Language: ${currentLocale.languageCode.toUpperCase()}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            
            // Localized content that updates reactively
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                currentLocale.languageCode == 'ar' 
                    ? 'هذا النص يتغير تلقائياً عند تغيير اللغة' 
                    : 'This text changes automatically when language changes',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            SizedBox(height: 20),
            
            // Language switching buttons
            Text(
              'Switch Language:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 12),
            
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => localeNotifier.changeLocale(Locale('en')),
                  icon: Icon(Icons.language),
                  label: Text('English'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentLocale.languageCode == 'en' 
                        ? Theme.of(context).colorScheme.primary 
                        : null,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => localeNotifier.changeLocale(Locale('ar')),
                  icon: Icon(Icons.language),
                  label: Text('عربي'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentLocale.languageCode == 'ar' 
                        ? Theme.of(context).colorScheme.primary 
                        : null,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            
            // Form with localized validation
            Form(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: currentLocale.languageCode == 'ar' 
                          ? 'الاسم' 
                          : 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return currentLocale.languageCode == 'ar'
                            ? 'يرجى إدخال الاسم'
                            : 'Please enter name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Form submission logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              currentLocale.languageCode == 'ar' 
                                  ? 'تم الإرسال بنجاح!' 
                                  : 'Submitted successfully!',
                            ),
                          ),
                        );
                      },
                      child: Text(
                        currentLocale.languageCode == 'ar' ? 'إرسال' : 'Submit',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### Adding custom Locals 

Complete example of integrating localization with your app configuration:

```dart
import 'package:jet/jet.dart';
import 'package:jet/localization/models/locale_info.dart';

class AppConfig extends JetConfig {
  @override
  List<JetAdapter> get adapters => [
    RouterAdapter(),
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
  Locale? get defaultLocale => const Locale('en');

  @override
  List<LocalizationsDelegate<Object>> get localizationsDelegates => [];
}
```

#### Key Features

- **Persistent Language Storage** - Remembers user's language choice across app restarts
- **BaseLanguageSwitcher** - Abstract base class for creating custom language switchers
- **Built-in UI Components** - Pre-built language switcher modal and button widgets
- **State Management** - Riverpod integration for reactive language switching
- **LocaleInfo Model** - Rich locale information with display names and native names
- **RTL Support** - Automatic text direction detection for RTL languages
- **Flexible Configuration** - Easy integration with app configuration system
- **Custom Styling** - Full control over UI appearance and behavior

## 🌐 Networking

Jet Framework provides a powerful, type-safe HTTP client built on top of **[Dio](https://pub.dev/packages/dio)**, one of Flutter's most popular and robust networking libraries. The networking layer includes automatic error handling, request/response logging, standardized response models, and seamless integration with Jet's error handling system.

**Key Philosophy**: Networking should be simple, consistent, and reliable. Jet provides a clean abstraction over Dio while maintaining full access to its powerful features when needed.

### Core Components

The Jet networking system consists of several key components:

| Component | Description |
|-----------|-------------|
| `JetApiService` | Abstract base class for creating HTTP API clients with built-in configuration |
| `ResponseModel<T>` | Standardized response wrapper with metadata, status, and type-safe data |
| `JetDioLoggerInterceptor` | Enhanced request/response logger with pretty formatting |
| `JetErrorHandler` | Automatic error processing and user-friendly message generation |
| Singleton Pattern | Efficient resource management with automatic instance reuse |

### JetApiService - HTTP Client

`JetApiService` is an abstract base class that provides a comprehensive HTTP client with all common features built-in. It uses the singleton pattern for efficient resource management and provides a clean, type-safe API.

#### Creating an API Service

```dart
import 'package:jet/networking/networking.dart';

class UserApiService extends JetApiService {
  @override
  String get baseUrl => 'https://api.example.com/v1';

  @override
  Map<String, dynamic> get defaultHeaders => {
    ...super.defaultHeaders,
    'Authorization': 'Bearer ${getToken()}',
    'X-App-Version': '1.0.0',
  };

  @override
  Duration get connectTimeout => const Duration(seconds: 30);
  
  @override
  Duration get receiveTimeout => const Duration(seconds: 30);

  // Get singleton instance
  static UserApiService get instance => getInstance(
    'UserApiService',
    () => UserApiService(),
  );

  // API methods
  Future<ResponseModel<List<User>>> getUsers({int page = 1, int limit = 20}) async {
    return await get<List<User>>(
      '/users',
      queryParameters: {'page': page, 'limit': limit},
      decoder: (data) => (data as List).map((json) => User.fromJson(json)).toList(),
    );
  }

  Future<ResponseModel<User>> getUserById(String userId) async {
    return await get<User>(
      '/users/$userId',
      decoder: (data) => User.fromJson(data),
    );
  }

  Future<ResponseModel<User>> createUser(CreateUserRequest request) async {
    return await post<User>(
      '/users',
      data: request.toJson(),
      decoder: (data) => User.fromJson(data),
    );
  }

  Future<ResponseModel<User>> updateUser(String userId, UpdateUserRequest request) async {
    return await put<User>(
      '/users/$userId',
      data: request.toJson(),
      decoder: (data) => User.fromJson(data),
    );
  }

  Future<ResponseModel<void>> deleteUser(String userId) async {
    return await delete<void>('/users/$userId');
  }
}
```

#### Advanced Configuration

```dart
class AdvancedApiService extends JetApiService {
  @override
  String get baseUrl => Environment.apiBaseUrl;

  @override
  List<Interceptor> get interceptors => [
    // Custom auth interceptor
    AuthInterceptor(),
    // Cache interceptor
    CacheInterceptor(),
    // Retry interceptor
    RetryInterceptor(),
  ];

  @override
  HttpClientAdapter? get httpClientAdapter => 
    Environment.useHttp2 ? Http2Adapter() : null;

  @override
  Options? get globalCacheOptions => Options(
    extra: {
      'cache_ttl': Duration(minutes: 5).inMilliseconds,
      'cache_strategy': 'cache_first',
    },
  );
}
```

### ResponseModel - Standardized Responses

`ResponseModel<T>` provides a consistent response structure across all API calls, making it easier to handle success states, errors, and metadata.

#### ResponseModel Structure

```dart
class ResponseModel<T> {
  final T? data;              // The actual response data
  final String? message;      // Response message from server
  final bool success;         // Whether the request was successful
  final int? statusCode;      // HTTP status code
  final Map<String, dynamic>? meta; // Additional metadata (headers, etc.)
}
```

#### Using ResponseModel

```dart
class PostService extends JetApiService {
  @override
  String get baseUrl => 'https://jsonplaceholder.typicode.com';

  static PostService get instance => getInstance('PostService', () => PostService());

  Future<ResponseModel<List<Post>>> getAllPosts() async {
    return await get<List<Post>>(
      '/posts',
      decoder: (data) => (data as List).map((json) => Post.fromJson(json)).toList(),
    );
  }

  Future<List<Post>> getPostsData() async {
    // Use the network helper method for direct data access
    return await network<List<Post>>(
      request: () => getAllPosts(),
      fallback: [], // Fallback value if request fails
      throwOnError: false, // Don't throw, use fallback instead
    );
  }
}

// Usage in your app
class PostsRepository {
  final _postService = PostService.instance;

  Future<List<Post>> fetchPosts() async {
    try {
      final response = await _postService.getAllPosts();
      
      if (response.success && response.data != null) {
        return response.data!;
      } else {
        throw Exception(response.message ?? 'Failed to load posts');
      }
    } catch (error) {
      // Error is automatically processed by Jet's error handling
      rethrow;
    }
  }

  // Or use the simplified network method
  Future<List<Post>> fetchPostsSimple() async {
    return await _postService.getPostsData();
  }
}
```

### HTTP Methods

`JetApiService` provides all standard HTTP methods with consistent APIs and built-in error handling:

#### GET Requests

```dart
// Basic GET
final response = await api.get<List<User>>('/users');

// GET with query parameters
final response = await api.get<List<Post>>(
  '/posts',
  queryParameters: {
    'userId': 1,
    'limit': 10,
    'offset': 0,
  },
);

// GET with custom decoder
final response = await api.get<UserProfile>(
  '/profile',
  decoder: (data) => UserProfile.fromJson(data),
);

// GET with progress tracking
final response = await api.get<LargeDataSet>(
  '/large-dataset',
  onReceiveProgress: (received, total) {
    print('Download progress: ${(received / total * 100).toStringAsFixed(0)}%');
  },
);
```

#### POST Requests

```dart
// Basic POST
final response = await api.post<User>(
  '/users',
  data: {
    'name': 'John Doe',
    'email': 'john@example.com',
  },
);

// POST with custom model
final response = await api.post<User>(
  '/users',
  data: CreateUserRequest(
    name: 'John Doe',
    email: 'john@example.com',
  ).toJson(),
  decoder: (data) => User.fromJson(data),
);

// POST with upload progress
final response = await api.post<UploadResult>(
  '/upload',
  data: formData,
  onSendProgress: (sent, total) {
    print('Upload progress: ${(sent / total * 100).toStringAsFixed(0)}%');
  },
);
```

#### PUT, PATCH, DELETE Requests

```dart
// PUT request (full update)
final response = await api.put<User>(
  '/users/$userId',
  data: updatedUser.toJson(),
  decoder: (data) => User.fromJson(data),
);

// PATCH request (partial update)
final response = await api.patch<User>(
  '/users/$userId',
  data: {'name': 'Updated Name'},
  decoder: (data) => User.fromJson(data),
);

// DELETE request
final response = await api.delete<void>('/users/$userId');

// DELETE with data body
final response = await api.delete<DeleteResult>(
  '/users/bulk',
  data: {'userIds': [1, 2, 3]},
);
```

#### HEAD and OPTIONS Requests

```dart
// HEAD request (check if resource exists)
final response = await api.head('/users/$userId');
print('User exists: ${response.statusCode == 200}');

// OPTIONS request (check available methods)
final response = await api.optionsRequest('/users');
final allowedMethods = response.headers['allow'];
```

### File Operations

Jet provides specialized methods for file uploads and downloads:

#### File Downloads

```dart
class FileService extends JetApiService {
  @override
  String get baseUrl => 'https://api.example.com';

  static FileService get instance => getInstance('FileService', () => FileService());

  Future<void> downloadFile(
    String fileUrl,
    String savePath, {
    Function(int received, int total)? onProgress,
  }) async {
    await download(
      fileUrl,
      savePath,
      onReceiveProgress: onProgress,
      options: Options(
        headers: {'Accept': 'application/octet-stream'},
      ),
    );
  }

  Future<void> downloadImage(String imageId, String savePath) async {
    await download(
      '/images/$imageId/download',
      savePath,
      onReceiveProgress: (received, total) {
        final progress = (received / total * 100).toStringAsFixed(1);
        print('Downloading image: $progress%');
      },
    );
  }
}
```

#### File Uploads

```dart
import 'dart:io';

class UploadService extends JetApiService {
  @override
  String get baseUrl => 'https://api.example.com';

  static UploadService get instance => getInstance('UploadService', () => UploadService());

  Future<ResponseModel<UploadResult>> uploadFile(
    File file, {
    String? description,
    Map<String, String>? metadata,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
      if (description != null) 'description': description,
      if (metadata != null) ...metadata,
    });

    return await upload<UploadResult>(
      '/upload',
      formData,
      decoder: (data) => UploadResult.fromJson(data),
      onSendProgress: (sent, total) {
        final progress = (sent / total * 100).toStringAsFixed(1);
        print('Upload progress: $progress%');
      },
    );
  }

  Future<ResponseModel<List<UploadResult>>> uploadMultipleFiles(
    List<File> files,
  ) async {
    final formData = FormData();
    
    for (int i = 0; i < files.length; i++) {
      formData.files.add(MapEntry(
        'files[$i]',
        await MultipartFile.fromFile(
          files[i].path,
          filename: files[i].path.split('/').last,
        ),
      ));
    }

    return await upload<List<UploadResult>>(
      '/upload/multiple',
      formData,
      decoder: (data) => (data as List)
          .map((json) => UploadResult.fromJson(json))
          .toList(),
    );
  }
}
```

### Error Handling Integration

Jet's networking layer seamlessly integrates with the error handling system to provide consistent error processing:

#### Automatic Error Processing

```dart
class ProductService extends JetApiService {
  @override
  String get baseUrl => 'https://api.shop.com/v1';

  static ProductService get instance => getInstance('ProductService', () => ProductService());

  Future<ResponseModel<List<Product>>> getProducts({
    String? category,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      return await get<List<Product>>(
        '/products',
        queryParameters: {
          if (category != null) 'category': category,
          if (minPrice != null) 'min_price': minPrice,
          if (maxPrice != null) 'max_price': maxPrice,
        },
        decoder: (data) => (data as List)
            .map((json) => Product.fromJson(json))
            .toList(),
      );
    } catch (error) {
      // Error is automatically processed by JetErrorHandler
      // DioException -> JetError with user-friendly messages
      rethrow;
    }
  }
}

// Usage with automatic error handling
class ProductRepository {
  final _productService = ProductService.instance;

  Future<List<Product>> loadProducts() async {
    try {
      final response = await _productService.getProducts();
      return response.data ?? [];
    } on JetError catch (jetError) {
      // Handled error with user-friendly message
      if (jetError.isNoInternet) {
        throw JetError.noInternet(message: 'Please check your internet connection');
      } else if (jetError.isServerError) {
        throw JetError.server(message: 'Our servers are currently unavailable');
      }
      rethrow;
    } catch (error) {
      // Fallback for unexpected errors
      throw JetError.unknown(message: 'Something went wrong loading products');
    }
  }
}
```

### Custom Interceptors

Add custom interceptors to extend functionality:

#### Authentication Interceptor

```dart
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth token to all requests
    final token = AuthStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Token expired, try to refresh
      _handleTokenExpired();
    }
    handler.next(err);
  }

  void _handleTokenExpired() {
    // Implement token refresh logic
  }
}
```

#### Cache Interceptor

```dart
class CacheInterceptor extends Interceptor {
  final Map<String, CachedResponse> _cache = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.method == 'GET') {
      final cacheKey = _generateCacheKey(options);
      final cachedResponse = _cache[cacheKey];
      
      if (cachedResponse != null && !cachedResponse.isExpired) {
        // Return cached response
        handler.resolve(cachedResponse.response);
        return;
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.method == 'GET') {
      final cacheKey = _generateCacheKey(response.requestOptions);
      _cache[cacheKey] = CachedResponse(
        response: response,
        timestamp: DateTime.now(),
        ttl: Duration(minutes: 5),
      );
    }
    handler.next(response);
  }

  String _generateCacheKey(RequestOptions options) {
    return '${options.method}_${options.path}_${options.queryParameters}';
  }
}
```

#### Retry Interceptor

```dart
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final retryCount = err.requestOptions.extra['retry_count'] ?? 0;
    
    if (retryCount < maxRetries && _shouldRetry(err)) {
      err.requestOptions.extra['retry_count'] = retryCount + 1;
      
      Future.delayed(retryDelay, () async {
        try {
          final response = await Dio().fetch(err.requestOptions);
          handler.resolve(response);
        } catch (e) {
          handler.next(err);
        }
      });
    } else {
      handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.sendTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           (err.response?.statusCode ?? 0) >= 500;
  }
}
```

### Request Management

Jet provides utilities for managing requests and cancellation:

#### Request Cancellation

```dart
class SearchService extends JetApiService {
  @override
  String get baseUrl => 'https://api.search.com';

  static SearchService get instance => getInstance('SearchService', () => SearchService());

  CancelToken? _currentSearchToken;

  Future<ResponseModel<SearchResults>> search(String query) async {
    // Cancel previous search
    _currentSearchToken?.cancel('New search started');
    
    // Create new cancel token
    _currentSearchToken = createCancelToken();

    return await get<SearchResults>(
      '/search',
      queryParameters: {'q': query},
      cancelToken: _currentSearchToken,
      decoder: (data) => SearchResults.fromJson(data),
    );
  }

  void cancelSearch() {
    _currentSearchToken?.cancel('Search cancelled by user');
  }
}
```

#### Header Management

```dart
class ApiClient extends JetApiService {
  @override
  String get baseUrl => 'https://api.example.com';

  static ApiClient get instance => getInstance('ApiClient', () => ApiClient());

  void login(String token) {
    // Add auth header for all subsequent requests
    addHeader('Authorization', 'Bearer $token');
  }

  void logout() {
    // Remove auth header
    removeHeader('Authorization');
  }

  void setUserAgent(String userAgent) {
    addHeader('User-Agent', userAgent);
  }

  void setApiVersion(String version) {
    addHeader('X-API-Version', version);
  }

  void updateRequestId() {
    addHeader('X-Request-ID', generateUuid());
  }
}
```

### Authentication Integration

Here's how to integrate authentication with your API service:

#### JWT Authentication Service

```dart
class AuthApiService extends JetApiService {
  @override
  String get baseUrl => 'https://auth.api.com/v1';

  @override
  Map<String, dynamic> get defaultHeaders => {
    ...super.defaultHeaders,
    'X-Client-Version': '1.0.0',
  };

  static AuthApiService get instance => getInstance('AuthApiService', () => AuthApiService());

  Future<ResponseModel<AuthResponse>> login(String email, String password) async {
    return await post<AuthResponse>(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
      decoder: (data) => AuthResponse.fromJson(data),
    );
  }

  Future<ResponseModel<AuthResponse>> refreshToken(String refreshToken) async {
    return await post<AuthResponse>(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
      decoder: (data) => AuthResponse.fromJson(data),
    );
  }

  Future<ResponseModel<void>> logout() async {
    return await post<void>('/auth/logout');
  }

  // Set auth token for future requests
  void setAuthToken(String token) {
    addHeader('Authorization', 'Bearer $token');
  }

  void clearAuth() {
    removeHeader('Authorization');
  }
}

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final User user;
  final int expiresIn;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.expiresIn,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      user: User.fromJson(json['user']),
      expiresIn: json['expires_in'],
    );
  }
}
```

### Complete Examples

#### E-commerce API Service

```dart
class EcommerceApiService extends JetApiService {
  @override
  String get baseUrl => 'https://api.shop.com/v2';

  @override
  Map<String, dynamic> get defaultHeaders => {
    ...super.defaultHeaders,
    'X-Shop-Version': '2.0',
    'Accept-Language': 'en-US',
  };

  @override
  List<Interceptor> get interceptors => [
    AuthInterceptor(),
    CacheInterceptor(),
    RetryInterceptor(maxRetries: 2),
  ];

  static EcommerceApiService get instance => 
    getInstance('EcommerceApiService', () => EcommerceApiService());

  // Products
  Future<ResponseModel<PaginatedResponse<Product>>> getProducts({
    String? category,
    String? searchQuery,
    ProductSortBy? sortBy,
    int page = 1,
    int limit = 20,
  }) async {
    return await get<PaginatedResponse<Product>>(
      '/products',
      queryParameters: {
        if (category != null) 'category': category,
        if (searchQuery != null) 'search': searchQuery,
        if (sortBy != null) 'sort': sortBy.value,
        'page': page,
        'limit': limit,
      },
      decoder: (data) => PaginatedResponse.fromJson(
        data,
        (json) => Product.fromJson(json),
      ),
    );
  }

  Future<ResponseModel<Product>> getProductById(String productId) async {
    return await get<Product>(
      '/products/$productId',
      decoder: (data) => Product.fromJson(data),
    );
  }

  // Cart operations
  Future<ResponseModel<Cart>> getCart() async {
    return await get<Cart>(
      '/cart',
      decoder: (data) => Cart.fromJson(data),
    );
  }

  Future<ResponseModel<Cart>> addToCart(String productId, int quantity) async {
    return await post<Cart>(
      '/cart/items',
      data: {
        'product_id': productId,
        'quantity': quantity,
      },
      decoder: (data) => Cart.fromJson(data),
    );
  }

  Future<ResponseModel<Cart>> updateCartItem(String itemId, int quantity) async {
    return await put<Cart>(
      '/cart/items/$itemId',
      data: {'quantity': quantity},
      decoder: (data) => Cart.fromJson(data),
    );
  }

  Future<ResponseModel<void>> removeFromCart(String itemId) async {
    return await delete<void>('/cart/items/$itemId');
  }

  // Orders
  Future<ResponseModel<Order>> createOrder(CreateOrderRequest request) async {
    return await post<Order>(
      '/orders',
      data: request.toJson(),
      decoder: (data) => Order.fromJson(data),
    );
  }

  Future<ResponseModel<List<Order>>> getOrders({
    OrderStatus? status,
    int page = 1,
    int limit = 10,
  }) async {
    return await get<List<Order>>(
      '/orders',
      queryParameters: {
        if (status != null) 'status': status.value,
        'page': page,
        'limit': limit,
      },
      decoder: (data) => (data['orders'] as List)
          .map((json) => Order.fromJson(json))
          .toList(),
    );
  }

  // Wishlist
  Future<ResponseModel<Wishlist>> getWishlist() async {
    return await get<Wishlist>(
      '/wishlist',
      decoder: (data) => Wishlist.fromJson(data),
    );
  }

  Future<ResponseModel<void>> addToWishlist(String productId) async {
    return await post<void>(
      '/wishlist/items',
      data: {'product_id': productId},
    );
  }

  Future<ResponseModel<void>> removeFromWishlist(String productId) async {
    return await delete<void>('/wishlist/items/$productId');
  }
}
```

#### Social Media API Service

```dart
class SocialApiService extends JetApiService {
  @override
  String get baseUrl => 'https://api.social.com/v1';

  static SocialApiService get instance => 
    getInstance('SocialApiService', () => SocialApiService());

  // Posts
  Future<ResponseModel<List<Post>>> getFeed({
    String? cursor,
    int limit = 20,
  }) async {
    return await get<List<Post>>(
      '/feed',
      queryParameters: {
        if (cursor != null) 'cursor': cursor,
        'limit': limit,
      },
      decoder: (data) => (data['posts'] as List)
          .map((json) => Post.fromJson(json))
          .toList(),
    );
  }

  Future<ResponseModel<Post>> createPost(CreatePostRequest request) async {
    return await post<Post>(
      '/posts',
      data: request.toJson(),
      decoder: (data) => Post.fromJson(data),
    );
  }

  Future<ResponseModel<Post>> likePost(String postId) async {
    return await post<Post>(
      '/posts/$postId/like',
      decoder: (data) => Post.fromJson(data),
    );
  }

  Future<ResponseModel<Post>> unlikePost(String postId) async {
    return await delete<Post>(
      '/posts/$postId/like',
      decoder: (data) => Post.fromJson(data),
    );
  }

  // Media uploads
  Future<ResponseModel<MediaUploadResult>> uploadMedia(
    File file,
    MediaType type,
  ) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
      'type': type.value,
    });

    return await upload<MediaUploadResult>(
      '/media/upload',
      formData,
      decoder: (data) => MediaUploadResult.fromJson(data),
      onSendProgress: (sent, total) {
        final progress = (sent / total * 100).toStringAsFixed(1);
        print('Uploading media: $progress%');
      },
    );
  }

  // User profile
  Future<ResponseModel<UserProfile>> getProfile(String userId) async {
    return await get<UserProfile>(
      '/users/$userId',
      decoder: (data) => UserProfile.fromJson(data),
    );
  }

  Future<ResponseModel<UserProfile>> updateProfile(
    UpdateProfileRequest request,
  ) async {
    return await put<UserProfile>(
      '/profile',
      data: request.toJson(),
      decoder: (data) => UserProfile.fromJson(data),
    );
  }

  // Messaging
  Future<ResponseModel<List<Message>>> getMessages({
    String? conversationId,
    String? cursor,
    int limit = 50,
  }) async {
    return await get<List<Message>>(
      '/messages',
      queryParameters: {
        if (conversationId != null) 'conversation_id': conversationId,
        if (cursor != null) 'cursor': cursor,
        'limit': limit,
      },
      decoder: (data) => (data['messages'] as List)
          .map((json) => Message.fromJson(json))
          .toList(),
    );
  }

  Future<ResponseModel<Message>> sendMessage(SendMessageRequest request) async {
    return await post<Message>(
      '/messages',
      data: request.toJson(),
      decoder: (data) => Message.fromJson(data),
    );
  }
}
```

### Key Features

- **Dio Integration** - Built on top of the powerful and mature Dio HTTP client
- **Singleton Pattern** - Efficient resource management with automatic instance reuse
- **Type-Safe Responses** - Generic `ResponseModel<T>` for type-safe API responses
- **All HTTP Methods** - Complete support for GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS
- **File Operations** - Specialized upload and download methods with progress tracking
- **Error Handling Integration** - Seamless integration with Jet's error handling system
- **Custom Interceptors** - Support for authentication, caching, retry, and custom interceptors
- **Request Management** - Built-in cancellation, header management, and request configuration
- **Response Metadata** - Rich response information including headers, status codes, and timing
- **Progress Tracking** - Upload and download progress callbacks for better UX
- **Automatic Logging** - Beautiful request/response logging with `JetDioLoggerInterceptor`
- **Timeout Configuration** - Customizable connection, send, and receive timeouts
- **HTTP/2 Support** - Optional HTTP/2 client adapter integration
- **Cache Support** - Built-in caching options with customizable TTL and strategies
- **Network Helper** - Simplified `network()` method for direct data access with fallbacks

## ⚠️ Exception Handling

Jet Framework provides a comprehensive error handling system designed to standardize error processing across your entire application. The system automatically categorizes errors, provides user-friendly messages, handles validation errors, and integrates seamlessly with Jet's state management components.

**Key Philosophy**: All errors should be processed through a centralized system that provides consistent, user-friendly messages while preserving technical details for debugging.

### Exception System Overview

The error handling system consists of three main components:

| Component | Description |
|-----------|-------------|
| `JetError` | Standardized error class with comprehensive error information |
| `JetBaseErrorHandler` | Abstract base class for implementing custom error handlers |
| `JetErrorHandler` | Default implementation that handles all common error scenarios |

### Exception Hierarchy

#### JetError Structure

The `JetError` class provides a unified error structure with rich information:

```dart
class JetError {
  final String message;                      // User-friendly error message
  final Map<String, List<String>>? errors;   // Validation errors (field-specific)
  final Object? rawError;                    // Original error object for debugging
  final StackTrace? stackTrace;             // Stack trace for debugging
  final JetErrorType type;                  // Error category
  final int? statusCode;                    // HTTP status code (if applicable)
  final Map<String, dynamic>? metadata;     // Additional error context
}
```

#### JetErrorType Categories

| Type | Description | Examples |
|------|-------------|----------|
| `noInternet` | Network connectivity issues | No internet connection, DNS failures |
| `server` | Server errors (5xx status codes) | Internal server error, service unavailable |
| `client` | Client errors (4xx status codes) | Bad request, unauthorized, not found |
| `validation` | Form validation failures | Invalid email format, required fields |
| `timeout` | Request timeout errors | Connection timeout, receive timeout |
| `cancelled` | Request cancellation | User cancelled request |
| `unknown` | Unhandled/unexpected errors | Unexpected exceptions |

#### JetError Factory Methods

```dart
// Network connectivity error
final noInternetError = JetError.noInternet();

// Server error with details
final serverError = JetError.server(
  message: 'Database connection failed',
  statusCode: 500,
  rawError: originalException,
  stackTrace: stackTrace,
);

// Client error
final clientError = JetError.client(
  message: 'Invalid request format',
  statusCode: 400,
);

// Validation error with field-specific messages
final validationError = JetError.validation(
  message: 'Form validation failed',
  errors: {
    'email': ['Email is required', 'Invalid email format'],
    'password': ['Password must be at least 8 characters'],
  },
);

// Timeout error
final timeoutError = JetError.timeout(
  message: 'Request took too long to complete',
);

// Cancelled request
final cancelledError = JetError.cancelled(
  message: 'User cancelled the operation',
);

// Unknown error
final unknownError = JetError.unknown(
  message: 'An unexpected error occurred',
  rawError: originalException,
);
```

#### JetError Utility Methods

```dart
// Check error type
if (jetError.isValidation) {
  // Handle validation-specific logic
}

if (jetError.isNoInternet) {
  // Show network error UI
}

if (jetError.isServerError) {
  // Log server error and show generic message
}

// Access validation errors
String? firstError = jetError.firstValidationError;
String allErrors = jetError.allValidationErrors;

// Convert to string for display
String displayMessage = jetError.toString();

// Serialize for logging
Map<String, dynamic> errorData = jetError.toMap();
```

### JetResult Pattern

For functions that may fail, use the `JetResult` pattern to handle success and error states elegantly:

```dart
// Function that returns JetResult
Future<JetResult<User, JetError>> login(String email, String password) async {
  try {
    final user = await authService.login(email, password);
    return JetResult.success(user);
  } catch (error, stackTrace) {
    final jetError = errorHandler.handle(error, stackTrace);
    return JetResult.failure(jetError);
  }
}

// Using JetResult
final result = await login('user@example.com', 'password');

result.when(
  success: (user) {
    // Handle successful login
    print('Welcome, ${user.name}!');
  },
  failure: (error) {
    // Handle error
    if (error.isValidation) {
      showValidationErrors(error.errors);
    } else {
      showErrorMessage(error.message);
    }
  },
);

// Or use pattern matching
switch (result) {
  case JetSuccess(data: final user):
    navigateToHome(user);
    break;
  case JetFailure(error: final error):
    handleError(error);
    break;
}
```

### Error Handler Configuration

#### Using the Default Error Handler

The simplest way to use error handling is with the default `JetErrorHandler`:

```dart
import 'package:jet/networking/errors/errors.dart';

class ApiService {
  final errorHandler = JetErrorHandler.instance;

  Future<List<Post>> getPosts() async {
    try {
      final response = await dio.get('/posts');
      return (response.data as List)
          .map((json) => Post.fromJson(json))
          .toList();
    } catch (error, stackTrace) {
      final jetError = errorHandler.handle(error, stackTrace);
      throw jetError; // Or handle as appropriate
    }
  }
}
```

#### Configuring Error Handler in JetConfig

Configure a global error handler in your app configuration:

```dart
import 'package:jet/jet.dart';
import 'package:jet/networking/errors/errors.dart';

class AppConfig extends JetConfig {
  @override
  JetBaseErrorHandler get errorHandler => JetErrorHandler.instance;
  
  // Or use a custom error handler
  @override
  JetBaseErrorHandler get errorHandler => MyCustomErrorHandler();

  @override
  List<JetAdapter> get adapters => [
    RouterAdapter(),
  ];

  // ... other configuration
}
```

### Custom Error Handlers

Create custom error handlers by extending `JetBaseErrorHandler`:

```dart
class MyCustomErrorHandler extends JetBaseErrorHandler {
  @override
  JetError handle(Object error, [StackTrace? stackTrace]) {
    // Add custom logic for specific error types
    if (error.toString().contains('payment_failed')) {
      return JetError.client(
        message: 'Payment could not be processed. Please check your payment method.',
        statusCode: 402,
        rawError: error,
        stackTrace: stackTrace,
      );
    }

    if (error.toString().contains('subscription_expired')) {
      return JetError.client(
        message: 'Your subscription has expired. Please renew to continue.',
        statusCode: 403,
        rawError: error,
        stackTrace: stackTrace,
      );
    }

    // Fall back to default handling
    return super.handle(error, stackTrace);
  }

  @override
  String getErrorMessage(Object error) {
    // Customize error messages
    if (error is DioException && error.response?.statusCode == 429) {
      return 'You\'re doing that too often. Please wait a moment and try again.';
    }

    return super.getErrorMessage(error);
  }

  @override
  bool isNoInternetError(Object error) {
    // Custom no-internet detection
    if (error.toString().toLowerCase().contains('offline')) {
      return true;
    }

    return super.isNoInternetError(error);
  }

  @override
  Map<String, List<String>>? extractValidationErrors(Object error) {
    // Handle custom validation error formats
    if (error is DioException && error.response?.data is Map) {
      final data = error.response!.data as Map<String, dynamic>;
      
      // Handle custom API validation format
      if (data.containsKey('field_errors')) {
        final fieldErrors = data['field_errors'] as Map<String, dynamic>;
        final result = <String, List<String>>{};
        
        fieldErrors.forEach((key, value) {
          if (value is String) {
            result[key] = [value];
          } else if (value is List) {
            result[key] = value.map((e) => e.toString()).toList();
          }
        });
        
        return result.isNotEmpty ? result : null;
      }
    }

    return super.extractValidationErrors(error);
  }
}
```

### Framework Integration

#### Automatic Integration with JetBuilder

`JetBuilder` automatically uses the configured error handler:

```dart
class PostsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetBuilder.list<Post>(
      provider: postsProvider,
      itemBuilder: (post, index) => PostCard(post: post),
      // Error handling is automatic!
      // The framework processes errors through the configured error handler
    );
  }
}

// The provider can throw any type of error
final postsProvider = AutoDisposeFutureProvider<List<Post>>((ref) async {
  try {
    final api = ref.read(apiServiceProvider);
    return await api.getAllPosts();
  } catch (error, stackTrace) {
    // This will be automatically processed by the error handler
    rethrow;
  }
});
```

#### Custom Error Widgets with JetBuilder

Override the default error widget while still using the error handler:

```dart
class PostsListWithCustomError extends JetConsumerWidget {
  @override
  Widget jetBuild(BuildContext context, WidgetRef ref, Jet jet) {
    return JetBuilder.list<Post>(
      provider: postsProvider,
      itemBuilder: (post, index) => PostCard(post: post),
      error: (error, stackTrace) {
        // Process the error through the configured handler
        final jetError = jet.config.errorHandler.handle(error, stackTrace);
        
        return CustomErrorWidget(
          title: _getErrorTitle(jetError),
          message: jetError.message,
          icon: _getErrorIcon(jetError),
          onRetry: () => ref.refresh(postsProvider),
          showDetails: jetError.type == JetErrorType.unknown,
          details: jetError.rawError?.toString(),
        );
      },
    );
  }

  String _getErrorTitle(JetError error) {
    switch (error.type) {
      case JetErrorType.noInternet:
        return 'No Internet Connection';
      case JetErrorType.server:
        return 'Server Error';
      case JetErrorType.client:
        return 'Request Error';
      case JetErrorType.validation:
        return 'Validation Error';
      case JetErrorType.timeout:
        return 'Request Timeout';
      case JetErrorType.cancelled:
        return 'Request Cancelled';
      default:
        return 'Something Went Wrong';
    }
  }

  IconData _getErrorIcon(JetError error) {
    switch (error.type) {
      case JetErrorType.noInternet:
        return Icons.wifi_off;
      case JetErrorType.server:
        return Icons.error;
      case JetErrorType.client:
        return Icons.warning;
      case JetErrorType.validation:
        return Icons.info;
      case JetErrorType.timeout:
        return Icons.access_time;
      case JetErrorType.cancelled:
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }
}
```

#### Integration with JetPaginator

`JetPaginator` automatically handles errors during pagination:

```dart
class ProductsPagination extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetPaginator.list<Product, Map<String, dynamic>>(
      fetchPage: (pageKey) async {
        // Any errors thrown here will be processed by the error handler
        final response = await api.getProducts(skip: pageKey, limit: 20);
        return response;
      },
      parseResponse: (response, pageKey) => PageInfo(
        items: (response['products'] as List)
            .map((json) => Product.fromJson(json))
            .toList(),
        nextPageKey: response['skip'] + response['limit'] < response['total']
            ? response['skip'] + response['limit']
            : null,
      ),
      itemBuilder: (product, index) => ProductCard(product: product),
      
      // Custom error handling for pagination
      errorBuilder: (context, error, retryCallback) {
        final jetError = context.jet.config.errorHandler.handle(error);
        
        return PaginationErrorWidget(
          message: jetError.message,
          isNoInternet: jetError.isNoInternet,
          onRetry: retryCallback,
        );
      },
    );
  }
}
```

### Migration Guide

#### From Manual Error Handling

**Before:**
```dart
// Manual error handling
Future<List<Post>> getPosts() async {
  try {
    final response = await dio.get('/posts');
    return parsePostsResponse(response.data);
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception('Connection timeout');
    } else if (e.response?.statusCode == 500) {
      throw Exception('Server error');
    } else {
      throw Exception('Something went wrong');
    }
  } catch (e) {
    throw Exception('Unexpected error: $e');
  }
}
```

**After:**
```dart
// Using Jet Error Handler
Future<List<Post>> getPosts() async {
  try {
    final response = await dio.get('/posts');
    return parsePostsResponse(response.data);
  } catch (error, stackTrace) {
    final jetError = JetErrorHandler.instance.handle(error, stackTrace);
    throw jetError;
  }
}
```

#### From Custom Error Classes

**Before:**
```dart
// Multiple custom error classes
class NetworkError extends Error {
  final String message;
  NetworkError(this.message);
}

class ValidationError extends Error {
  final Map<String, String> errors;
  ValidationError(this.errors);
}

class ServerError extends Error {
  final int statusCode;
  ServerError(this.statusCode);
}
```

**After:**
```dart
// Single JetError class with type differentiation
final networkError = JetError.noInternet();
final validationError = JetError.validation(errors: validationMap);
final serverError = JetError.server(statusCode: 500);
```

### Exception Handling Examples

#### Basic API Service with Error Handling

```dart
class UserService {
  final Dio _dio;
  final JetBaseErrorHandler _errorHandler;

  UserService(this._dio, this._errorHandler);

  Future<User> getUser(String userId) async {
    try {
      final response = await _dio.get('/users/$userId');
      return User.fromJson(response.data);
    } catch (error, stackTrace) {
      final jetError = _errorHandler.handle(error, stackTrace);
      throw jetError;
    }
  }

  Future<User> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/users/$userId', data: data);
      return User.fromJson(response.data);
    } catch (error, stackTrace) {
      final jetError = _errorHandler.handle(error, stackTrace);
      
      // Handle validation errors specifically
      if (jetError.isValidation) {
        print('Validation errors: ${jetError.allValidationErrors}');
      }
      
      throw jetError;
    }
  }
}
```

#### Form Validation with Error Display

```dart
class UserForm extends JetConsumerWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget jetBuild(BuildContext context, WidgetRef ref, Jet jet) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) => _validateField('email', value, ref),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            validator: (value) => _validateField('password', value, ref),
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: () => _submitForm(context, ref, jet),
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  String? _validateField(String field, String? value, WidgetRef ref) {
    final validationState = ref.watch(formValidationProvider);
    return validationState.when(
      data: (errors) => errors?[field]?.first,
      loading: () => null,
      error: (error, _) {
        if (error is JetError && error.isValidation) {
          return error.errors?[field]?.first;
        }
        return null;
      },
    );
  }

  Future<void> _submitForm(BuildContext context, WidgetRef ref, Jet jet) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(userServiceProvider).createUser({
        'email': emailController.text,
        'password': passwordController.text,
      });
      
      // Success handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User created successfully!')),
      );
    } catch (error) {
      if (error is JetError && error.isValidation) {
        // Trigger form validation state update
        ref.read(formValidationProvider.notifier).setErrors(error.errors);
        _formKey.currentState!.validate();
      } else {
        // Show general error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
```

#### Comprehensive Error Handling in Repository

```dart
class PostRepository {
  final ApiClient _apiClient;
  final JetBaseErrorHandler _errorHandler;

  PostRepository(this._apiClient, this._errorHandler);

  Future<List<Post>> getPosts({int page = 1, int limit = 20}) async {
    try {
      final response = await _apiClient.get('/posts', queryParameters: {
        'page': page,
        'limit': limit,
      });

      return (response.data['data'] as List)
          .map((json) => Post.fromJson(json))
          .toList();
    } catch (error, stackTrace) {
      final jetError = _errorHandler.handle(error, stackTrace);
      
      // Log error for analytics/monitoring
      _logError('getPosts', jetError);
      
      throw jetError;
    }
  }

  Future<Post> createPost(CreatePostRequest request) async {
    try {
      final response = await _apiClient.post('/posts', data: request.toJson());
      return Post.fromJson(response.data);
    } catch (error, stackTrace) {
      final jetError = _errorHandler.handle(error, stackTrace);
      
      // Handle specific error types
      if (jetError.isValidation) {
        _logValidationError('createPost', jetError.errors);
      } else if (jetError.isNoInternet) {
        _showOfflineMessage();
      }
      
      throw jetError;
    }
  }

  void _logError(String operation, JetError error) {
    // Log to your preferred logging/analytics service
    logger.error('$operation failed', extra: {
      'error_type': error.type.name,
      'message': error.message,
      'status_code': error.statusCode,
      'metadata': error.metadata,
    });
  }

  void _logValidationError(String operation, Map<String, List<String>>? errors) {
    if (errors == null) return;
    
    logger.warning('$operation validation failed', extra: {
      'validation_errors': errors,
    });
  }

  void _showOfflineMessage() {
    // Show offline indicator or cache data
  }
}
```

### Key Features

- **Comprehensive Error Categorization** - Automatic classification of errors into meaningful types
- **User-Friendly Messages** - Automatic conversion of technical errors to user-friendly messages
- **Validation Error Support** - Built-in handling of form validation errors with field-specific messages
- **Dio Integration** - Full support for all Dio exception types and HTTP status codes
- **Network Detection** - Intelligent detection of network connectivity issues
- **Extensible Architecture** - Easy to create custom error handlers for specific requirements
- **Framework Integration** - Seamless integration with JetBuilder, JetPaginator, and other Jet components
- **Rich Error Information** - Preserves technical details while providing clean user messages
- **Debugging Support** - Includes stack traces, raw errors, and metadata for development
- **Consistent API** - Unified error handling approach across the entire application

## 📝 Forms

Jet Framework provides a powerful, type-safe form management system built on top of **[Flutter Form Builder](https://pub.dev/packages/flutter_form_builder)** with seamless integration with Riverpod state management. The forms system includes automatic error handling, validation, field invalidation, and specialized input components for common use cases.

**Key Philosophy**: Forms should be simple to create, type-safe, and handle all common scenarios (loading, validation errors, success states) with minimal boilerplate while providing maximum flexibility for customization.

### Core Components

The Jet forms system consists of several key components that work together:

| Component | Description |
|-----------|-------------|
| `AsyncFormValue<Request, Response>` | Type-safe form state management inspired by Riverpod's AsyncValue |
| `JetFormNotifier<Request, Response>` | Abstract form controller with built-in error handling and validation |
| `JetFormBuilder<Request, Response>` | Main widget for building forms with automatic state management |
| `FormBuilderPasswordField` | Enhanced password field with visibility toggle |
| `FormBuilderPhoneNumberField` | Phone number field with built-in validation |
| `JetOtpField` | Custom OTP field built from scratch with individual input boxes |

### AsyncFormValue - Form State Management

`AsyncFormValue` provides type-safe state management for forms, handling the complete form lifecycle from initial state to success or error states.

#### AsyncFormValue States

| State | Description | Use Case |
|-------|-------------|----------|
| `AsyncFormData<Request, Response>` | Form has completed successfully with request and response data | Show success message, redirect, or update UI |
| `AsyncFormError<Request, Response>` | Form submission failed with error details | Display errors, highlight invalid fields |
| `AsyncFormLoading<Request, Response>` | Form is currently submitting | Show loading spinner, disable submit button |

#### AsyncFormValue API

```dart
// Creating form states
final loadingState = AsyncFormValue<LoginRequest, User>.loading();
final successState = AsyncFormValue<LoginRequest, User>.data(
  request: loginRequest,
  response: user,
);
final errorState = AsyncFormValue<LoginRequest, User>.error(
  error,
  stackTrace,
  request: loginRequest, // Optional: preserve request data
);

// Checking state
bool isSubmitting = formState.isLoading;
bool hasData = formState.hasValue;
bool hasError = formState.hasError;

// Pattern matching
formState.map(
  data: (data) => print('Success: ${data.response.name}'),
  error: (error) => print('Error: ${error.error}'),
  loading: (loading) => print('Submitting...'),
);
```

### JetFormNotifier - Form Controller

`JetFormNotifier` is an abstract class that provides the foundation for form controllers. It handles form submission, validation, error processing, and field invalidation automatically.

#### Creating a Form Controller

```dart
class LoginFormNotifier extends JetFormNotifier<LoginRequest, User> {
  LoginFormNotifier(super.ref);

  @override
  LoginRequest decoder(Map<String, dynamic> formData) {
    return LoginRequest(
      email: formData['email'] as String,
      password: formData['password'] as String,
      rememberMe: formData['remember_me'] as bool? ?? false,
    );
  }

  @override
  Future<User> action(LoginRequest data) async {
    final authService = ref.read(authServiceProvider);
    return await authService.login(data.email, data.password);
  }
}

// Provider definition
final loginFormProvider = AutoDisposeStateNotifierProvider<
  LoginFormNotifier,
  AsyncFormValue<LoginRequest, User>
>((ref) => LoginFormNotifier(ref));
```

#### Form Controller Methods

| Method | Description |
|--------|-------------|
| `submit()` | Validates and submits the form with automatic error handling |
| `reset()` | Resets the form to initial state |
| `invalidateFields()` | Invalidates specific form fields with error messages |
| `invalidateFieldsFromJetError()` | Automatically invalidates fields from JetError validation errors |
| `decoder()` | **Abstract** - Convert form data to request object |
| `action()` | **Abstract** - Perform form submission with request data |

### JetFormBuilder - Form Widget

`JetFormBuilder` is the main widget for creating forms. It automatically handles state management, error display, field validation, and success callbacks.

#### Basic Form Example

```dart
class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetFormBuilder<LoginRequest, User>(
      provider: loginFormProvider,
      onSuccess: (user, request) {
        // Handle successful login
        context.router.pushNamed('/dashboard');
        context.showToast('Welcome back, ${user.name}!');
      },
      builder: (context, ref, form, formState) => [
        // Email field
        FormBuilderTextField(
          name: 'email',
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
          ),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.email(),
          ]),
        ),
        
        // Password field with enhanced component
        FormBuilderPasswordField(
          name: 'password',
          hintText: 'Enter your password',
          isRequired: true,
        ),
        
        // Remember me checkbox
        FormBuilderCheckbox(
          name: 'remember_me',
          title: Text('Remember me'),
          initialValue: false,
        ),
        
        // Submit button shows loading state automatically
        if (formState.isLoading)
          CircularProgressIndicator()
        else
          JetButton(
            text: 'Sign In',
            onTap: form.submit,
          ),
      ],
    );
  }
}
```

#### JetFormBuilder Configuration

| Property | Type | Description |
|----------|------|-------------|
| `provider` | `JetFormProvider<Request, Response>` | The form state provider |
| `builder` | `Function` | Builder function that returns list of form widgets |
| `onSuccess` | `Function?` | Callback when form submission succeeds |
| `onError` | `Function?` | Custom error handling callback |
| `initialValues` | `Map<String, dynamic>` | Initial form field values |
| `useDefaultErrorHandler` | `bool` | Whether to use Jet's error handler (default: true) |
| `showErrorSnackBar` | `bool` | Show error messages as toast (default: true) |
| `submitButtonText` | `String` | Text for default submit button |
| `showDefaultSubmitButton` | `bool` | Whether to show default submit button |
| `fieldSpacing` | `double` | Spacing between form fields |

### Form Input Components

Jet provides specialized input components that integrate seamlessly with the form system:

#### FormBuilderPasswordField

Enhanced password field with visibility toggle and validation:

```dart
FormBuilderPasswordField(
  name: 'password',
  hintText: 'Enter your password',
  isRequired: true,
  showPrefixIcon: true,
  validator: FormBuilderValidators.compose([
    FormBuilderValidators.required(),
    FormBuilderValidators.minLength(8),
  ]),
  
  // Password confirmation
  identicalWith: 'confirm_password', // Must match another field
  formKey: formKey, // Required when using identicalWith
),

FormBuilderPasswordField(
  name: 'confirm_password',
  hintText: 'Confirm your password',
  isRequired: true,
  identicalWith: 'password',
  formKey: formKey,
),
```

#### FormBuilderPhoneNumberField  

Phone number field with built-in validation:

```dart
FormBuilderPhoneNumberField(
  name: 'phone',
  hintText: 'Enter phone number',
  isRequired: true,
  showPrefixIcon: true,
  validator: FormBuilderValidators.compose([
    FormBuilderValidators.required(),
    FormBuilderValidators.minLength(10),
    FormBuilderValidators.maxLength(15),
    FormBuilderValidators.numeric(),
  ]),
),
```

#### JetOtpField

Custom OTP field built from scratch with individual input boxes and smart theme integration:

```dart
JetOtpField(
  name: 'verification_code',
  length: 6,
  onCompleted: (otp) {
    // Auto-submit when OTP is complete
    form.submit();
  },
  onChanged: (value) {
    print('Current OTP: $value');
  },
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the verification code';
    }
    if (value.length < 6) {
      return 'Please enter all 6 digits';
    }
    return null;
  },
  
  // Customizable appearance
  fieldWidth: 56.0,
  fieldHeight: 56.0,
  borderRadius: 12.0,
  
  // Uses app's theme borders by default
  // Override only when needed
  focusedBorderColor: Colors.blue,
  errorBorderColor: Colors.red,
  
  // Advanced features
  obscureText: false,
  obscuringCharacter: '•',
  autofocus: true,
  keyboardType: TextInputType.number,
),
```

**JetOtpField Key Features:**
- **Built from scratch** - No external OTP library dependencies
- **Individual input boxes** - Each digit has its own styled field
- **Smart focus management** - Auto-advance on input, backspace navigation
- **Paste support** - Tap or long press to paste complete OTP codes
- **Theme integration** - Uses app's default InputDecorationTheme borders
- **Smart field distribution** - Automatic spacing using MainAxisAlignment
- **Responsive design** - LayoutBuilder ensures proper display on all screen sizes
- **Form Builder compatible** - Full integration with validation and state management
- **Customizable styling** - Override theme properties only when needed
- **Accessibility ready** - Proper keyboard navigation and screen reader support

### Form Examples

#### Registration Form with Validation

```dart
class RegistrationFormNotifier extends JetFormNotifier<RegistrationRequest, User> {
  RegistrationFormNotifier(super.ref);

  @override
  RegistrationRequest decoder(Map<String, dynamic> formData) {
    return RegistrationRequest(
      name: formData['name'] as String,
      email: formData['email'] as String,
      password: formData['password'] as String,
      phone: formData['phone'] as String,
      agreeToTerms: formData['agree_terms'] as bool,
    );
  }

  @override
  Future<User> action(RegistrationRequest data) async {
    final authService = ref.read(authServiceProvider);
    return await authService.register(data);
  }
}

class RegistrationForm extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return JetFormBuilder<RegistrationRequest, User>(
      provider: registrationFormProvider,
      initialValues: {
        'agree_terms': false,
      },
      onSuccess: (user, request) {
        context.router.pushNamed('/verify-email');
        context.showToast('Account created! Please verify your email.');
      },
      onError: (error, stackTrace, invalidateFields) {
        // Custom error handling
        if (error is JetError && error.statusCode == 409) {
          context.showToast('Email already exists. Please try signing in.');
        }
      },
      builder: (context, ref, form, formState) => [
        // Name field
        FormBuilderTextField(
          name: 'name',
          decoration: InputDecoration(
            labelText: 'Full Name',
            prefixIcon: Icon(Icons.person),
          ),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(2),
          ]),
        ),
        
        // Email field
        FormBuilderTextField(
          name: 'email',
          decoration: InputDecoration(
            labelText: 'Email Address',
            prefixIcon: Icon(Icons.email),
          ),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.email(),
          ]),
        ),
        
        // Phone field
        FormBuilderPhoneNumberField(
          name: 'phone',
          hintText: 'Phone Number',
          isRequired: true,
        ),
        
        // Password field
        FormBuilderPasswordField(
          name: 'password',
          hintText: 'Password',
          formKey: _formKey,
        ),
        
        // Confirm password
        FormBuilderPasswordField(
          name: 'confirm_password',
          hintText: 'Confirm Password',
          identicalWith: 'password',
          formKey: _formKey,
        ),
        
        // Terms checkbox
        FormBuilderCheckbox(
          name: 'agree_terms',
          title: Text('I agree to the Terms of Service and Privacy Policy'),
          validator: FormBuilderValidators.equal(
            true,
            errorText: 'You must agree to the terms',
          ),
        ),
        
        // Submit button with loading state
        SizedBox(
          width: double.infinity,
          child: formState.isLoading
              ? Center(child: CircularProgressIndicator())
              : JetButton(
                  text: 'Create Account',
                  onTap: form.submit,
                ),
        ),
      ],
    );
  }
}
```

#### OTP Verification Form

```dart
class OTPFormNotifier extends JetFormNotifier<OTPRequest, VerificationResponse> {
  OTPFormNotifier(super.ref);

  @override
  OTPRequest decoder(Map<String, dynamic> formData) {
    return OTPRequest(
      code: formData['otp_code'] as String,
      email: formData['email'] as String,
    );
  }

  @override
  Future<VerificationResponse> action(OTPRequest data) async {
    final authService = ref.read(authServiceProvider);
    return await authService.verifyOTP(data.email, data.code);
  }
}

class OTPForm extends StatelessWidget {
  final String email;
  
  const OTPForm({required this.email});

  @override
  Widget build(BuildContext context) {
    return JetFormBuilder<OTPRequest, VerificationResponse>(
      provider: otpFormProvider,
      initialValues: {
        'email': email,
      },
      onSuccess: (response, request) {
        context.router.pushNamed('/dashboard');
        context.showToast('Email verified successfully!');
      },
      showDefaultSubmitButton: false,
      builder: (context, ref, form, formState) => [
        // Hidden email field
        FormBuilderTextField(
          name: 'email',
          decoration: InputDecoration.collapsed(hintText: ''),
          style: TextStyle(height: 0, color: Colors.transparent),
          enabled: false,
        ),
        
        Text(
          'Enter the verification code sent to $email',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        
        // OTP input field
        JetOtpField(
          name: 'otp_code',
          length: 6,
          autofocus: true,
          onCompleted: (otp) {
            // Auto-submit when complete
            form.submit();
          },
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.exactLength(6),
            FormBuilderValidators.numeric(),
          ]),
        ),
        
        if (formState.isLoading) ...[
          SizedBox(height: 20),
          Center(child: CircularProgressIndicator()),
          Text(
            'Verifying code...',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
        
        SizedBox(height: 20),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => form.reset(),
              child: Text('Clear'),
            ),
            TextButton(
              onPressed: formState.isLoading ? null : _resendCode,
              child: Text('Resend Code'),
            ),
          ],
        ),
      ],
    );
  }
  
  void _resendCode() {
    // Resend code logic
  }
}
```

### Error Handling in Forms

Jet forms integrate seamlessly with the framework's error handling system to provide comprehensive error management:

#### Automatic Error Processing

```dart
class ContactFormNotifier extends JetFormNotifier<ContactRequest, ContactResponse> {
  ContactFormNotifier(super.ref);

  @override
  Future<ContactResponse> action(ContactRequest data) async {
    try {
      final response = await api.submitContact(data);
      return response;
    } catch (error, stackTrace) {
      // Error is automatically processed by JetFormNotifier
      // using the configured JetErrorHandler
      rethrow;
    }
  }
  
  // ... decoder implementation
}
```

#### Field-Level Error Handling

The form system automatically handles field-level validation errors:

```dart
// When the API returns validation errors in this format:
// {
//   "message": "Validation failed",
//   "errors": {
//     "email": ["Email is required", "Invalid email format"],
//     "password": ["Password must be at least 8 characters"]
//   }
// }

// JetFormBuilder automatically:
// 1. Processes the error through JetErrorHandler
// 2. Extracts field-level validation errors
// 3. Invalidates specific form fields
// 4. Displays field errors under respective inputs
// 5. Shows general error message as toast
```

#### Custom Error Handling

```dart
JetFormBuilder<LoginRequest, User>(
  provider: loginFormProvider,
  useDefaultErrorHandler: false, // Disable automatic error processing
  onError: (error, stackTrace, invalidateFields) {
    // Handle specific error scenarios
    if (error.toString().contains('invalid_credentials')) {
      invalidateFields({
        'email': ['Invalid email or password'],
        'password': ['Invalid email or password'],
      });
      context.showToast('Please check your credentials');
    } else if (error.toString().contains('account_locked')) {
      context.router.pushNamed('/account-locked');
    } else {
      // Fall back to default error display
      context.showToast('Something went wrong. Please try again.');
    }
  },
  builder: (context, ref, form, formState) => [
    // Form fields...
  ],
)
```

#### Error State Management

```dart
class MyFormWidget extends JetConsumerWidget {
  @override
  Widget jetBuild(BuildContext context, WidgetRef ref, Jet jet) {
    final formState = ref.watch(myFormProvider);
    
    return Column(
      children: [
        // Show global error message
        if (formState.hasError)
          Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(8),
            ),
            child: formState.map(
              data: (_) => SizedBox.shrink(),
              loading: (_) => SizedBox.shrink(),
              error: (error) => Text(
                error.error.toString(),
                style: TextStyle(color: Colors.red[700]),
              ),
            ),
          ),
        
        // Form content
        JetFormBuilder<MyRequest, MyResponse>(
          provider: myFormProvider,
          builder: (context, ref, form, state) => [
            // Form fields...
          ],
        ),
      ],
    );
  }
}
```

### Key Features

- **Type-Safe Forms** - Full type safety with Request/Response generic types
- **AsyncFormValue State Management** - Inspired by Riverpod's AsyncValue for predictable form states  
- **Automatic Error Handling** - Built-in integration with Jet's error handling system
- **Field-Level Validation** - Automatic field invalidation with server-side validation errors
- **Form Builder Integration** - Built on top of Flutter Form Builder for maximum compatibility
- **Specialized Input Components** - Enhanced password, phone, PIN, and custom OTP input fields
- **Custom OTP Field** - JetOtpField built from scratch with individual input boxes and theme integration
- **Loading State Management** - Automatic loading states with customizable indicators
- **Success/Error Callbacks** - Flexible callback system for handling form results
- **Form Reset/Clear** - Built-in form reset and field clearing functionality
- **Riverpod Integration** - Seamless state management with Riverpod providers
- **Theme-Aware Components** - Input fields automatically adapt to app theme
- **Responsive Design** - Forms and input fields adapt to different screen sizes
- **Customizable UI** - Full control over form layout, spacing, and styling
- **Automatic Field Focus** - Smart focus management for better user experience
- **Toast Integration** - Built-in toast notifications for errors and success states

## 🔄 State Management

Jet Framework provides powerful, unified state management built on top of **[Riverpod](https://pub.dev/packages/hooks_riverpod)**, one of Flutter's most robust state management solutions. Jet enhances Riverpod with specialized widgets that eliminate boilerplate and provide common patterns like pull-to-refresh, error handling, and pagination out of the box.

**Key Philosophy**: Jet's state management is designed around **simplicity and power**. Instead of multiple specialized widgets, we provide a unified `JetBuilder` API that handles all common use cases with minimal code.

### Core Components

| Component | Description |
|-----------|-------------|
| `JetBuilder` | Unified widget for lists, grids, and single items with pull-to-refresh |
| `JetPaginator` | Infinite scroll pagination built on official `infinite_scroll_pagination` package |
| `JetConsumer` / `JetConsumerWidget` | Enhanced consumer widgets with Jet framework access |
| `PaginationResponse` | Flexible pagination models for different API formats |
| `PageInfo` | Simple pagination information used by JetPaginator |
| Extensions | Utility extensions for easier provider management |

### JetBuilder - Unified State Management

`JetBuilder` is the core of Jet's state management system. It provides a simple, consistent API for the most common UI patterns while handling pull-to-refresh, loading states, and error handling automatically.

#### JetBuilder Methods

| Method | Description |
|--------|-------------|
| `list()` | Creates a refreshable list widget |
| `familyList()` | Creates a refreshable list widget with family provider support |
| `grid()` | Creates a refreshable grid widget |
| `familyGrid()` | Creates a refreshable grid widget with family provider support |
| `item()` | Creates a refreshable single item widget |
| `familyItem()` | Creates a refreshable single item widget with family provider support |
| `builder()` | Creates a refreshable widget with custom builder |
| `familyBuilder()` | Creates a refreshable widget with custom builder and family support |

#### Basic List Example

```dart
class PostsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetBuilder.list<Post>(
      provider: postsProvider,
      itemBuilder: (post, index) => ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(post.author.avatarUrl),
        ),
        title: Text(post.title),
        subtitle: Text(post.excerpt),
        trailing: Text(post.publishDate),
        onTap: () => context.router.pushNamed('/post/${post.id}'),
      ),
      padding: EdgeInsets.all(16),
      loading: Center(child: CircularProgressIndicator()),
      
      // Built-in error handling with smart retry buttons
      // Includes loading states, error categorization, and automatic retry
      error: (error, stackTrace) => ErrorMessage(error: error), // Optional custom error widget
    );
  }
}

// Provider definition
final postsProvider = AutoDisposeFutureProvider<List<Post>>((ref) async {
  final api = ref.read(apiServiceProvider);
  return await api.getAllPosts();
});
```

#### Grid Layout Example

```dart
class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetBuilder.grid<Product>(
      provider: productsProvider,
      crossAxisCount: 2,
      itemBuilder: (product, index) => ProductCard(
        product: product,
        onAddToCart: () => _addToCart(product),
        onFavorite: () => _toggleFavorite(product.id),
      ),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.75,
      padding: EdgeInsets.all(16),
    );
  }
  
  void _addToCart(Product product) {
    // Add to cart logic
  }
  
  void _toggleFavorite(String productId) {
    // Toggle favorite logic
  }
}
```

#### Single Item Example

```dart
class UserProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetBuilder.item<UserProfile>(
      provider: currentUserProfileProvider,
      builder: (profile, ref) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(profile.avatarUrl),
          ),
          SizedBox(height: 20),
          Text(
            profile.displayName,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            profile.email,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),
          ProfileStatsRow(profile: profile),
          SizedBox(height: 32),
          ProfileActionButtons(profile: profile),
        ],
      ),
      padding: EdgeInsets.all(20),
    );
  }
}
```

#### Custom Builder Example

```dart
class CustomDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetBuilder.builder<DashboardData>(
      provider: dashboardDataProvider,
      builder: (data, ref) => Column(
        children: [
          StatsCard(stats: data.stats),
          ChartWidget(chartData: data.chartData),
          RecentActivityList(activities: data.recentActivities),
        ],
      ),
      loading: Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => ErrorPage(error: error),
    );
  }
}
```

### Family Provider Support

For providers that take parameters, use the `family` variants:

#### Family List Example

```dart
class CategoryPostsList extends StatelessWidget {
  final String categoryId;
  
  const CategoryPostsList({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return JetBuilder.familyList<Post, String>(
      provider: postsByCategoryProvider,
      param: categoryId,
      itemBuilder: (post, index) => PostCard(
        post: post,
        onLike: () => _toggleLike(post.id),
        onShare: () => _sharePost(post),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
  
  void _toggleLike(String postId) {
    // Handle like logic
  }
  
  void _sharePost(Post post) {
    // Handle share logic
  }
}

final postsByCategoryProvider = AutoDisposeFutureProvider.family<List<Post>, String>((ref, categoryId) async {
  final api = ref.read(apiServiceProvider);
  return await api.getPostsByCategory(categoryId);
});
```

#### Family Grid Example

```dart
class FilteredProductsGrid extends StatelessWidget {
  final ProductFilter filter;
  
  const FilteredProductsGrid({required this.filter});

  @override
  Widget build(BuildContext context) {
    return JetBuilder.familyGrid<Product, ProductFilter>(
      provider: filteredProductsProvider,
      param: filter,
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
      itemBuilder: (product, index) => ProductCard(
        product: product,
        showDiscount: filter.showDiscountsOnly,
        onQuickView: () => _showQuickView(context, product),
      ),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.8,
      padding: EdgeInsets.all(20),
    );
  }
  
  void _showQuickView(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => ProductQuickViewDialog(product: product),
    );
  }
}

class ProductFilter {
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final bool showDiscountsOnly;
  
  const ProductFilter({
    this.category,
    this.minPrice,
    this.maxPrice,
    this.showDiscountsOnly = false,
  });
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductFilter &&
          category == other.category &&
          minPrice == other.minPrice &&
          maxPrice == other.maxPrice &&
          showDiscountsOnly == other.showDiscountsOnly;

  @override
  int get hashCode => Object.hash(category, minPrice, maxPrice, showDiscountsOnly);
}
```

### JetPaginator - Infinite Scroll Pagination

`JetPaginator` provides powerful infinite scroll functionality that works with **any API format**. It's designed to be flexible and handle different pagination patterns (offset-based, cursor-based, page-based) with a unified interface.

**Built on [Infinite Scroll Pagination](https://pub.dev/packages/infinite_scroll_pagination)**: JetPaginator is built on top of the official `infinite_scroll_pagination` package, one of Flutter's most robust and battle-tested pagination solutions. This ensures maximum reliability, performance, and community support while providing Jet's simplified API on top.

#### Key Features

- **Official Package Foundation** - Built on the trusted `infinite_scroll_pagination` package
- **Universal API Support** - Works with any pagination format through `fetchPage` and `parseResponse` functions
- **Built-in Error Handling** - Automatic retry and error display with customizable error widgets
- **Riverpod Integration** - Optional provider support for refresh functionality
- **Performance Optimized** - Efficient state management through `PagingController`
- **Pull-to-Refresh** - Integrated refresh functionality with customizable indicators
- **Customizable UI** - Full control over loading, error, empty states, and refresh indicators
- **List and Grid Support** - Both list and grid layouts supported

#### JetPaginator Methods

| Method | Description |
|--------|-------------|
| `list()` | Creates an infinite scroll list that works with any API format |
| `grid()` | Creates an infinite scroll grid that works with any API format |

#### Basic Pagination Example (DummyJSON API)

```dart
class ProductsPaginatedList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetPaginator.list<Product, Map<String, dynamic>>(
      fetchPage: (pageKey) async {
        final api = ref.read(apiServiceProvider);
        return await api.getProducts(skip: pageKey, limit: 20);
      },
      parseResponse: (response, pageKey) => PageInfo(
        items: (response['products'] as List)
            .map((json) => Product.fromJson(json))
            .toList(),
        nextPageKey: response['skip'] + response['limit'] < response['total']
            ? response['skip'] + response['limit']
            : null,
      ),
      itemBuilder: (product, index) => ProductCard(product: product),
      firstPageKey: 0,
    );
  }
}
```

#### Cursor-Based Pagination Example

```dart
class PostsPaginatedList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetPaginator.list<Post, ApiResponse>(
      fetchPage: (cursor) async {
        final api = ref.read(apiServiceProvider);
        return await api.getPosts(cursor: cursor, limit: 20);
      },
      parseResponse: (response, currentCursor) => PageInfo(
        items: response.data.map((json) => Post.fromJson(json)).toList(),
        nextPageKey: response.pagination?.nextCursor,
        isLastPage: !response.pagination?.hasMore,
      ),
      itemBuilder: (post, index) => PostCard(post: post),
      firstPageKey: null, // Start with null cursor
    );
  }
}
```

#### Pagination Grid Example

```dart
class InfiniteProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetPaginator.grid<Product, Map<String, dynamic>>(
      fetchPage: (pageKey) async {
        return await api.getProducts(page: pageKey, size: 20);
      },
      parseResponse: (response, currentPage) => PageInfo(
        items: response.content.map((json) => Product.fromJson(json)).toList(),
        nextPageKey: response.hasNext ? (currentPage as int) + 1 : null,
        totalItems: response.totalElements,
      ),
      itemBuilder: (product, index) => ProductCard(product: product),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.75,
      firstPageKey: 1, // Start with page 1
    );
  }
}
```

#### Provider Integration for Refresh

```dart
class ProductsWithProviderRefresh extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetPaginator.list<Product, Map<String, dynamic>>(
      fetchPage: (pageKey) => api.getProducts(skip: pageKey, limit: 20),
      parseResponse: (response, pageKey) => PageInfo(
        items: (response['products'] as List)
            .map((json) => Product.fromJson(json))
            .toList(),
        nextPageKey: response['skip'] + response['limit'] < response['total']
            ? response['skip'] + response['limit']
            : null,
      ),
      itemBuilder: (product, index) => ProductCard(product: product),
      
      // Enable Riverpod integration for refresh
      provider: allProductsProvider, // This provider will be invalidated on refresh
      
      // Custom refresh callback
      onRefresh: () {
        // Additional custom refresh logic
        print('Refreshing products...');
      },
    );
  }
}

// Provider that will be invalidated during refresh
final allProductsProvider = AutoDisposeFutureProvider<List<Product>>((ref) async {
  final api = ref.read(apiServiceProvider);
  return await api.getAllProducts();
});
```

#### Custom Refresh Indicator Example

```dart
class CustomRefreshPaginator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetPaginator.list<Product, Map<String, dynamic>>(
      fetchPage: (pageKey) => api.getProducts(skip: pageKey, limit: 20),
      parseResponse: (response, pageKey) => PageInfo(
        items: (response['products'] as List)
            .map((json) => Product.fromJson(json))
            .toList(),
        nextPageKey: response['skip'] + response['limit'] < response['total']
            ? response['skip'] + response['limit']
            : null,
      ),
      itemBuilder: (product, index) => ProductCard(product: product),
      
      // Custom refresh indicator
      refreshIndicatorBuilder: (context, controller) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          child: Icon(
            Icons.refresh,
            color: controller.state.isLoading ? Colors.blue : Colors.grey,
            size: 24 + (controller.value * 12), // Animated size
          ),
        );
      },
      
      // Or use simple color customization
      refreshIndicatorColor: Colors.green,
      refreshIndicatorBackgroundColor: Colors.grey[100],
      refreshIndicatorStrokeWidth: 3.0,
      refreshIndicatorDisplacement: 50.0,
    );
  }
}
```

### JetConsumer Widgets

Jet provides enhanced consumer widgets that give you access to both Riverpod's `WidgetRef` and the Jet framework instance.

#### JetConsumerWidget

Use this when you need to extend a widget class:

```dart
import 'package:jet/jet.dart';

class MyCustomWidget extends JetConsumerWidget {
  const MyCustomWidget({super.key});

  @override
  Widget jetBuild(BuildContext context, WidgetRef ref, Jet jet) {
    // Access to ref for watching providers
    final user = ref.watch(userProvider);
    
    // Access to jet instance for framework features
    final router = jet.router;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
        actions: [
          IconButton(
            onPressed: () => router.pushNamed('/settings'),
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: user.when(
        data: (userData) => UserDetails(user: userData),
        loading: () => jet.config.loader, // Use Jet's configured loader
        error: (error, stack) => ErrorWidget(error),
      ),
    );
  }
}
```

#### JetConsumer

Use this functional approach when you don't need to extend a class:

```dart
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JetConsumer(
        builder: (context, ref, jet) {
          final settings = ref.watch(settingsProvider);
          
          return Column(
            children: [
              // Access theme switching from jet
              ThemeSwitcher.segmentedButton(context),
              
              // Access language switching
              LanguageSwitcher.toggleButton(),
              
              // Use JetBuilder for async data
              Expanded(
                child: JetBuilder.list<Setting>(
                  provider: userSettingsProvider,
                  itemBuilder: (setting, index) => SettingTile(setting: setting),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

### Pagination Models

Jet provides flexible pagination models that can adapt to different API response formats:

#### PageInfo

Simple pagination information used by JetPaginator - this is the main model for pagination:

```dart
class PageInfo<T> {
  /// The list of items for the current page
  final List<T> items;
  
  /// The key for the next page (can be page number, offset, cursor, etc.)
  /// If null, indicates this is the last page
  final dynamic nextPageKey;
  
  /// Whether this is the last page (optional, can be inferred from nextPageKey)
  final bool? isLastPage;
  
  /// Total number of items (optional, not all APIs provide this)
  final int? totalItems;
  
  const PageInfo({
    required this.items,
    this.nextPageKey,
    this.isLastPage,
    this.totalItems,
  });
}
```

#### PaginationResponse

A comprehensive pagination response wrapper that can adapt to different API formats:

```dart
// For DummyJSON-style APIs
final response = PaginationResponse.fromDummyJson(
  json,
  Product.fromJson,
  'products',
);

// For standard REST APIs
final response = PaginationResponse.fromJson(
  json,
  User.fromJson,
  dataExtractor: (json) => json['data'] as List<dynamic>,
  totalExtractor: (json) => json['total'] as int,
);

// For cursor-based APIs
final response = PaginationResponse.fromCursorBased(
  json,
  Post.fromJson,
  dataKey: 'data',
  paginationKey: 'pagination',
  nextCursorKey: 'next_cursor',
  hasMoreKey: 'has_more',
);

// For Laravel-style APIs
final response = PaginationResponse.fromLaravel(
  json,
  User.fromJson,
);

// For page-based APIs
final response = PaginationResponse.fromPageBased(
  json,
  Product.fromJson,
  dataKey: 'data',
  currentPageKey: 'current_page',
  lastPageKey: 'last_page',
  perPageKey: 'per_page',
  totalKey: 'total',
);
```

#### PaginationResponse Properties

```dart
class PaginationResponse<T> {
  final List<T> items;        // The list of items
  final int total;            // Total number of items
  final int skip;             // Current skip/offset value
  final int limit;            // Number of items per page
  final bool isLastPage;      // Whether this is the last page
  final dynamic nextPageKey;  // Next page key
  
  // Computed properties
  bool get hasNextPage => !isLastPage;
  bool get hasPreviousPage => skip > 0;
  int get currentPage => (skip ~/ limit) + 1;
  int get totalPages => total > 0 ? (total / limit).ceil() : 0;
  String get itemRange => // "1-10 of 100"
}
```

### Provider Extensions

Jet provides useful extensions to make working with providers easier:

#### Refresh Extensions

| Method | Description |
|--------|-------------|
| `refreshByInvalidating()` | Simple refresh that invalidates the provider |
| `refreshFamilyByInvalidating()` | Simple refresh for family providers |
| `refreshFutureProvider()` | Refresh for FutureProvider that waits for completion |
| `refreshAutoDisposeFutureProvider()` | Refresh for AutoDisposeFutureProvider that waits for completion |
| `refreshFutureProviderFamily()` | Refresh for FutureProvider.family that waits for completion |
| `refreshAutoDisposeFutureProviderFamily()` | Refresh for AutoDisposeFutureProvider.family that waits for completion |
| `retryProvider()` | Retry callback for error states |
| `retryFamilyProvider()` | Retry callback for family providers |

#### Refresh Extensions Usage

```dart
class MyWidget extends JetConsumerWidget {
  @override
  Widget jetBuild(BuildContext context, WidgetRef ref, Jet jet) {
    return JetBuilder.list<Post>(
      provider: postsProvider,
      itemBuilder: (post, index) => PostCard(post: post),
      
      // Use extension methods for refresh - waits for completion
      onRefresh: ref.refreshAutoDisposeFutureProvider(postsProvider),
      
      // Or use simple invalidating refresh
      onRefresh: ref.refreshByInvalidating(postsProvider),
    );
  }
}

// For family providers
class CategoryWidget extends JetConsumerWidget {
  final String categoryId;
  
  @override
  Widget jetBuild(BuildContext context, WidgetRef ref, Jet jet) {
    return JetBuilder.familyList<Post, String>(
      provider: postsByCategoryProvider,
      param: categoryId,
      itemBuilder: (post, index) => PostCard(post: post),
      
      // Family provider refresh
      onRefresh: ref.refreshAutoDisposeFutureProviderFamily(
        postsByCategoryProvider,
        categoryId,
      ),
    );
  }
}
```



### Performance Optimizations

Jet's state management includes several performance optimizations:

#### Smart Loading States

```dart
// JetBuilder prevents double loading indicators during refresh
JetBuilder.list<Post>(
  provider: postsProvider,
  itemBuilder: (post, index) => PostCard(post: post),
  // Built-in optimizations:
  // - skipLoadingOnReload: true
  // - skipLoadingOnRefresh: true
);
```

#### Automatic Resource Management

```dart
// AutoDispose providers automatically clean up when not in use
final postsProvider = AutoDisposeFutureProvider<List<Post>>((ref) async {
  // This provider will be disposed when no widgets are watching it
  final api = ref.read(apiServiceProvider);
  return await api.getPosts();
});
```

#### Minimal Rebuilds

```dart
class OptimizedPostsList extends JetConsumerWidget {
  @override
  Widget jetBuild(BuildContext context, WidgetRef ref, Jet jet) {
    // Only this widget rebuilds when posts change
    final posts = ref.watch(postsProvider);
    
    return JetBuilder.list<Post>(
      provider: postsProvider,
      itemBuilder: (post, index) {
        // Each item can watch its own specific data
        return Consumer(
          builder: (context, ref, child) {
            final isLiked = ref.watch(postLikeProvider(post.id));
            return PostCard(
              post: post,
              isLiked: isLiked,
            );
          },
        );
      },
    );
  }
}
```

### Complete Example

Here's a complete example showing how all pieces work together:

```dart
// Provider definitions
final postsProvider = AutoDisposeFutureProvider<List<Post>>((ref) async {
  final api = ref.read(apiServiceProvider);
  return await api.getAllPosts();
});

final postsByCategoryProvider = AutoDisposeFutureProvider.family<List<Post>, String>((ref, categoryId) async {
  final api = ref.read(apiServiceProvider);
  return await api.getPostsByCategory(categoryId);
});

// Main posts page with tabs
class PostsPage extends JetConsumerWidget {
  @override
  Widget jetBuild(BuildContext context, WidgetRef ref, Jet jet) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Posts'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Tech'),
              Tab(text: 'Lifestyle'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // All posts - simple list
            JetBuilder.list<Post>(
              provider: postsProvider,
              itemBuilder: (post, index) => PostCard(post: post),
              padding: EdgeInsets.all(16),
            ),
            
            // Tech posts - family provider
            JetBuilder.familyList<Post, String>(
              provider: postsByCategoryProvider,
              param: 'tech',
              itemBuilder: (post, index) => PostCard(post: post),
              padding: EdgeInsets.all(16),
            ),
            
            // Lifestyle posts with pagination
            JetPaginator.list<Post, Map<String, dynamic>>(
              fetchPage: (pageKey) async {
                return await api.getPostsByCategory('lifestyle', skip: pageKey, limit: 20);
              },
              parseResponse: (response, pageKey) => PageInfo(
                items: (response['posts'] as List)
                    .map((json) => Post.fromJson(json))
                    .toList(),
                nextPageKey: response['skip'] + response['limit'] < response['total']
                    ? response['skip'] + response['limit']
                    : null,
              ),
              itemBuilder: (post, index) => PostCard(post: post),
              firstPageKey: 0,
            ),
          ],
        ),
      ),
    );
  }
}
```

### Key Features

- **Unified API** - Single `JetBuilder` handles lists, grids, single items, and custom builders
- **Riverpod Integration** - Built on top of Flutter's most powerful state management solution  
- **Family Provider Support** - Full support for parameterized providers with dedicated family methods
- **Pull-to-Refresh** - Built-in refresh functionality with proper state handling using `custom_refresh_indicator`
- **Infinite Scroll** - `JetPaginator` built on official `infinite_scroll_pagination` package
- **Universal Pagination** - Works with any API format through `fetchPage` and `parseResponse` functions
- **Performance Optimized** - Smart loading states, minimal rebuilds, and efficient `PagingController`
- **Smart Error Handling** - Built-in error widgets with loading-aware retry buttons and automatic error categorization
- **Unified Error Experience** - Consistent error handling across regular and family providers
- **Type Safety** - Full type safety with automatic Dart type inference
- **JetConsumer Widgets** - Enhanced consumer widgets with Jet instance access
- **Provider Extensions** - Comprehensive utility extensions for refresh and retry functionality
- **Flexible Pagination Models** - Support for DummyJSON, cursor-based, page-based, and Laravel APIs
- **Automatic Resource Management** - AutoDispose providers for memory efficiency
- **Customizable UI** - Full control over loading, error, refresh indicators, and empty states
