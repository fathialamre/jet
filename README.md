# 🚀 Jet Framework

**Jet** is a lightweight, modular Flutter framework for scalable app architecture, providing dependency injection, lifecycle management, and streamlined setup for rapid development. Built with **Riverpod 3** for enhanced state management and code generation capabilities.

## 📦 Installation

Add Jet to your Flutter project:

```yaml
dependencies:
  jet:
    path: packages/jet
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

## 📋 Table of Contents

- [Configuration](#%EF%B8%8F-configuration)
- [Routing](#-routing)
- [Adapters](#-adapters)
- [Storage](#-storage)
- [Caching](#-caching)
- [Theming](#-theming)
- [Localization](#-localization)
- [Networking](#-networking)
- [Error Handling](#%EF%B8%8F-error-handling)
- [Forms](#-forms)
- [Components](#-components)
- [Security](#-security)
- [Sessions](#-sessions)
- [State Management](#-state-management)
- [Notifications](#-notifications)
- [Debugging](#-debugging)

## ⚙️ Configuration

Extend `JetConfig` to configure your app:

```dart
class AppConfig extends JetConfig {
  @override
  List<JetAdapter> get adapters => [RouterAdapter()];

  @override
  List<LocaleInfo> get supportedLocales => [
    LocaleInfo(locale: const Locale('en'), displayName: 'English', nativeName: 'English'),
    LocaleInfo(locale: const Locale('ar'), displayName: 'Arabic', nativeName: 'العربية'),
  ];

  @override
  ThemeData? get theme => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  );

  @override
  ThemeData? get darkTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
  );

  @override
  JetDioLoggerConfig get dioLoggerConfig => JetDioLoggerConfig(
    request: true,
    requestHeader: true,
    requestBody: false,
    responseBody: true,
    responseHeader: false,
    error: true,
    compact: true,
    maxWidth: 90,
    enabled: true,
  );
}
```

**Configuration Properties:**
- `adapters` - Framework extensions (routing, API, analytics)
- `supportedLocales` - Supported languages with display names
- `theme` / `darkTheme` - App themes
- `defaultLocale` - Fallback locale
- `localizationsDelegates` - Custom localization delegates
- `dioLoggerConfig` - Network logging configuration

## 🧭 Routing

Jet uses **[AutoRoute](https://pub.dev/packages/auto_route)** for navigation. Create your router by extending `RootStackRouter`:

```dart
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, path: '/', initial: true),
    AutoRoute(page: ProfileRoute.page, path: '/profile'),
  ];
}

final appRouter = AutoDisposeProvider<AppRouter>((ref) => AppRouter());
```

**Navigation:**
```dart
// Navigate to a route
context.router.push(ProfileRoute());

// Navigate with parameters
context.router.pushNamed('/profile', extra: {'userId': 123});

// Go back
context.router.pop();
```

## 🔌 Adapters

Adapters integrate third-party services with Jet. All adapters implement `JetAdapter`:

```dart
abstract class JetAdapter {
  Future<Jet?> boot(Jet jet);
  Future<void> afterBoot(Jet jet);
}
```

**Router Adapter:**
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

**Custom Adapter Example:**
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
  }
}
```

## 💾 Storage

JetStorage provides secure local storage for lightweight data:

```dart
// Regular storage (SharedPreferences)
await JetStorage.write('user_name', 'John Doe');
String? name = JetStorage.read<String>('user_name');

// Secure storage (encrypted)
await JetStorage.writeSecure('auth_token', 'your-jwt-token');
String? token = await JetStorage.readSecure('auth_token');

// JSON objects
Map<String, dynamic> data = {'theme': 'dark', 'language': 'en'};
await JetStorage.write('settings', data);
Map<String, dynamic>? settings = JetStorage.read<Map<String, dynamic>>('settings');

// Management
await JetStorage.delete('user_name');
await JetStorage.clear(); // Clear all regular storage
await JetStorage.clearSecure(); // Clear all secure storage
```

**Features:**
- Type-safe read/write operations
- Encrypted secure storage for sensitive data
- JSON serialization support
- Default values and error handling

## 💾 Caching

