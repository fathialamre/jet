# 🚀 Jet Framework

**Jet** is a lightweight, modular Flutter framework for scalable app architecture, providing dependency injection, lifecycle management, and streamlined setup for rapid development.

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

## Table of Contents

- [Configuration](#%EF%B8%8F-configuration)
- [Routing](#-routing)
- [Adapters](#-adapters)
- [Storage](#-storage)
- [Theming](#-theming)
- [Localization](#-localization)
- [Networking](#-networking)
- [Error Handling](#%EF%B8%8F-error-handling)
- [Forms](#-forms)
- [Components](#-components)
- [Actions](#-actions)
- [Sessions](#-sessions)
- [State Management](#-state-management)

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
}
```

**Configuration Properties:**
- `adapters` - Framework extensions (routing, API, analytics)
- `supportedLocales` - Supported languages with display names
- `theme` / `darkTheme` - App themes
- `defaultLocale` - Fallback locale
- `localizationsDelegates` - Custom localization delegates

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

**Features:**
- Built on Dio for robust networking
- Type-safe ResponseModel wrapper
- Singleton pattern for efficiency
- Automatic error handling integration
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
class LoginForm extends StatelessWidget {
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
```

### Registration Form Example

```dart
class RegistrationFormNotifier extends JetFormNotifier<RegistrationRequest, User> {
  RegistrationFormNotifier(super.ref);

  @override
  RegistrationRequest decoder(Map<String, dynamic> formData) {
    return RegistrationRequest.fromJson(formData);
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
      initialValues: {'agreeToTerms': false},
      onSuccess: (user, request) {
        context.router.pushNamed('/verify-email');
        context.showToast('Account created! Please verify your email.');
      },
      builder: (context, ref, form, state) => [
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
          keyboardType: TextInputType.emailAddress,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.email(),
          ]),
        ),

        // Phone field
        JetPhoneField(
          name: 'phone',
          hintText: 'Phone Number',
          isRequired: true,
        ),

        // Password field
        JetPasswordField(
          name: 'password',
          hintText: 'Password',
          formKey: _formKey,
        ),

        // Confirm password
        JetPasswordField(
          name: 'confirm_password',
          hintText: 'Confirm Password',
          identicalWith: 'password',
          formKey: _formKey,
        ),

        // Terms checkbox
        FormBuilderCheckbox(
          name: 'agreeToTerms',
          title: Text('I agree to the Terms of Service'),
          validator: FormBuilderValidators.equal(
            true,
            errorText: 'You must agree to the terms',
          ),
        ),

        // Submit button
        SizedBox(
          width: double.infinity,
          child: state.isLoading
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

### Form Validation & Error Handling

Forms automatically handle server-side validation errors:

```dart
// Server returns validation errors like:
// {
//   "message": "Validation failed",
//   "errors": {
//     "email": ["Email already exists"],
//     "password": ["Password too weak"]
//   }
// }

// JetFormBuilder automatically:
// 1. Shows field-specific errors under inputs
// 2. Displays general error message as toast
// 3. Highlights invalid fields
// 4. Preserves form data during errors

JetFormBuilder<LoginRequest, User>(
  provider: loginFormProvider,
  // Custom error handling
  onError: (error, stackTrace, invalidateFields) {
    if (error.toString().contains('account_locked')) {
      context.router.pushNamed('/account-locked');
    }
  },
  builder: (context, ref, form, state) => [
    // Form fields automatically show validation errors
  ],
)
```

**Form Features:**
- **Type-safe** form state with Request/Response generics
- **Automatic error handling** with field-level validation
- **Enhanced input components** (password, phone, etc.)
- **Built-in loading states** and form submission
- **Server validation integration** with automatic field invalidation
- **Riverpod integration** for reactive state management

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

## 🎯 Actions

JetAction provides a unified component for user interactions, supporting simple actions, confirmations, and complex forms:

### Simple Actions

Basic actions that execute immediately:

```dart
JetAction.action(
  text: 'Save Data',
  icon: Icons.save,
  onTap: () async {
    await saveUserData();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data saved successfully!')),
    );
  },
)

// Different button styles
JetAction.action(
  text: 'Share Content',
  icon: Icons.share,
  buttonType: JetButtonType.outlined,
  onTap: () => shareContent(),
)

// Full width action
JetAction.action(
  text: 'Submit Report',
  icon: Icons.send,
  buttonType: JetButtonType.filled,
  isExpanded: true,
  onTap: () => submitReport(),
)
```

### Confirmation Actions

Actions requiring user confirmation:

```dart
JetAction.confirmation(
  text: 'Delete Item',
  icon: Icons.delete,
  buttonType: JetButtonType.outlined,
  confirmationType: ConfirmationSheetType.error,
  confirmationTitle: 'Delete Confirmation',
  confirmationMessage: 'Are you sure you want to delete this item? This action cannot be undone.',
  onTap: () => deleteItem(),
)

// Warning confirmation
JetAction.confirmation(
  text: 'Clear Cache',
  icon: Icons.clear,
  confirmationType: ConfirmationSheetType.warning,
  confirmationTitle: 'Clear All Cache',
  confirmationMessage: 'This will clear all cached data. Continue?',
  onTap: () => clearCache(),
)
```

### Form Actions with JetForm Integration

Actions that open type-safe forms:

```dart
// Define form models and notifier first
@JsonSerializable()
class CommentRequest {
  final String title;
  final String description;
  final String priority;

  const CommentRequest({
    required this.title,
    required this.description,
    required this.priority,
  });
}

class CommentFormNotifier extends JetFormNotifier<CommentRequest, CommentResponse> {
  CommentFormNotifier(super.ref);

  @override
  CommentRequest decoder(Map<String, dynamic> formData) {
    return CommentRequest.fromJson(formData);
  }

  @override
  Future<CommentResponse> action(CommentRequest data) async {
    final api = ref.read(apiServiceProvider);
    return await api.createComment(data);
  }
}

final commentFormProvider = JetFormProvider<CommentRequest, CommentResponse>(
  (ref) => CommentFormNotifier(ref),
);

// Use with JetAction
JetAction<CommentRequest, CommentResponse>.jetForm(
  text: 'Add Comment',
  icon: Icons.comment,
  buttonType: JetButtonType.filled,
  formProvider: commentFormProvider,
  formTitle: 'Create New Comment',
  initialFormValues: {
    'priority': 'medium',
  },
  jetFormBuilder: (context, ref, form, state) => [
    FormBuilderTextField(
      name: 'title',
      decoration: InputDecoration(
        labelText: 'Title',
        hintText: 'Enter comment title',
        prefixIcon: Icon(Icons.title),
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.minLength(3),
        FormBuilderValidators.maxLength(100),
      ]),
    ),
    FormBuilderTextField(
      name: 'description',
      decoration: InputDecoration(
        labelText: 'Description',
        hintText: 'Enter comment description',
        prefixIcon: Icon(Icons.description),
      ),
      maxLines: 3,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.minLength(10),
      ]),
    ),
    FormBuilderDropdown(
      name: 'priority',
      decoration: InputDecoration(
        labelText: 'Priority',
        prefixIcon: Icon(Icons.priority_high),
      ),
      items: [
        DropdownMenuItem(value: 'low', child: Text('Low')),
        DropdownMenuItem(value: 'medium', child: Text('Medium')),
        DropdownMenuItem(value: 'high', child: Text('High')),
      ],
      validator: FormBuilderValidators.required(),
    ),
  ],
  onFormSuccess: (response, request) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Comment "${response.title}" created successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  },
)
```

### Action Types

| Constructor | Description | Use Case |
|-------------|-------------|----------|
| `action()` | Simple button action | Save, share, navigate |
| `confirmation()` | Action with confirmation dialog | Delete, clear, reset |
| `form()` | Legacy form action | Custom form widgets |
| `jetForm()` | Type-safe form action | Complex forms with validation |

**Action Features:**
- **Unified API** for all interaction patterns
- **Type-safe forms** with Request/Response generics  
- **Built-in confirmations** with different visual styles
- **Automatic loading states** during async operations
- **Form integration** with JetFormBuilder system
- **Customizable styling** and button types

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

### Session Model

```dart
class Session {
  final String token;
  final String name;
  final bool isGuest;
  final String? phone;

  Session({
    required this.token,
    required this.name,
    required this.isGuest,
    this.phone,
  });

  // Automatic JSON serialization for storage
  factory Session.fromJson(Map<String, dynamic> json) => Session(
    token: json['token'],
    name: json['name'],
    isGuest: json['is_guest'],
    phone: json['phone'],
  );

  Map<String, dynamic> toJson() => {
    'token': token,
    'name': name,
    'is_guest': isGuest,
    'phone': phone,
  };
}
```

### Auth Guard for Routes

Protect routes with authentication:

```dart
class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final session = JetStorage.getSession();
    
    if (session?.token != null && !session!.isGuest) {
      // User is authenticated, allow navigation
      resolver.next();
    } else {
      // Redirect to login
      router.push(LoginRoute());
    }
  }
}

// Use in router
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(
      page: DashboardRoute.page,
      path: '/dashboard',
      guards: [AuthGuard], // Protected route
    ),
  ];
}
```

### Complete Auth Example

```dart
class AuthService {
  final apiService = UserApiService.instance;

  Future<User> login(String email, String password) async {
    final response = await apiService.login(email, password);
    
    if (response.success && response.data != null) {
      // Create session
      final session = Session(
        token: response.data!.token,
        name: response.data!.name,
        isGuest: false,
        phone: response.data!.phone,
      );
      
      // Store session
      await SessionManager.authenticateAsUser(session: session);
      
      return response.data!;
    } else {
      throw JetError.client(message: response.message ?? 'Login failed');
    }
  }

  Future<void> logout() async {
    // Clear session
    await SessionManager.clear();
    
    // Navigate to login
    GetIt.instance<AppRouter>().pushAndClearStack(LoginRoute());
  }

  Future<bool> isAuthenticated() async {
    final session = await SessionManager.session();
    return session?.token != null && !session!.isGuest;
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

Jet provides powerful state management built on Riverpod with enhanced widgets for common patterns:

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
- Built on Riverpod for robust state management
- Unified JetBuilder for lists, grids, single items
- Family provider support for parameterized data
- Automatic pull-to-refresh functionality
- Infinite scroll pagination for any API
- Enhanced consumer widgets with Jet access
- Automatic error handling and loading states
