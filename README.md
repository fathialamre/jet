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
- [Using Localization](#-using-localization)
  - [Language Switcher Components](#language-switcher-components)
  - [Basic Usage](#basic-usage-1)
  - [Advanced Usage with State Management](#advanced-usage-with-state-management)
  - [Custom Language Switcher](#custom-language-switcher)
  - [Adding Custom Locales](#adding-custom-locales)
  - [Integration with App Configuration](#integration-with-app-configuration)
  - [Complete Integration Example](#complete-integration-example)
  - [Key Features](#key-features-1)

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