Jet provides a powerful caching system built on **[Hive](https://pub.dev/packages/hive)** with TTL (Time To Live) support for efficient data management and offline capabilities.

### Setup

Add the cache adapter to your app configuration:

```dart
class AppConfig extends JetConfig {
  @override
  List<JetAdapter> get adapters => [
    RouterAdapter(),
    CacheAdapter(), // Add caching support
  ];
}
```

### Basic Caching

Cache data with automatic expiration:

```dart
// Cache data with 30-second TTL
await JetCache.write(
  'user_data',
  {'name': 'John Doe', 'email': 'john@example.com'},
  ttl: Duration(seconds: 30),
);

// Read cached data
final userData = await JetCache.read('user_data');
if (userData != null) {
  print('User: ${userData['name']}');
}

// Check if data exists and is not expired
final exists = await JetCache.exists('user_data');

// Delete specific cache entry
await JetCache.delete('user_data');
```

### Advanced Caching

Use different TTL strategies for different data types:

```dart
// User data - 30 seconds
await JetCache.write('user', userData, ttl: Duration(seconds: 30));

// Product list - 5 minutes
await JetCache.write('products', productsData, ttl: Duration(minutes: 5));

// App settings - 1 hour
await JetCache.write('settings', settingsData, ttl: Duration(hours: 1));

// Persistent data - no TTL
await JetCache.write('permanent_data', data); // Never expires
```

### Cache Management

Monitor and manage your cache:

```dart
// Get cache statistics
final stats = await JetCache.getStats();
print('Total entries: ${stats['totalEntries']}');
print('Valid entries: ${stats['validEntries']}');
print('Expired entries: ${stats['expiredEntries']}');

// Cleanup expired entries
final removedCount = await JetCache.cleanupExpired();
print('Removed $removedCount expired entries');

// Clear all cache
await JetCache.clear();
```

### Type-Safe Caching Service

Create a service layer for type-safe caching:

```dart
class CacheService {
  // Cache user with 30-second TTL
  static Future<void> cacheUser(User user) async {
    await JetCache.write(
      'user_data',
      user.toJson(),
      ttl: Duration(seconds: 30),
    );
  }

  // Get user from cache
  static Future<User?> getUser() async {
    final data = await JetCache.read('user_data');
    if (data == null) return null;
    return User.fromJson(data);
  }

  // Cache products with 5-minute TTL
  static Future<void> cacheProducts(List<Product> products) async {
    final data = {
      'products': products.map((p) => p.toJson()).toList(),
      'cachedAt': DateTime.now().millisecondsSinceEpoch,
    };
    await JetCache.write('products_list', data, ttl: Duration(minutes: 5));
  }

  // Get products from cache
  static Future<List<Product>?> getProducts() async {
    final data = await JetCache.read('products_list');
    if (data == null) return null;
    
    final productsData = data['products'] as List;
    return productsData
        .map((json) => Product.fromJson(json))
        .toList();
  }
}
```

### Cache with Auto-Refresh

Implement cache with automatic refresh when data expires:

```dart
class DataService {
  static Future<List<Product>> getProducts() async {
    return await JetCache.getOrRefresh<List<Product>>(
      'products',
      (data) => (data['products'] as List)
          .map((json) => Product.fromJson(json))
          .toList(),
      () async {
        // Refresh function - called when cache is empty/expired
        final api = ref.read(apiServiceProvider);
        final response = await api.getProducts();
        return {'products': response.map((p) => p.toJson()).toList()};
      },
      ttl: Duration(minutes: 5),
    );
  }
}
```

### Batch Operations

Perform multiple cache operations efficiently:

```dart
// Read multiple keys at once
final results = await CacheService.readMultiple([
  'user_data',
  'products_list',
  'settings',
]);

// Delete multiple keys
await CacheService.deleteMultiple([
  'old_user_data',
  'expired_products',
]);
```

### Cache Example

See the complete cache example in the example app:

```dart
// Navigate to cache example
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const CacheExamplePage(),
  ),
);
```

**Cache Features:**
- **TTL Support** - Automatic expiration with configurable timeouts
- **Hive Integration** - Fast, lightweight NoSQL database
- **Type Safety** - Full type safety with generic support
- **Automatic Cleanup** - Remove expired entries automatically
- **Statistics** - Monitor cache usage and performance
- **Batch Operations** - Efficient multi-key operations
- **Auto-Refresh** - Automatic data refresh when cache expires
- **Cross-Platform** - Works on all Flutter platforms
- **Persistence** - Data survives app restarts
- **Memory Efficient** - Optimized for mobile performance

## 🎨 Theming

Jet provides built-in theme management with persistent storage:

```dart
// Add theme toggle button
AppBar(
  actions: [
    ThemeSwitcher.toggleButton(context),
  ],
)

// Show theme selection modal
ThemeSwitcher.show(context);

// Segmented theme switcher
ThemeSwitcher.segmentedButton(context);
```

**Using with Riverpod:**
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

**Features:**
- Light, dark, and system theme modes
- Persistent theme storage
- Pre-built UI components
- Riverpod state management integration

## 🌍 Localization

Jet provides internationalization support with language switching:

```dart
// Add language switcher button
AppBar(
  actions: [
    LanguageSwitcher.toggleButton(),
  ],
)

// Show language selection modal
LanguageSwitcher.show(context);
```

**Using with Riverpod:**
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(languageSwitcherProvider);
    final localeNotifier = ref.read(languageSwitcherProvider.notifier);
    
    return ElevatedButton(
      onPressed: () => localeNotifier.changeLocale(Locale('ar')),
      child: Text('Switch to Arabic'),
    );
  }
}
```

**Features:**
- Persistent locale storage
- Built-in UI components
- RTL support
- Riverpod state management integration

## 🌐 Networking

Jet provides a type-safe HTTP client built on **[Dio](https://pub.dev/packages/dio)**:

```dart
class UserApiService extends JetApiService {
  @override
  String get baseUrl => 'https://api.example.com/v1';

