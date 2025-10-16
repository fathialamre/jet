# 🚀 Jet Framework

**Jet** is a production-ready, lightweight Flutter framework designed for building scalable, maintainable applications with confidence. It provides a complete architectural foundation with best practices baked in, eliminating boilerplate and accelerating development from prototype to production.

Built on **Riverpod 3** with code generation support, Jet combines powerful state management, type-safe networking, secure storage, and a rich component library—all working seamlessly together.

## ✨ Why Jet?

- **🎯 Batteries Included** - Everything you need from day one: routing, networking, forms, storage, notifications, and more
- **📐 Opinionated Architecture** - Best practices and patterns built-in, no more architectural decisions paralysis
- **⚡ Developer Experience** - Hot reload friendly, minimal boilerplate, fluent APIs, and comprehensive documentation
- **🔐 Production Ready** - Security features, error handling, logging, and performance optimizations out of the box
- **🌍 Global Ready** - Built-in internationalization, RTL support, and adaptive UI components
- **🧩 Modular Design** - Use what you need, extend with adapters, customize to fit your requirements

## 📦 Installation

Add Jet to your Flutter project:

```yaml
dependencies:
  jet:
    path: packages/jet
```

## 🚀 Quick Start

Get up and running with Jet in 3 simple steps:

### 1. Create Your App Configuration

Create a configuration file at `lib/core/config/app_config.dart`:

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
  ];

  @override
  ThemeData? get theme => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
  );
}
```

### 2. Set Up Your Router

Create a router file at `lib/core/router/app_router.dart`:

```dart
import 'package:auto_route/auto_route.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, path: '/', initial: true),
  ];
}

final appRouterProvider = AutoDisposeProvider<AppRouter>((ref) {
  return AppRouter();
});
```

### 3. Initialize in main.dart

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

**That's it!** 🎉 You now have a fully configured Jet app with routing, theming, localization, storage, and notifications ready to go.

## 📋 Features

### ⚙️ Configuration

Centralized app configuration with `JetConfig` for adapters, locales, themes, and network logging.

```dart
class AppConfig extends JetConfig {
  @override
  List<JetAdapter> get adapters => [RouterAdapter()];

  @override
  List<LocaleInfo> get supportedLocales => [
    LocaleInfo(locale: const Locale('en'), displayName: 'English', nativeName: 'English'),
  ];
}
```

📖 **[View Complete Documentation](docs/CONFIGURATION.md)**

---

### 🧭 Routing

Type-safe navigation with **[AutoRoute](https://pub.dev/packages/auto_route)** (v7.8.4) integration. AutoRoute provides code generation for type-safe routes, eliminating string-based navigation and providing compile-time safety.

```dart
// Navigate to a route
context.router.push(ProfileRoute());

// Navigate with parameters
context.router.push(ProfileRoute(userId: '123'));
```

📖 **[View Complete Documentation](docs/ROUTING.md)**

---

### 🔌 Adapters

Extend Jet with custom adapters for third-party services.

```dart
class FirebaseAdapter implements JetAdapter {
  @override
  Future<Jet?> boot(Jet jet) async {
    await Firebase.initializeApp();
    return jet;
  }
}
```

📖 **[View Complete Documentation](docs/ADAPTERS.md)**

---

### 💾 Storage

Secure local storage for lightweight data using **[shared_preferences](https://pub.dev/packages/shared_preferences)** for regular data and **[flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)** for encrypted sensitive data (tokens, passwords).

```dart
// Regular storage
await JetStorage.write('user_name', 'John Doe');
String? name = JetStorage.read<String>('user_name');

// Secure storage (encrypted)
await JetStorage.writeSecure('auth_token', 'your-jwt-token');
String? token = await JetStorage.readSecure('auth_token');
```

📖 **[View Complete Documentation](docs/STORAGE.md)**

---

### 🎨 Theming

Built-in theme management with persistent storage using **[shared_preferences](https://pub.dev/packages/shared_preferences)**. Supports light, dark, and system theme modes with smooth transitions and Material 3 design.

```dart
// Add theme toggle button
AppBar(
  actions: [ThemeSwitcher.toggleButton(context)],
)

