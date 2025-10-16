# Sessions Documentation

Complete guide to session management in the Jet framework.

## Overview

Jet provides built-in session management for user authentication with secure storage using **[flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)** and reactive state management through Riverpod. The system handles user sessions, guest sessions, authentication tokens, and automatic session persistence.

**Packages Used:**
- **flutter_secure_storage** - ^9.0.0 - [pub.dev](https://pub.dev/packages/flutter_secure_storage) - Encrypted storage for session data
- **riverpod** - ^2.4.9 - [pub.dev](https://pub.dev/packages/riverpod) - Reactive state management for auth state

**Key Benefits:**
- ✅ Secure storage for authentication tokens
- ✅ Automatic session persistence across app restarts
- ✅ Reactive authentication state with Riverpod
- ✅ Guest and user session support
- ✅ Route guards for protected routes
- ✅ Automatic token refresh integration
- ✅ Session expiry handling
- ✅ Multi-account support potential

## SessionManager

### User Login

```dart
// Login user
final user = await authService.login(email, password);
final session = Session(
  token: user.token,
  name: user.name,
  isGuest: false,
  phone: user.phone,
  email: user.email,
);

await SessionManager.authenticateAsUser(session: session);
```

### Guest Login

```dart
// Login as guest
await SessionManager.loginAsGuest();
```

### Check Session Status

```dart
// Get current session
final currentSession = await SessionManager.session();

// Get token
final token = await SessionManager.token();

// Check if guest
final isGuest = await SessionManager.isGuest();

// Check if authenticated
if (currentSession?.token != null) {
  // User is logged in
}
```

### Logout

```dart
// Clear session
await SessionManager.clear();

// Optionally clear all secure storage
await JetStorage.clearSecure();

// Navigate to login
context.router.pushNamed('/login');
```

## Auth Provider Integration

Use with Riverpod for reactive authentication state.

### Built-in Auth Provider

```dart
// Auth provider (built into Jet)
final authProvider = StateNotifierProvider<Auth, AsyncValue<Session?>>(
  (ref) {
    final Session? session = JetStorage.getSession();
    final state = AsyncValue.data(session);
    return Auth(state);
  },
);
```

### Using in Widgets

```dart
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

### Auth Guard for Routes

```dart
class AuthGuard extends AutoRouteGuard {
  final Ref ref;

  AuthGuard(this.ref);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final session = ref.read(authProvider).value;
    
    if (session?.token != null) {
      // User is authenticated
      resolver.next();
    } else {
      // Redirect to login
      router.push(LoginRoute());
    }
  }
}
```

## Session Model

```dart
class Session {
  final String? token;
  final String? name;
  final String? email;
  final String? phone;
  final bool isGuest;
  
  const Session({
    this.token,
    this.name,
    this.email,
    this.phone,
    this.isGuest = false,
  });
}
```

## Features

- ✅ **Built-in session management** - Secure storage
- ✅ **Auth provider** - Reactive authentication state
- ✅ **Guest and user sessions** - Support for both
- ✅ **Route protection** - Auth guards
- ✅ **Automatic persistence** - JetStorage integration
- ✅ **Token management** - Session validation

## Best Practices

### 1. Store Tokens Securely

```dart
// Good - secure storage
final session = Session(token: token, ...);
await SessionManager.authenticateAsUser(session: session);

// Avoid - storing tokens in regular storage
await JetStorage.write('token', token);
```

### 2. Clear All Data on Logout

```dart
Future<void> logout() async {
  await SessionManager.clear();
  await JetStorage.clearSecure();
  ref.invalidate(authProvider);
  context.router.pushNamed('/login');
}
```

### 3. Check Authentication Before Accessing Protected Resources

```dart
final session = await SessionManager.session();
if (session?.token == null) {
  context.router.pushNamed('/login');
  return;
}

// Proceed with protected action
await api.getProtectedData();
```

## See Also

- [Security Documentation](SECURITY.md)
- [Storage Documentation](STORAGE.md)
- [Routing Documentation](ROUTING.md)