  @override
  Map<String, dynamic> get defaultHeaders => {
    ...super.defaultHeaders,
    'Authorization': 'Bearer ${getToken()}',
  };

  static UserApiService get instance => getInstance('UserApiService', () => UserApiService());

  Future<ResponseModel<List<User>>> getUsers() async {
    return await get<List<User>>(
      '/users',
      decoder: (data) => (data as List).map((json) => User.fromJson(json)).toList(),
    );
  }

  Future<ResponseModel<User>> createUser(CreateUserRequest request) async {
    return await post<User>(
      '/users',
      data: request.toJson(),
      decoder: (data) => User.fromJson(data),
    );
  }
}
```

### Network Logging Configuration

Jet provides configurable request/response logging through `JetDioLoggerConfig`:

```dart
class AppConfig extends JetConfig {
  @override
  JetDioLoggerConfig get dioLoggerConfig => JetDioLoggerConfig(
    request: true,          // Log requests
    requestHeader: true,    // Log request headers
    requestBody: false,     // Log request body (disable for security)
    responseBody: true,     // Log response body
    responseHeader: false,  // Log response headers
    error: true,           // Log errors
    compact: true,         // Compact JSON output
    maxWidth: 90,          // Console width
    enabled: true,         // Enable/disable logging
  );
}
```

**Features:**
- Built on Dio for robust networking
- Type-safe ResponseModel wrapper
- Singleton pattern for efficiency
- Automatic error handling integration
- **Configurable request/response logging**
- **Network debugging and monitoring**
- Custom interceptors support

## ⚠️ Error Handling

Jet provides comprehensive error handling with JetError:

```dart
// Error types
final networkError = JetError.noInternet();
final serverError = JetError.server(message: 'Server error', statusCode: 500);
final validationError = JetError.validation(errors: {
  'email': ['Email is required', 'Invalid email format'],
});

// Usage
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

**Features:**
- Automatic error categorization (network, server, validation, etc.)
- User-friendly error messages
- Integration with forms and networking
- Type-safe error handling

## 📝 Forms

Jet provides type-safe form management with JetFormBuilder and enhanced input components:

### Complete Form Example

```dart
// 1. Define request/response models
@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginRequest({
    required this.email,
    required this.password,
    required this.rememberMe,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

// 2. Create form notifier
class LoginFormNotifier extends JetFormNotifier<LoginRequest, User> {
  LoginFormNotifier(super.ref);

  @override
  LoginRequest decoder(Map<String, dynamic> formData) {
    return LoginRequest.fromJson(formData);
  }

  @override
  Future<User> action(LoginRequest data) async {
    final authService = ref.read(authServiceProvider);
    return await authService.login(data.email, data.password);
  }
}

// 3. Create provider
final loginFormProvider = JetFormProvider<LoginRequest, User>(
  (ref) => LoginFormNotifier(ref),
);

// 4. Build form UI
class LoginFormWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetFormBuilder<LoginRequest, User>(
      provider: loginFormProvider,
      onSuccess: (user, request) {
        context.router.pushNamed('/dashboard');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome back, ${user.name}!')),
        );
      },
      builder: (context, ref, form, state) => [
        // Email field
        FormBuilderTextField(
          name: 'email',
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.email(),
          ]),
        ),

        // Enhanced password field
        JetPasswordField(
          name: 'password',
          hintText: 'Password',
          isRequired: true,
        ),

        // Remember me checkbox
        FormBuilderCheckbox(
          name: 'rememberMe',
          title: Text('Remember me'),
          initialValue: false,
        ),

        // Submit button with automatic loading state
        SizedBox(
          width: double.infinity,
          child: state.isLoading
              ? Center(child: CircularProgressIndicator())
              : JetButton(
                  text: 'Sign In',
                  onTap: form.submit,
                ),
        ),
      ],
    );
  }
}
```

### Enhanced Form Inputs

Jet provides specialized input components with built-in validation:

```dart
// Password field with visibility toggle
JetPasswordField(
  name: 'password',
  hintText: 'Enter your password',
  isRequired: true,
  showPrefixIcon: true,
  validator: FormBuilderValidators.compose([
    FormBuilderValidators.required(),
    FormBuilderValidators.minLength(8),
  ]),
)

// Password confirmation field
JetPasswordField(
  name: 'confirm_password',
  hintText: 'Confirm password',
  identicalWith: 'password', // Must match password field
  formKey: formKey, // Required for confirmation
  isRequired: true,
)

// Phone number field with validation
JetPhoneField(
  name: 'phone',
  hintText: 'Phone number',
  isRequired: true,
  showPrefixIcon: true,
  validator: FormBuilderValidators.compose([
    FormBuilderValidators.required(),
    FormBuilderValidators.minLength(10),
    FormBuilderValidators.numeric(),
  ]),
)

// PIN/OTP field with customizable appearance
JetPinField(
  name: 'otp',
  length: 6,
  isRequired: true,
  autofocus: true,
  spacing: 12.0,
  onCompleted: (pin) {
    // Auto-submit when PIN is complete
    formKey.currentState?.save();
  },
  onSubmitted: (pin) => verifyOTP(pin),
)
```

### Riverpod 3 Generators Support

Jet Framework fully supports **Riverpod 3 generators** for enhanced developer experience and code generation:

```dart
// Add to your pubspec.yaml
dependencies:
  riverpod: ^3.0.0
  riverpod_annotation: ^3.0.0

dev_dependencies:
  riverpod_generator: ^3.0.0
  build_runner: ^2.4.7

// Enable code generation
@riverpod
class UserForm extends _$UserForm implements JetFormNotifier<UserRequest, User> {
  @override
  UserRequest decoder(Map<String, dynamic> formData) {
    return UserRequest.fromJson(formData);
  }

  @override
  Future<User> action(UserRequest data) async {
    final apiService = ref.read(userApiServiceProvider);
    return await apiService.createUser(data);
  }
}

// Generated provider automatically available as: userFormProvider
class UserFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetFormBuilder<UserRequest, User>(
      provider: userFormProvider, // Generated provider
      builder: (context, ref, form, state) => [
        // Your form fields
      ],
    );
  }
}

// Run code generation
// dart run build_runner build
```

**Form Features:**
- **Type-safe** form state with Request/Response generics
- **Enhanced error handling** with centralized JetErrorHandler integration
- **Automatic field invalidation** for server-side validation errors
- **Enhanced input components** (password, phone, PIN/OTP)
- **Built-in loading states** and form submission
- **Server validation integration** with automatic field invalidation
- **Riverpod 3 integration** with generator support for reactive state management

## 🧩 Components

### JetButton

Modern button component with loading states:

```dart
JetButton(
  text: 'Submit',
  onTap: () async {
    await submitData();
  },
)

// Different styles
JetButton.filled(text: 'Filled Button', onTap: () {});
JetButton.outlined(text: 'Outlined Button', onTap: () {});
JetButton.textButton(text: 'Text Button', onTap: () {});
```

### JetTab

Customizable tab widget with AutoRoute integration:

```dart
// Simple tabs
JetTab.simple(
  tabs: ['Home', 'Profile', 'Settings'],
  children: [HomeView(), ProfileView(), SettingsView()],
)

// AutoRoute tabs
JetTab.router(
  routes: [HomeRoute(), ProfileRoute(), SettingsRoute()],
  tabs: ['Home', 'Profile', 'Settings'],
)
```

**Features:**
- Material and Cupertino button styles
- Automatic loading states for async operations
- Tab navigation with AutoRoute support
- Customizable styling and animations

## 🔐 Security

Jet provides built-in security features for protecting your application:

### App Locker

Secure your app with biometric authentication using the Guardo package:

```dart
// Configuration in your app
class AppWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lockState = ref.watch(appLockProvider);
    
    return MaterialApp.router(
      // Your app configuration
      builder: (context, child) {
        return Guardo(
          enabled: lockState, // App will lock when enabled
          child: child!,
        );
      },
    );
  }
}
```

**Using App Locker:**

```dart
// Toggle app lock with biometric authentication
class SecuritySettings extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLocked = ref.watch(appLockProvider);
    final lockNotifier = ref.read(appLockProvider.notifier);
    
    return SwitchListTile(
      title: Text('App Lock'),
      subtitle: Text('Require biometric authentication to open app'),
      value: isLocked,
      onChanged: (enabled) {
        lockNotifier.toggle(context, forceLock: enabled);
      },
    );
  }
}

// Manually lock the app
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.lock),
            onPressed: () => context.lockApp(),
          ),
        ],
      ),
    );
  }
}
```