// Or use programmatically
themeNotifier.toggleTheme();
```

📖 **[View Complete Documentation](docs/THEMING.md)**

---

### 🌍 Localization

Internationalization support using **[intl](https://pub.dev/packages/intl)** package with language switching, RTL support, and persistent language preferences. Easy multi-language setup with date and number formatting per locale.

```dart
// Add language switcher
AppBar(
  actions: [LanguageSwitcher.toggleButton()],
)

// Access translations
final text = context.jetI10n.confirm;
```

📖 **[View Complete Documentation](docs/LOCALIZATION.md)**

---

### 🌐 Networking

Type-safe HTTP client built on **[Dio](https://pub.dev/packages/dio)** (v5.4.0) with automatic error handling, interceptors, and beautiful console logging via **[pretty_dio_logger](https://pub.dev/packages/pretty_dio_logger)**. Supports FormData, request cancellation, and timeout handling.

```dart
class UserApiService extends JetApiService {
  @override
  String get baseUrl => 'https://api.example.com/v1';

  Future<ResponseModel<List<User>>> getUsers() async {
    return await get<List<User>>(
      '/users',
      decoder: (data) => (data as List)
          .map((json) => User.fromJson(json))
          .toList(),
    );
  }
}
```

📖 **[View Complete Documentation](docs/NETWORKING.md)**

---

### ⚠️ Error Handling

Comprehensive error handling with `JetError` for consistent, type-safe error management.

```dart
try {
  final result = await apiService.getData();
} on JetError catch (error) {
  if (error.isValidation) {
    // Handle validation errors
  } else if (error.isNoInternet) {
    // Handle network errors  
  }
}
```

📖 **[View Complete Documentation](docs/ERROR_HANDLING.md)**

---

### 📝 Forms

Powerful, type-safe form management built with **[Flutter Hooks](https://pub.dev/packages/flutter_hooks)** and **[Riverpod 3](https://pub.dev/packages/riverpod)**. Two approaches available:

**🎯 Simple Forms** (recommended to start) - Use `useJetForm` hook for 80% of forms:

```dart
class LoginPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = useJetForm<LoginRequest, LoginResponse>(
      ref: ref,
      decoder: (json) => LoginRequest.fromJson(json),
      action: (request) => apiService.login(request),
      onSuccess: (response, request) {
        context.showToast('Welcome!');
        context.router.push(const HomeRoute());
      },
    );

    return JetSimpleForm(
      form: form,
      children: [
        JetTextField(
          name: 'email',
          validator: JetValidators.compose([
            JetValidators.required(),
            JetValidators.email(),
          ]),
        ),
        JetPasswordField(name: 'password'),
      ],
    );
  }
}
```

**🚀 Advanced Forms** (for complex requirements) - Use `JetFormNotifier` for enterprise features:

```dart
@riverpod
class LoginForm extends _$LoginForm with JetFormMixin<LoginRequest, LoginResponse> {
  @override
  AsyncFormValue<LoginRequest, LoginResponse> build() {
    return const AsyncFormIdle();
  }

  @override
  LoginRequest decoder(Map<String, dynamic> json) => LoginRequest.fromJson(json);

  @override
  Future<LoginResponse> action(LoginRequest data) => apiService.login(data);
  
