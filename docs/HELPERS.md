# Helpers Documentation

Complete guide to utility helpers in the Jet framework.

## Overview

Jet provides development utilities for debugging and productivity, focusing on monitoring state changes and improving the development experience. These helpers are designed to provide deep insights into your application's behavior during development.

**Packages Used:**
- Riverpod - State management observation

**Key Benefits:**
- ✅ Real-time state monitoring
- ✅ Debug provider lifecycle
- ✅ Track state changes
- ✅ Identify performance issues
- ✅ Development productivity
- ✅ Seamless integration

## LoggerObserver - Provider State Monitoring

Monitor and debug Riverpod provider state changes in real-time.

### Basic Setup

```dart
import 'package:jet/jet.dart';

void main() {
  runApp(
    ProviderScope(
      observers: [LoggerObserver()],
      child: MyApp(),
    ),
  );
}
```

### What It Monitors

The LoggerObserver tracks three key events:

1. **Provider Addition** - When a provider is first accessed
2. **Provider Updates** - When provider state changes
3. **Provider Disposal** - When a provider is disposed

### Example Output

```dart
// Counter provider example
final counterProvider = StateProvider<int>((ref) => 0);

// When first accessed:
// [Provider Added] StateProvider<int> = 0

// When incremented:
// [Provider Updated] StateProvider<int> from 0 to 1

// When app closes:
// [Provider Disposed] StateProvider<int>
```

### Real-World Example

```dart
// User authentication state
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// Console output during authentication:
// [Provider Added] StateNotifierProvider<AuthNotifier, AuthState> = AuthState.unauthenticated
// [Provider Updated] StateNotifierProvider<AuthNotifier, AuthState> from AuthState.unauthenticated to AuthState.loading
// [Provider Updated] StateNotifierProvider<AuthNotifier, AuthState> from AuthState.loading to AuthState.authenticated(User)
```

### Custom Provider Names

For better debugging, name your providers:

```dart
final userProfileProvider = FutureProvider.autoDispose
    .family<UserProfile, String>((ref, userId) async {
  // Fetch user profile
}, name: 'UserProfile');

// Output:
// [Provider Added] UserProfile = AsyncLoading
// [Provider Updated] UserProfile from AsyncLoading to AsyncData(UserProfile)
```

## Advanced Usage

### Conditional Logging

Enable only in debug mode:

```dart
void main() {
  runApp(
    ProviderScope(
      observers: kDebugMode ? [LoggerObserver()] : [],
      child: MyApp(),
    ),
  );
}
```

### Custom Observer

Extend LoggerObserver for custom behavior:

```dart
class CustomLoggerObserver extends LoggerObserver {
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    // Custom filtering
    if (context.provider.name?.contains('auth') ?? false) {
      super.didUpdateProvider(context, previousValue, newValue);
    }
  }
}
```

### Performance Monitoring

Track provider rebuild frequency:

```dart
class PerformanceObserver extends LoggerObserver {
  final Map<ProviderBase, int> _updateCounts = {};
  
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    _updateCounts[context.provider] = 
        (_updateCounts[context.provider] ?? 0) + 1;
    
    // Warn about frequent updates
    if (_updateCounts[context.provider]! > 10) {
      dump(
        'Provider updated ${_updateCounts[context.provider]} times',
        tag: '[Performance Warning]',
      );
    }
    
    super.didUpdateProvider(context, previousValue, newValue);
  }
}
```

## Best Practices

### 1. Use in Development Only

```dart
// Good - only in debug builds
if (kDebugMode) {
  runApp(
    ProviderScope(
      observers: [LoggerObserver()],
      child: MyApp(),
    ),
  );
}
```

### 2. Name Complex Providers

```dart
// Good - named provider for clarity
final complexProvider = Provider((ref) => ComplexService(), 
  name: 'ComplexService'
);

// Avoid - anonymous providers in large apps
final provider = Provider((ref) => Service());
```

### 3. Filter Noisy Providers

```dart
class FilteredObserver extends LoggerObserver {
  final Set<String> ignoredProviders = {
    'TimerProvider',
    'AnimationProvider',
  };
  
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    final name = context.provider.name ?? 
                 context.provider.runtimeType.toString();
    
    if (!ignoredProviders.contains(name)) {
      super.didUpdateProvider(context, previousValue, newValue);
    }
  }
}
```

### 4. Debug Provider Dependencies

```dart
// Track provider dependency chains
class DependencyObserver extends LoggerObserver {
  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    dump(
      'Dependencies: ${context.container.getAllProviderElements()
        .map((e) => e.provider.name ?? e.provider.runtimeType)
        .join(', ')}',
      tag: '[Provider Dependencies]',
    );
    super.didAddProvider(context, value);
  }
}
```

## Common Use Cases

### 1. Authentication Flow Debugging

```dart
// Monitor auth state changes
ProviderScope(
  observers: [LoggerObserver()],
  child: MyApp(),
);

// See login flow in console:
// [Provider Added] AuthStateProvider = Unauthenticated
// [Provider Updated] AuthStateProvider from Unauthenticated to Loading
// [Provider Updated] AuthStateProvider from Loading to Authenticated(userId: 123)
```

### 2. Form State Tracking

```dart
// Debug form validation
final formProvider = StateNotifierProvider<FormNotifier, FormState>((ref) {
  return FormNotifier();
}, name: 'RegistrationForm');

// Console shows each field update:
// [Provider Updated] RegistrationForm from FormState(email: '') to FormState(email: 'user@example.com')
```

### 3. API State Management

```dart
// Monitor API calls
final postsProvider = FutureProvider<List<Post>>((ref) async {
  return api.fetchPosts();
}, name: 'PostsList');

// Track loading states:
// [Provider Added] PostsList = AsyncLoading
// [Provider Updated] PostsList from AsyncLoading to AsyncData([Post1, Post2, ...])
```

## See Also

- [State Management Documentation](STATE_MANAGEMENT.md)
- [Debugging Documentation](DEBUGGING.md)
- [Configuration Documentation](CONFIGURATION.md)