**Security Features:**
- **Biometric authentication** using device fingerprint/face recognition
- **Persistent lock state** stored securely
- **Auto-lock functionality** when app becomes inactive
- **Force lock option** for immediate protection
- **Integration with device security** settings

## 🔐 Sessions

Jet provides built-in session management for user authentication:

### Session Manager

Handle user authentication and session storage:

```dart
// User login
final user = await authService.login(email, password);
final session = Session(
  token: user.token,
  name: user.name,
  isGuest: false,
  phone: user.phone,
);

await SessionManager.authenticateAsUser(session: session);

// Guest login
await SessionManager.loginAsGuest();

// Check session status
final currentSession = await SessionManager.session();
final token = await SessionManager.token();
final isGuest = await SessionManager.isGuest();

// Logout
await SessionManager.clear();
```

### Auth Provider Integration

Use with Riverpod for reactive authentication state:

```dart
// Auth provider (built into Jet)
final authProvider = StateNotifierProvider<Auth, AsyncValue<Session?>>(
  (ref) {
    final Session? session = JetStorage.getSession();
    final state = AsyncValue.data(session);
    return Auth(state);
  },
);

// Using in widgets
class AppWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return authState.when(
      data: (session) {
        if (session?.token != null) {
          return DashboardPage(); // User is logged in
        } else {
          return LoginPage(); // User is not logged in
        }
      },
      loading: () => SplashScreen(),
      error: (error, stack) => ErrorPage(),
    );
  }
}
```

**Session Features:**
- **Built-in session management** with secure storage
- **Auth provider** for reactive authentication state
- **Guest and user sessions** support
- **Route protection** with auth guards
- **Automatic persistence** with JetStorage integration
- **Token management** and session validation

## 🔄 State Management

Jet provides powerful state management built on **Riverpod 3** with enhanced widgets for common patterns and code generation support:

### JetBuilder - Unified State Widget

Handle lists, grids, and single items with automatic loading/error states:

```dart
// Provider definition
final postsProvider = AutoDisposeFutureProvider<List<Post>>((ref) async {
  final api = ref.read(apiServiceProvider);
  return await api.getAllPosts();
});

// Simple list with pull-to-refresh
class PostsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JetBuilder.list<Post>(
        provider: postsProvider,
        itemBuilder: (post, index) => ListTile(
          title: Text(post.title),
          subtitle: Text(post.excerpt),
          onTap: () => context.router.push(PostDetailsRoute(post: post)),
        ),
        // Built-in pull-to-refresh, loading, and error handling
      ),
    );
  }
}
```

### Family Providers for Parameters

Use family providers for parameterized data:

```dart
// Family provider for category-based posts
final postsByCategoryProvider = AutoDisposeFutureProvider.family<List<Post>, String>(
  (ref, categoryId) async {
    final api = ref.read(apiServiceProvider);
    return await api.getPostsByCategory(categoryId);
  },
);

// Using family providers
class CategoryPostsList extends StatelessWidget {
  final String categoryId;
  
  @override
  Widget build(BuildContext context) {
    return JetBuilder.familyList<Post, String>(
      provider: postsByCategoryProvider,
      param: categoryId,
      itemBuilder: (post, index) => PostCard(
        post: post,
        onLike: () => _toggleLike(post.id),
      ),
    );
  }
}
```

### Riverpod 3 Generators for Providers

Use the new generator syntax for cleaner provider definitions:

```dart
// Traditional approach
final postsProvider = AutoDisposeFutureProvider<List<Post>>((ref) async {
  final api = ref.read(apiServiceProvider);
  return await api.getAllPosts();
});

// Riverpod 3 Generator approach (Recommended)
@riverpod
Future<List<Post>> posts(PostsRef ref) async {
  final api = ref.read(apiServiceProvider);
  return await api.getAllPosts();
}

// Family provider with generators
@riverpod
Future<List<Post>> postsByCategory(PostsByCategoryRef ref, String categoryId) async {
  final api = ref.read(apiServiceProvider);
  return await api.getPostsByCategory(categoryId);
}

// Using generated providers
class PostsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetBuilder.list<Post>(
      provider: postsProvider, // Generated provider
      itemBuilder: (post, index) => PostCard(post: post),
    );
  }
}
```

### Grid Layouts

Create responsive grids with JetBuilder:

```dart
class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetBuilder.grid<Product>(
      provider: productsProvider,
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
      itemBuilder: (product, index) => Card(
        child: Column(
          children: [
            Image.network(product.imageUrl),
            Text(product.name),
            Text('\$${product.price}'),
            ElevatedButton(
              onPressed: () => _addToCart(product),
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.75,
    );
  }
}
```

### JetPaginator - Infinite Scroll