  // Add custom validation, lifecycle hooks, etc.
}
```

**When to use each:**
- **Simple Forms**: Login, registration, settings, contact forms (80% of cases)
- **Advanced Forms**: Multi-step wizards, conditional fields, complex validation (20% of cases)

**Key Features:**
- 🔒 Type-safe with `Request`/`Response` generics
- ✅ 70+ built-in validators (email, phone, password, credit card, etc.)
- 🎯 15+ form fields: text, password, dropdown, date/time, chips, sliders, OTP/PIN
- 🌍 Auto-localized error messages (English, Arabic, French)
- ⚡ Performance optimized (70-90% fewer rebuilds)
- 🔄 Form change detection and reactive state
- 📝 Password confirmation helpers

📖 **[Getting Started](docs/FORMS.md)** | **[Simple Forms Guide](docs/FORMS_SIMPLE.md)** | **[Advanced Forms Guide](docs/FORMS_ADVANCED.md)** | **[Form Fields Reference](docs/FORM_FIELDS.md)**

---

### 🧩 Components

Pre-built UI components with consistent styling and automatic loading states. Built on Flutter's Material/Cupertino widgets with **[smooth_page_indicator](https://pub.dev/packages/smooth_page_indicator)** for beautiful carousel indicators.

#### JetButton

```dart
JetButton.filled(
  text: 'Submit',
  onTap: () async {
    await submitData();
  },
)
```

#### JetTab

```dart
JetTab.simple(
  keepAlive: true,
  lazyLoad: true,
  tabs: ['Home', 'Profile', 'Settings'],
  children: [HomeView(), ProfileView(), SettingsView()],
)
```

#### JetCarousel

```dart
JetCarousel<Product>(
  items: products,
  autoPlay: true,
  builder: (context, index, product) => ProductCard(product: product),
)
```

📖 **[View Complete Documentation](docs/COMPONENTS.md)**

---

### 💬 Dialogs & Sheets

Beautiful, adaptive dialogs and bottom sheets with built-in confirmation workflows.

```dart
// Adaptive confirmation dialog
await showAdaptiveConfirmationDialog(
  context: context,
  title: 'Delete Account',
  message: 'Are you sure?',
  onConfirm: () async {
    await deleteAccount();
  },
);

// Confirmation bottom sheet
showConfirmationSheet(
  context: context,
  title: 'Save Changes',
  message: 'Do you want to save your changes?',
  type: ConfirmationSheetType.success,
  onConfirm: () async {
    await saveChanges();
  },
);
```

📖 **[View Complete Documentation](docs/DIALOGS_AND_SHEETS.md)**

---

### 🎯 Extensions

Powerful Dart extension methods for BuildContext, Text, DateTime, and Number classes. Uses **[intl](https://pub.dev/packages/intl)** for date formatting with no performance overhead (compile-time extensions).

```dart
// Context extensions
context.showToast('Success!');
if (context.isAndroid) { /* ... */ }

// Text extensions
Text('Title').titleLarge(context).bold().color(Colors.blue)

// DateTime extensions
final formatted = now.formattedDate(format: 'MMM dd, yyyy');

// Number extensions
final orderId = 123.toOrderId(); // "00123"
```

📖 **[View Complete Documentation](docs/EXTENSIONS.md)**

---

### 🔐 Security

App locking with biometric authentication using **[Guardo](https://pub.dev/packages/guardo)** (v1.1.0). Supports fingerprint, face ID, iris scan with PIN/pattern fallback and secure storage via **[flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)**.

```dart
// Enable app lock
SwitchListTile(
  title: Text('App Lock'),
  value: ref.watch(appLockProvider),
  onChanged: (enabled) {
    ref.read(appLockProvider.notifier).toggle(context);
  },
)
```

📖 **[View Complete Documentation](docs/SECURITY.md)**

---

### 🔐 Sessions

Built-in session management for user authentication with encrypted storage via **[flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)** and reactive state through **[Riverpod](https://pub.dev/packages/riverpod)**. Automatic session persistence across app restarts.

```dart
// Login user
await SessionManager.authenticateAsUser(session: session);

// Check session
final session = await SessionManager.session();

// Logout
await SessionManager.clear();
```

📖 **[View Complete Documentation](docs/SESSIONS.md)**

---

### 🔄 State Management

Powerful state management built on **[Riverpod 3](https://pub.dev/packages/riverpod)** (v2.4.9) with **[riverpod_annotation](https://pub.dev/packages/riverpod_annotation)** code generation and enhanced widgets. JetPaginator uses **[infinite_scroll_pagination](https://pub.dev/packages/infinite_scroll_pagination)** (v4.0.0) for infinite scroll with any API format.

#### JetBuilder

```dart
// Simple list with pull-to-refresh
JetBuilder.list<Post>(
  provider: postsProvider,
  itemBuilder: (post, index) => PostCard(post: post),
)
```

#### JetPaginator

```dart
// Infinite scroll with any API format
JetPaginator.list<Product, Map<String, dynamic>>(
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
)
```

📖 **[View Complete Documentation](docs/STATE_MANAGEMENT.md)**

---

### 🔔 Notifications

Comprehensive local notification system built on **[flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)** (v16.3.0) with **[timezone](https://pub.dev/packages/timezone)** support for scheduling. Event-driven architecture with type-safe handlers, action buttons, and custom notification channels.

```dart
// Send notification
await JetNotifications.sendNotification(
  title: "Hello from Jet!",
  body: "This is a notification",
  payload: "notification_id",
);

