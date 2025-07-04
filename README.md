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
- [State Management](#-state-management)
  - [Riverpod Integration](#riverpod-integration)
  - [JetConsumer Widgets](#jetconsumer-widgets)
  - [Refreshable Widgets](#refreshable-widgets)
  - [JetAsyncRefreshableWidget](#jetasyncrefreshablewidget)
  - [State Helpers](#state-helpers)
  - [Provider Types Support](#provider-types-support)
  - [Performance Optimizations](#performance-optimizations)
  - [Key Features](#key-features-4)

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

## 🔄 State Management

Jet Framework derives its true power from **[Riverpod](https://pub.dev/packages/hooks_riverpod)**, one of Flutter's most robust and efficient state management solutions. By building on top of Riverpod's foundation, Jet provides enhanced widgets, utilities, and patterns that make state management both powerful and developer-friendly.

**Riverpod** brings compile-time safety, automatic dependency injection, excellent testing capabilities, and performance optimizations. Jet Framework amplifies these benefits by providing specialized widgets for common patterns like data fetching with pull-to-refresh, error handling, and loading states.

### Riverpod Integration

Jet Framework is deeply integrated with Riverpod and provides enhanced widgets that work seamlessly with all Riverpod provider types:

| Provider Type | Description | Jet Support |
|---------------|-------------|-------------|
| `Provider` | Simple read-only values | ✅ Full support |
| `StateProvider` | Simple mutable state | ✅ Full support |
| `FutureProvider` | Async operations | ✅ **Enhanced with refreshable widgets** |
| `StreamProvider` | Stream of values | ✅ Full support |
| `StateNotifierProvider` | Complex state management | ✅ Enhanced support |
| `ChangeNotifierProvider` | Legacy change notifier | ✅ Full support |

**Learn more about Riverpod:** [https://pub.dev/packages/hooks_riverpod](https://pub.dev/packages/hooks_riverpod)

### JetConsumer Widgets

Jet provides specialized consumer widgets that give you access to both Riverpod's `WidgetRef` and the Jet framework instance:

#### JetConsumerWidget

Use this when you need to extend a widget class:

```dart
import 'package:jet/jet.dart';

class UserProfile extends JetConsumerWidget {
  const UserProfile({super.key});

  @override
  Widget jetBuild(BuildContext context, WidgetRef ref, Jet jet) {
    // Access to ref for watching providers
    final user = ref.watch(userProvider);
    
    // Access to jet instance for framework features
    final router = jet.router;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
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
              
              // Use refreshable widgets for async data
              Expanded(
                child: JetAsyncRefreshableWidget.autoDisposeFutureProvider<List<Setting>>(
                  provider: userSettingsProvider,
                  builder: (settings, ref) => SettingsList(settings: settings),
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

### Refreshable Widgets

One of Jet's most powerful features is its refreshable widget system. These widgets provide complete pull-to-refresh functionality with proper loading states, error handling, and performance optimizations.

#### Basic JetRefreshableWidget

For complete control over the refresh behavior:

```dart
class PostsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetRefreshableWidget<List<Post>>(
      // Watch any AsyncValue provider
      asyncValue: (ref) => ref.watch(postsProvider),
      
      // Custom refresh logic
      onRefresh: () async {
        await ApiService.refreshPosts();
        // Additional refresh logic
      },
      
      // Builder when data is available
      builder: (posts, ref) {
        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) => PostCard(post: posts[index]),
        );
      },
      
      // Optional custom loading widget
      loading: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading posts...'),
          ],
        ),
      ),
      
      // Optional custom error widget
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text('Failed to load posts'),
            TextButton(
              onPressed: () {
                // Custom retry logic
              },
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### JetAsyncRefreshableWidget

`JetAsyncRefreshableWidget` is Jet Framework's premier solution for handling asynchronous data with pull-to-refresh functionality. This powerful widget automatically manages loading states, error handling, and refresh operations for different types of Riverpod providers.

**JetAsyncRefreshableWidget** comes in **two main types**:

| Type | Description | Use Case |
|------|-------------|----------|
| **Regular** | Works with standard providers that don't require parameters | Static data fetching (all posts, user profile, app settings) |
| **Family** | Works with parameterized providers that accept arguments | Dynamic data fetching (posts by category, user by ID, search results) |

Both types provide the same powerful features:
- **Automatic refresh logic** based on provider type
- **Built-in loading and error states** with customizable UI
- **Pull-to-refresh functionality** with smooth animations
- **Performance optimizations** to prevent unnecessary rebuilds
- **Type safety** with full Dart-like type inference

#### Regular JetAsyncRefreshableWidget

Use this for providers that don't require parameters. Perfect for fetching static data like user profiles, app settings, or general content lists.

```dart
// Example 1: Simple Posts List
class PostsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetAsyncRefreshableWidget.autoDisposeFutureProvider<List<Post>>(
      provider: postsProvider,
      builder: (posts, ref) {
        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) => PostCard(post: posts[index]),
        );
      },
      // Optional: Custom loading widget
      loadingBuilder: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading posts...'),
          ],
        ),
      ),
      // Optional: Custom error widget
      errorBuilder: (error, stackTrace) => Center(
        child: Column(
          children: [
            Icon(Icons.error, size: 48, color: Colors.red),
            Text('Failed to load posts'),
            ElevatedButton(
              onPressed: () => ref.invalidate(postsProvider),
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// Provider definition
final postsProvider = AutoDisposeFutureProvider<List<Post>>((ref) async {
  final api = ref.read(apiServiceProvider);
  return await api.getAllPosts();
});
```

```dart
// Example 2: User Profile
class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: JetAsyncRefreshableWidget.autoDisposeFutureProvider<UserProfile>(
        provider: currentUserProfileProvider,
        builder: (profile, ref) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(profile.avatarUrl),
                ),
                SizedBox(height: 16),
                Text(profile.name, style: Theme.of(context).textTheme.headlineMedium),
                Text(profile.email),
                SizedBox(height: 24),
                ProfileStats(profile: profile),
                SizedBox(height: 24),
                ProfileActions(profile: profile),
              ],
            ),
          );
        },
      ),
    );
  }
}

final currentUserProfileProvider = AutoDisposeFutureProvider<UserProfile>((ref) async {
  final api = ref.read(apiServiceProvider);
  final userId = ref.read(authProvider).currentUser?.id;
  if (userId == null) throw Exception('User not authenticated');
  return await api.getUserProfile(userId);
});
```

#### Family JetAsyncRefreshableWidget

Use this for providers that require parameters. Perfect for dynamic data fetching where the content depends on user input, route parameters, or other variables.

```dart
// Example 1: Products by Category
class CategoryProductsPage extends StatelessWidget {
  final String categoryId;
  
  const CategoryProductsPage({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return JetAsyncRefreshableWidget.autoDisposeFutureProviderFamily<List<Product>, String>(
      provider: productsByCategoryProvider,
      param: categoryId,
      builder: (products, ref) {
        return GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) => ProductCard(
            product: products[index],
            onTap: () => _navigateToProduct(context, products[index]),
          ),
        );
      },
    );
  }
  
  void _navigateToProduct(BuildContext context, Product product) {
    context.router.pushNamed('/product/${product.id}');
  }
}

// Family provider definition
final productsByCategoryProvider = AutoDisposeFutureProvider.family<List<Product>, String>((ref, categoryId) async {
  final api = ref.read(apiServiceProvider);
  return await api.getProductsByCategory(categoryId);
});
```

```dart
// Example 2: Search Results
class SearchResultsPage extends StatelessWidget {
  final String searchQuery;
  
  const SearchResultsPage({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search: $searchQuery'),
      ),
      body: JetAsyncRefreshableWidget.autoDisposeFutureProviderFamily<SearchResults, String>(
        provider: searchResultsProvider,
        param: searchQuery,
        builder: (results, ref) {
          if (results.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No results found for "$searchQuery"'),
                  SizedBox(height: 8),
                  Text('Try a different search term'),
                ],
              ),
            );
          }
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '${results.totalCount} results found',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: results.items.length,
                  itemBuilder: (context, index) => SearchResultCard(
                    result: results.items[index],
                    query: searchQuery,
                  ),
                ),
              ),
            ],
          );
        },
        loadingBuilder: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Searching for "$searchQuery"...'),
            ],
          ),
        ),
      ),
    );
  }
}

final searchResultsProvider = AutoDisposeFutureProvider.family<SearchResults, String>((ref, query) async {
  if (query.trim().isEmpty) {
    return SearchResults(items: [], totalCount: 0);
  }
  
  final api = ref.read(apiServiceProvider);
  return await api.search(query);
});
```

```dart
// Example 3: User Posts with Pagination
class UserPostsTab extends StatelessWidget {
  final String userId;
  
  const UserPostsTab({required this.userId});

  @override
  Widget build(BuildContext context) {
    return JetAsyncRefreshableWidget.autoDisposeFutureProviderFamily<List<Post>, String>(
      provider: userPostsProvider,
      param: userId,
      builder: (posts, ref) {
        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return PostCard(
              post: post,
              showAuthor: false, // Don't show author since we're on their profile
              onLike: () => _toggleLike(ref, post),
              onComment: () => _showComments(context, post),
            );
          },
        );
      },
      errorBuilder: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text('Unable to load user posts'),
            TextButton(
              onPressed: () => ref.invalidate(userPostsProvider(userId)),
              child: Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _toggleLike(WidgetRef ref, Post post) {
    ref.read(postLikesProvider.notifier).toggleLike(post.id);
  }
  
  void _showComments(BuildContext context, Post post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CommentsBottomSheet(postId: post.id),
    );
  }
}

final userPostsProvider = AutoDisposeFutureProvider.family<List<Post>, String>((ref, userId) async {
  final api = ref.read(apiServiceProvider);
  return await api.getUserPosts(userId);
});
```

#### Advanced Family Provider Examples

```dart
// Example 4: Complex Parameters with Custom Types
class FilteredProductsPage extends StatelessWidget {
  final ProductFilter filter;
  
  const FilteredProductsPage({required this.filter});

  @override
  Widget build(BuildContext context) {
    return JetAsyncRefreshableWidget.autoDisposeFutureProviderFamily<List<Product>, ProductFilter>(
      provider: filteredProductsProvider,
      param: filter,
      builder: (products, ref) {
        return Column(
          children: [
            FilterSummary(filter: filter),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) => ProductCard(product: products[index]),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Custom parameter type
class ProductFilter {
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final String? brand;
  final bool inStock;
  
  const ProductFilter({
    this.category,
    this.minPrice,
    this.maxPrice,
    this.brand,
    this.inStock = true,
  });
  
  // Override equality for proper provider caching
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductFilter &&
          runtimeType == other.runtimeType &&
          category == other.category &&
          minPrice == other.minPrice &&
          maxPrice == other.maxPrice &&
          brand == other.brand &&
          inStock == other.inStock;

  @override
  int get hashCode =>
      category.hashCode ^
      minPrice.hashCode ^
      maxPrice.hashCode ^
      brand.hashCode ^
      inStock.hashCode;
}

final filteredProductsProvider = AutoDisposeFutureProvider.family<List<Product>, ProductFilter>((ref, filter) async {
  final api = ref.read(apiServiceProvider);
  return await api.getFilteredProducts(filter);
});
```

### State Helpers

`JetStateHelpers` provides a collection of pre-built, highly optimized convenience methods that eliminate boilerplate code for the most common UI patterns in mobile applications. These helpers automatically handle pull-to-refresh functionality, loading states, error handling, and performance optimizations.

**Key Features of JetStateHelpers:**
- **Zero Boilerplate** - Reduces complex state management to single method calls
- **Built-in Pull-to-Refresh** - Automatic refresh functionality with smooth animations
- **Family Provider Support** - Full support for parameterized providers
- **Performance Optimized** - Smart loading states and minimal rebuilds
- **Customizable UI** - Optional custom loading, error, and layout configurations
- **Type Safe** - Full type inference and compile-time safety

**Available Helper Methods:**

| Method | Description | Family Support |
|--------|-------------|----------------|
| `refreshableList()` | Creates ListView with pull-to-refresh for list data | ✅ `refreshableListFamily()` |
| `refreshableGrid()` | Creates GridView with pull-to-refresh for grid layouts | ✅ `refreshableGridFamily()` |
| `refreshableItem()` | Creates scrollable single item with pull-to-refresh | ✅ `refreshableItemFamily()` |

Each helper method comes in two variants:
- **Regular**: For providers without parameters (`AutoDisposeFutureProvider<List<T>>`)
- **Family**: For providers with parameters (`AutoDisposeFutureProvider<List<T>>.family`)

#### Refreshable Lists

Perfect for displaying lists of items with pull-to-refresh functionality. Automatically handles ListView configuration, item building, and refresh logic.

```dart
// Regular Provider Example
class QuickPostsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetStateHelpers.refreshableList<Post>(
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
      // Optional customizations
      physics: BouncingScrollPhysics(),
      loading: Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => ErrorMessage(error: error),
    );
  }
}

// Family Provider Example - Posts by Category
class CategoryPostsList extends StatelessWidget {
  final String categoryId;
  
  const CategoryPostsList({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return JetStateHelpers.refreshableListFamily<Post, String>(
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

#### Refreshable Grids

Ideal for displaying items in a grid layout with pull-to-refresh functionality. Perfect for product catalogs, photo galleries, or any grid-based content.

```dart
// Regular Provider Example
class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetStateHelpers.refreshableGrid<Product>(
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

// Family Provider Example - Products by Category with Filters
class FilteredProductsGrid extends StatelessWidget {
  final ProductFilter filter;
  
  const FilteredProductsGrid({required this.filter});

  @override
  Widget build(BuildContext context) {
    return JetStateHelpers.refreshableGridFamily<Product, ProductFilter>(
      provider: filteredProductsProvider,
      param: filter,
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2, // Responsive
      itemBuilder: (product, index) => ProductCard(
        product: product,
        showDiscount: filter.showDiscountsOnly,
        onQuickView: () => _showQuickView(context, product),
      ),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.8,
      padding: EdgeInsets.all(20),
      loading: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading filtered products...'),
          ],
        ),
      ),
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

final filteredProductsProvider = AutoDisposeFutureProvider.family<List<Product>, ProductFilter>((ref, filter) async {
  final api = ref.read(apiServiceProvider);
  return await api.getFilteredProducts(filter);
});
```

#### Refreshable Single Items

Perfect for displaying detailed single items with pull-to-refresh functionality. The content is automatically wrapped in a scrollable container to enable refresh gestures.

```dart
// Regular Provider Example
class UserProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetStateHelpers.refreshableItem<UserProfile>(
      provider: currentUserProfileProvider,
      itemBuilder: (profile, ref) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(profile.avatarUrl),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 18,
                  child: IconButton(
                    onPressed: () => _editProfile(profile),
                    icon: Icon(Icons.edit, size: 16),
                  ),
                ),
              ),
            ],
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
          SizedBox(height: 24),
          RecentActivitySection(userId: profile.id),
        ],
      ),
      padding: EdgeInsets.all(20),
    );
  }
  
  void _editProfile(UserProfile profile) {
    // Navigate to edit profile page
  }
}

// Family Provider Example - User Profile by ID
class PublicUserProfile extends StatelessWidget {
  final String userId;
  
  const PublicUserProfile({required this.userId});

  @override
  Widget build(BuildContext context) {
    return JetStateHelpers.refreshableItemFamily<UserProfile, String>(
      provider: userProfileByIdProvider,
      param: userId,
      itemBuilder: (profile, ref) => Column(
        children: [
          ProfileHeader(profile: profile),
          SizedBox(height: 24),
          ProfileBio(bio: profile.bio),
          SizedBox(height: 32),
          ProfileTabs(userId: userId), // Posts, Followers, Following
          SizedBox(height: 24),
          ContactActions(profile: profile),
        ],
      ),
      padding: EdgeInsets.all(16),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Unable to load user profile'),
            SizedBox(height: 8),
            Text('This user may not exist or be private'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

final userProfileByIdProvider = AutoDisposeFutureProvider.family<UserProfile, String>((ref, userId) async {
  final api = ref.read(apiServiceProvider);
  return await api.getUserProfile(userId);
});
```

### Provider Types Support

Jet's refreshable widgets support different provider types with optimized refresh strategies:

#### AutoDisposeFutureProvider (Recommended)

```dart
final postsProvider = AutoDisposeFutureProvider<List<Post>>((ref) async {
  final api = ref.read(apiServiceProvider);
  return await api.getPosts();
});

// Usage
JetAsyncRefreshableWidget.autoDisposeFutureProvider<List<Post>>(
  provider: postsProvider,
  builder: (posts, ref) => PostsList(posts: posts),
);
```

#### FutureProvider

```dart
final userProvider = FutureProvider<User>((ref) async {
  final api = ref.read(apiServiceProvider);
  return await api.getCurrentUser();
});

// Usage
JetAsyncRefreshableWidget.futureProvider<User>(
  provider: userProvider,
  builder: (user, ref) => UserProfile(user: user),
);
```

#### StateNotifier (Legacy Support)

```dart
class PostsNotifier extends StateNotifier<AsyncValue<List<Post>>> {
  PostsNotifier(this._api) : super(const AsyncValue.loading());
  
  final ApiService _api;

  Future<void> loadPosts() async {
    state = const AsyncValue.loading();
    try {
      final posts = await _api.getPosts();
      state = AsyncValue.data(posts);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  Future<void> refresh() => loadPosts();
}

final postsProvider = StateNotifierProvider<PostsNotifier, AsyncValue<List<Post>>>((ref) {
  return PostsNotifier(ref.read(apiServiceProvider));
});

// Usage
JetAsyncRefreshableWidget.notifier<List<Post>>(
  provider: postsProvider,
  refreshMethod: () => ref.read(postsProvider.notifier).refresh(),
  builder: (posts, ref) => PostsList(posts: posts),
);
```

### Performance Optimizations

Jet's refreshable widgets include several performance optimizations:

#### Smart Loading States

```dart
// Prevents double loading indicators during refresh
JetRefreshableWidget<List<Post>>(
  asyncValue: (ref) => ref.watch(postsProvider),
  onRefresh: () => ref.refresh(postsProvider.future),
  builder: (posts, ref) => PostsList(posts: posts),
  // These optimizations are built-in:
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
    
    // Theme and other providers are watched separately
    final theme = ref.watch(themeSwitcherProvider);
    
    return posts.when(
      data: (postList) => ListView.builder(
        itemCount: postList.length,
        itemBuilder: (context, index) {
          // Each item can watch its own specific data
          return Consumer(
            builder: (context, ref, child) {
              final isLiked = ref.watch(postLikeProvider(postList[index].id));
              return PostCard(
                post: postList[index],
                isLiked: isLiked,
              );
            },
          );
        },
      ),
      loading: () => jet.config.loader,
      error: (error, stack) => ErrorWidget(error),
    );
  }
}
```

#### Key Features

- **Riverpod Integration** - Built on top of Flutter's most powerful state management solution
- **Refreshable Widgets** - Pull-to-refresh functionality with proper state handling
- **Multiple Provider Support** - Works with FutureProvider, StateNotifier, and more
- **Performance Optimized** - Smart loading states and minimal rebuilds
- **Error Handling** - Built-in error widgets with retry functionality
- **Type Safety** - Full type safety with automatic Dart type inference
- **JetConsumer Widgets** - Enhanced consumer widgets with Jet instance access
- **State Helpers** - Convenient methods for common patterns (lists, grids, single items)
- **Automatic Resource Management** - AutoDispose providers for memory efficiency
- **Customizable UI** - Full control over loading, error, and refresh indicators