Powerful pagination that works with any API format:

```dart
class InfiniteProductsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetPaginator.list<Product, Map<String, dynamic>>(
      fetchPage: (pageKey) async {
        // Works with any API format
        final response = await api.getProducts(skip: pageKey as int, limit: 20);
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
      firstPageKey: 0,
      enablePullToRefresh: true,
    );
  }
}
```

### JetConsumerWidget - Enhanced Consumer

Access both Riverpod and Jet framework:

```dart
class DashboardPage extends JetConsumerWidget {
  @override
  Widget jetBuild(BuildContext context, WidgetRef ref, Jet jet) {
    final user = ref.watch(userProvider);
    final router = jet.router;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () => router.push(SettingsRoute()),
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: user.when(
        data: (userData) => Column(
          children: [
            UserHeader(user: userData),
            Expanded(
              child: JetBuilder.list<Activity>(
                provider: userActivitiesProvider(userData.id),
                itemBuilder: (activity, index) => ActivityCard(activity: activity),
              ),
            ),
          ],
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorWidget(error: error.toString()),
      ),
    );
  }
}
```

**State Management Features:**
- Built on **Riverpod 3** for robust state management with code generation
- **Generator support** for cleaner provider definitions and better performance
- **Automatic provider creation** with `@riverpod` annotation
- Unified JetBuilder for lists, grids, single items
- Family provider support for parameterized data
- Automatic pull-to-refresh functionality
- Infinite scroll pagination for any API
- Enhanced consumer widgets with Jet access
- **Type-safe provider dependencies** with compile-time checks
- **Hot reload support** for generated providers
- Automatic error handling and loading states

## 🔔 Notifications

Jet provides a comprehensive local notification system built on **[flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)** with advanced event handling, type-safe configuration, and intelligent notification management.

### Setup

Add the notifications adapter to your app configuration:

```dart
class AppConfig extends JetConfig {
  @override
  List<JetAdapter> get adapters => [
    RouterAdapter(),
    NotificationsAdapter(), // Add notifications support
  ];
}
```

### Basic Notifications

Send simple notifications with minimal setup:

```dart
// Send immediate notification
await JetNotifications.sendNotification(
  title: "Hello from Jet!",
  body: "This is a simple notification from the Jet framework.",
  payload: "simple_notification",
);

// Send with custom channel
await JetNotifications.sendNotification(
  title: "Custom Channel",
  body: "Notification with custom channel settings.",
  channelId: "custom_channel",
  channelName: "Custom Notifications",
  channelDescription: "Notifications with custom styling",
  payload: "custom_notification",
);
```

### Scheduled Notifications

Schedule notifications for future delivery:

```dart
// Schedule notification for 5 seconds from now
final scheduledTime = DateTime.now().add(const Duration(seconds: 5));

await JetNotifications.sendNotification(
  title: "Scheduled Notification",
  body: "This notification was scheduled for 5 seconds from now.",
  at: scheduledTime,
  payload: "scheduled_notification",
);

// Schedule daily notification at 9 AM
final dailyTime = Time(9, 0, 0);
await JetNotifications.scheduleDailyNotification(
  title: "Daily Reminder",
  body: "Don't forget to check your tasks!",
  time: dailyTime,
  payload: "daily_reminder",
);
```

### Advanced Notifications

Create rich notifications with actions, styling, and custom behavior:

```dart
await JetNotifications.sendNotification(
  title: "Advanced Notification",
  body: "This notification has custom styling and actions.",
  subtitle: "Jet Framework Demo",
  payload: "advanced_notification",
  channelId: "advanced_channel",
  channelName: "Advanced Notifications",
  channelDescription: "Notifications with custom styling",
  importance: Importance.high,
  priority: Priority.high,
  color: Colors.blue,
  actions: [
    const AndroidNotificationAction(
      'reply',
      'Reply',
    ),
    const AndroidNotificationAction(
      'dismiss',
      'Dismiss',
    ),
  ],
);
```

### Notification Management

Control and manage your notifications:

```dart
// Cancel specific notification
await JetNotifications.cancelNotification(notificationId);

// Cancel all notifications
await JetNotifications.cancelAllNotifications();

// Get pending notifications
final pendingNotifications = await JetNotifications.getPendingNotifications();

// Check if notifications are enabled
final isEnabled = await JetNotifications.isNotificationEnabled();
```

### Notification Observer

Customize notification event handling with the observer pattern:

```dart
class CustomNotificationObserver extends JetNotificationObserver {
  @override
  void onEventHandlerFound({
    required String eventName,
    required int notificationId,
    required NotificationResponse response,
  }) {
    // Custom logging or analytics
    analytics.track('notification_handled', {
      'event_name': eventName,
      'notification_id': notificationId,
    });
  }

  @override
  void onError({required String message, Object? error}) {
    // Custom error handling
    crashlytics.recordError(error, null, fatal: false);
  }
}

// Set custom observer
JetNotifications.setObserver(CustomNotificationObserver());
```