// Schedule notification
await JetNotifications.sendNotification(
  title: "Reminder",
  body: "Don't forget!",
  at: DateTime.now().add(Duration(hours: 1)),
);

// Event-driven notifications
class OrderNotificationEvent extends JetNotificationEvent {
  @override
  Future<void> onTap(NotificationResponse response) async {
    final orderId = int.parse(response.payload ?? '0');
    router.push(OrderDetailsRoute(orderId: orderId));
  }
}
```

📖 **[View Complete Documentation](docs/NOTIFICATIONS.md)**

---

### 🐛 Debugging

Enhanced debugging tools with **[stack_trace](https://pub.dev/packages/stack_trace)** (v1.11.1) for better stack trace formatting and comprehensive logging utilities. Colored console output with clickable file paths and environment-aware logging.

```dart
// Stack trace debugging
try {
  riskyOperation();
} catch (error, stackTrace) {
  stackTrace.dump(title: 'Operation Failed');
}

// Enhanced logging
dump('Debug message', tag: 'DEBUG');
JetLogger.json(responseData);
```

📖 **[View Complete Documentation](docs/DEBUGGING.md)**

---

### 🛠 Helpers

Utility helpers for common development tasks.

```dart
// Generate test data
final username = JetFaker.username(); // "brave_tiger123"
final testUsers = List.generate(10, (_) => User(
  username: JetFaker.username(),
  email: '${JetFaker.username()}@test.com',
));
```

📖 **[View Complete Documentation](docs/HELPERS.md)**

---

## 🎯 Key Features Summary

- **🚀 Rapid Development** - Get started in minutes
- **📱 Modern Architecture** - Built on Riverpod 3
- **🔧 Type Safety** - Full type safety across the framework
- **🌐 Internationalization** - Built-in localization with RTL
- **🎨 Theming** - Complete theme management
- **🔐 Security** - App locking and secure storage
- **📝 Forms** - Advanced form management
- **🌐 Networking** - Type-safe HTTP client
- **🔄 State Management** - Enhanced Riverpod widgets
- **🔔 Notifications** - Event-driven notifications
- **🧩 Components** - Pre-built UI components

## 📖 Documentation

### Core Features
- [Configuration](docs/CONFIGURATION.md) - App configuration
- [Routing](docs/ROUTING.md) - Navigation and routing
- [Adapters](docs/ADAPTERS.md) - Framework extensions
- [Storage](docs/STORAGE.md) - Local storage
- [Theming](docs/THEMING.md) - Theme management
- [Localization](docs/LOCALIZATION.md) - Internationalization

### Advanced Features
- [Networking](docs/NETWORKING.md) - HTTP client
- [Error Handling](docs/ERROR_HANDLING.md) - Error management
- [Forms](docs/FORMS.md) - Form management, validation, and fields
- [Components](docs/COMPONENTS.md) - UI components
- [Dialogs & Sheets](docs/DIALOGS_AND_SHEETS.md) - Confirmation workflows

### Utilities
- [Extensions](docs/EXTENSIONS.md) - Utility extensions
- [Security](docs/SECURITY.md) - App security
- [Sessions](docs/SESSIONS.md) - Session management
- [State Management](docs/STATE_MANAGEMENT.md) - Riverpod integration
- [Notifications](docs/NOTIFICATIONS.md) - Local notifications
- [Debugging](docs/DEBUGGING.md) - Debugging tools
- [Helpers](docs/HELPERS.md) - Utility helpers

## 📚 Additional Resources

### Official Documentation
- [Riverpod Documentation](https://riverpod.dev/)
- [AutoRoute Documentation](https://auto-route.vercel.app/)
- [Dio Documentation](https://pub.dev/packages/dio)

### Learning Resources
- [Flutter Official Docs](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design 3](https://m3.material.io/)

## 🤝 Contributing

We welcome contributions! Please see our contributing guidelines for details.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