### Platform-Specific Features

#### Android Configuration

Add required permissions to your `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

#### iOS Configuration

Add notification capabilities in your `ios/Runner/Info.plist`:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

### Notification Channels (Android)

Create and manage notification channels for better user control:

```dart
// Create custom channel
await JetNotifications.createNotificationChannel(
  channelId: 'important_channel',
  channelName: 'Important Notifications',
  channelDescription: 'Critical app notifications',
  importance: Importance.high,
  enableVibration: true,
  enableLights: true,
  ledColor: Colors.red,
  playSound: true,
);

// Send notification to specific channel
await JetNotifications.sendNotification(
  title: "Important Update",
  body: "Your app has been updated!",
  channelId: "important_channel",
  payload: "app_update",
);
```

### Notification Icons

Customize notification icons for your app:

```dart
// Android notification icon (drawable resource)
await JetNotifications.sendNotification(
  title: "Custom Icon",
  body: "Notification with custom icon",
  smallIcon: 'ic_notification', // Drawable resource name
  largeIcon: 'ic_large_notification', // Drawable resource name
  payload: "custom_icon",
);

// iOS notification icon (app icon is used by default)
// Custom icons can be set in iOS project settings
```

### Event Categories and Priorities

Organize notifications by categories and priorities:

```dart
enum NotificationPriority {
  low,      // Background updates, non-urgent
  normal,   // Regular notifications
  high,     // Important updates
  critical, // Urgent, requires immediate attention
}

// Events automatically inherit priority and category settings
class CriticalAlertEvent extends JetNotificationEvent {
  @override
  NotificationPriority get priority => NotificationPriority.critical;
  
  @override
  String? get category => 'alerts';
}
```

### Event-Driven Notifications

Jet's notification system is built around **JetNotificationEvent** - a powerful abstraction that provides type-safe, event-driven notification handling:

#### Creating Notification Events

```dart
class OrderNotificationEvent extends JetNotificationEvent {
  @override
  int get id => 1;

  @override
  String get name => 'OrderNotification';

  @override
  String? get category => 'orders';

  @override
  NotificationPriority get priority => NotificationPriority.high;

  @override
  bool validatePayload(String? payload) {
    if (payload == null || payload.isEmpty) return false;
    try {
      final orderId = int.parse(payload);
      return orderId > 0;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> onTap(NotificationResponse response) async {
    dump('Order notification tapped: ${response.payload}');
    
    final orderId = int.parse(response.payload ?? '0');
    // Navigate to order details
    // context.router.push(OrderDetailsRoute(orderId: orderId));
  }

  @override
  Future<void> onReceive(NotificationResponse response) async {
    dump('🎯 ORDER NOTIFICATION RECEIVED: ${response.payload}');
    
    final orderId = int.parse(response.payload ?? '0');
    // Update app state
    // ref.read(orderProvider.notifier).updateOrderStatus(orderId);
  }

  @override
  Future<void> onAction(NotificationResponse response, String actionId) async {
    final orderId = int.parse(response.payload ?? '0');
    
    switch (actionId) {
      case 'view_order':
        await onTap(response);
        break;
      case 'track_order':
        // Navigate to tracking page
        break;
      case 'cancel_order':
        // Show cancellation dialog
        break;
    }
  }

  @override
  Future<void> onDismiss(NotificationResponse response) async {
    dump('Order notification dismissed: ${response.payload}');
    // Mark as dismissed in app state
  }

  /// Get notification actions for this event type
  List<AndroidNotificationAction> get notificationActions => [
    const AndroidNotificationAction(
      'view_order',
      'View Order',
      icon: DrawableResourceAndroidBitmap('ic_view'),
    ),
    const AndroidNotificationAction(
      'track_order',
      'Track Order',
      icon: DrawableResourceAndroidBitmap('ic_track'),
    ),
    const AndroidNotificationAction(
      'cancel_order',
      'Cancel Order',
      icon: DrawableResourceAndroidBitmap('ic_cancel'),
    ),
  ];
}
```

#### Registering Events in App Configuration

**Important:** You must register your custom notification events in your app configuration file:

```dart
// In your app.dart config file
class AppConfig extends JetConfig {
  @override
  List<JetAdapter> get adapters => [
    RouterAdapter(),
    NotificationsAdapter(),
  ];

  @override
  List<JetNotificationEvent> get notificationEvents => [
    OrderNotificationEvent(),
    PaymentNotificationEvent(),
    MessageNotificationEvent(),
    // Add your custom events here
  ];
}
```

#### Manual Event Registration (Alternative)

You can also register events manually if needed:

```dart
// Register individual events
JetNotificationEventRegistry.register(OrderNotificationEvent());
JetNotificationEventRegistry.register(PaymentNotificationEvent());
JetNotificationEventRegistry.register(MessageNotificationEvent());

// Register multiple events at once
JetNotificationEventRegistry.registerAll([
  OrderNotificationEvent(),
  PaymentNotificationEvent(),
  MessageNotificationEvent(),
]);

// Get events by category
final orderEvents = JetNotificationEventRegistry.getEventsByCategory('orders');

// Get specific event by ID
final orderEvent = JetNotificationEventRegistry.getEvent(1);
```

#### Notification Configuration

Use **NotificationEventConfig** for fine-grained control over notification behavior:

```dart
// Default configuration
final defaultConfig = NotificationEventConfig.defaultFor(orderEvent);

// High priority configuration
final highPriorityConfig = NotificationEventConfig.highPriority(orderEvent);

// Low priority configuration  
final lowPriorityConfig = NotificationEventConfig.lowPriority(orderEvent);

// Silent configuration
final silentConfig = NotificationEventConfig.silent(orderEvent);

// Custom configuration
final customConfig = NotificationEventConfig(
  event: orderEvent,
  androidChannelId: 'orders_critical',
  androidChannelName: 'Critical Orders',
  androidChannelDescription: 'Urgent order notifications',
  androidImportance: Importance.max,
  androidPriority: Priority.max,
  androidColor: Colors.red,
  androidActions: orderEvent.notificationActions,
  iosInterruptionLevel: InterruptionLevel.critical,
  showInForeground: true,
  showInBackground: true,
  showWhenTerminated: true,
  enableLights: true,
  enableVibration: true,
);
```

**Advanced Notification Features:**
- **Event-driven architecture** with type-safe notification handling
- **Intelligent event registry** for automatic event discovery and management
- **Flexible configuration system** with pre-built priority configurations
- **Observer pattern** for custom event handling and analytics
- **Payload validation** with automatic error handling
- **Action button support** with custom handlers
- **Category-based organization** for better notification management
- **Priority-aware delivery** with platform-specific optimizations
- **Background processing** support for reliable delivery
- **Cross-platform compatibility** with unified API
- **Comprehensive logging** with structured debug output

## 🐛 Debugging

Jet provides enhanced debugging tools for better development experience:

### Stack Trace Debugging

Enhanced stack trace formatting with clickable file paths:

```dart
// Using the global dumpTrace function
try {
  riskyOperation();
} catch (error, stackTrace) {
  // Dump stack trace with custom title
  dumpTrace(
    stackTrace,
    title: 'Operation Failed',
    alwaysPrint: true,
  );
}

// Using stack trace extension
void problematicFunction() {
  try {
    complexOperation();
  } catch (error, stackTrace) {
    // Enhanced stack trace logging
    stackTrace.dump(title: 'Complex Operation Error');
    
    // Legacy logging (still supported)
    stackTrace.log(tag: 'Error');
  }
}
```

**Stack Trace Output Example:**
```
╔╣ JET STACK TRACE ╠══
╠══════════════
╠╣ [ 1 ] -> main.<anonymous closure> ╠══
╠ LINE [23] COLUMN [5]
╠ At example_test.dart
╠ "example_test.dart:23:5"
╚════════════════════════
```

### Enhanced Logging

Comprehensive logging utilities for debugging:

```dart
// Basic logging
JetLogger.debug('Debug message');
JetLogger.info('Information message');
JetLogger.error('Error occurred');

// Custom tagged logging
JetLogger.dump('Custom data', tag: 'API_RESPONSE');

// JSON logging
final userData = {'name': 'John', 'age': 30};
JetLogger.json(userData);

// Global helpers
dump('Quick debug message', tag: 'DEBUG');
dd('Debug and die', tag: 'FATAL'); // Exits after logging
```

**Logging Features:**
- **Environment-aware logging** (debug mode only by default)
- **Structured output** with timestamps and tags
- **JSON serialization** for complex objects
- **Stack trace integration** with clickable file paths
- **Customizable log levels** and output formatting

## 🎯 Key Features Summary

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

## 📚 Additional Resources

- [Riverpod Documentation](https://riverpod.dev/)
- [AutoRoute Documentation](https://auto-route.vercel.app/)
- [Dio Documentation](https://pub.dev/packages/dio)
- [Flutter Form Builder](https://pub.dev/packages/flutter_form_builder)
- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)

## 🤝 Contributing

We welcome contributions! Please see our contributing guidelines for details.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.