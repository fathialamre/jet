# Error Handling Documentation

Complete guide to error handling in the Jet framework.

## Overview

Jet provides comprehensive error handling with `JetError` for consistent, type-safe error management across your application. The system automatically converts HTTP errors from Dio into structured JetError instances with helpful properties and methods for different error scenarios.

**Packages Used:**
- **dio** - ^5.4.0 - [pub.dev](https://pub.dev/packages/dio) - HTTP errors are converted to JetError
- Dart SDK - Exception and Error handling

**Key Benefits:**
- ✅ Consistent error handling across the app
- ✅ Type-safe error categorization
- ✅ Automatic HTTP error conversion
- ✅ Validation error mapping to form fields
- ✅ User-friendly error messages
- ✅ Stack trace preservation
- ✅ Custom error data support
- ✅ Convenience getters for common error types
- ✅ Integration with forms and networking
- ✅ Testable error scenarios

## JetError

### Error Types

```dart
// Network error - no internet connection
final networkError = JetError.noInternet();

// Server error (5xx)
final serverError = JetError.server(
  message: 'Server error',
  statusCode: 500,
);

// Validation error (422)
final validationError = JetError.validation(errors: {
  'email': ['Email is required', 'Invalid email format'],
  'password': ['Password must be at least 8 characters'],
});

// Unauthorized error (401)
final unauthorizedError = JetError.unauthorized(
  message: 'Please login to continue',
);

// Not found error (404)
final notFoundError = JetError.notFound(
  message: 'Resource not found',
);

// Custom error
final customError = JetError.unknown(
  message: 'Something went wrong',
  data: {'details': '...'},
);
```

### Error Properties

```dart
class JetError {
  final String message;                     // Error message
  final int? statusCode;                    // HTTP status code
  final Map<String, List<String>>? errors;  // Validation errors
  final dynamic data;                       // Additional error data
  
  // Convenience getters
  bool get isNoInternet;                    // No network connection
  bool get isServer;                        // 5xx errors
  bool get isValidation;                    // 422 validation errors
  bool get isUnauthorized;                  // 401 unauthorized
  bool get isNotFound;                      // 404 not found
}
```

## Error Handling Patterns

### Try-Catch with JetError

```dart
try {
  final result = await apiService.getData();
  // Handle success
} on JetError catch (error) {
  if (error.isValidation) {
    // Handle validation errors
    final emailErrors = error.errors?['email'];
    context.showToast(emailErrors?.first ?? 'Validation error');
  } else if (error.isNoInternet) {
    // Handle network errors
    context.showToast('No internet connection');
  } else if (error.isUnauthorized) {
    // Handle unauthorized
    context.router.pushNamed('/login');
  } else if (error.isServer) {
    // Handle server errors
    context.showToast('Server error. Please try again later.');
  }
} catch (error) {
  // Handle unexpected errors
  dump('Unexpected error: $error');
}
```

### With Forms

```dart
class LoginFormNotifier extends JetFormNotifier<LoginRequest, User> {
  @override
  Future<User> action(LoginRequest data) async {
    try {
      final authService = ref.read(authServiceProvider);
      return await authService.login(data.email, data.password);
    } catch (error) {
      if (error is JetError && error.isValidation) {
        // Form will automatically show validation errors
        rethrow;
      }
      throw JetError.unknown(message: 'Login failed');
    }
  }
}
```

### With State Management

```dart
final userProvider = FutureProvider<User>((ref) async {
  try {
    final api = ref.read(apiServiceProvider);
    return await api.getCurrentUser();
  } on JetError catch (error) {
    if (error.isUnauthorized) {
      ref.read(authProvider.notifier).logout();
    }
    rethrow;
  }
});

// In UI
Widget build(BuildContext context, WidgetRef ref) {
  final user = ref.watch(userProvider);
  
  return user.when(
    data: (userData) => UserProfile(user: userData),
    loading: () => CircularProgressIndicator(),
    error: (error, stack) {
      if (error is JetError) {
        if (error.isNoInternet) {
          return NoInternetWidget();
        } else if (error.isServer) {
          return ServerErrorWidget();
        }
      }
      return GenericErrorWidget();
    },
  );
}
```

## Best Practices

### 1. Use Specific Error Types

```dart
// Good - specific error type
if (error.isNoInternet) {
  context.showToast('No internet connection');
} else if (error.isUnauthorized) {
  context.router.pushNamed('/login');
}

// Avoid - generic error handling
context.showToast('An error occurred');
```

### 2. Provide User-Friendly Messages

```dart
// Good - user-friendly message
context.showToast(
  'Failed to load data',
  actionLabel: 'Retry',
  onPressed: () => ref.refresh(dataProvider),
);

// Avoid - technical error message
context.showToast(error.toString());
```

### 3. Handle Validation Errors

```dart
// Good - display field-specific errors
if (error.isValidation && error.errors != null) {
  error.errors!.forEach((field, messages) {
    form.invalidateField(field, messages.first);
  });
}

// Avoid - generic validation message
context.showToast('Validation failed');
```

### 4. Log Errors for Debugging

```dart
try {
  final result = await apiService.getData();
} on JetError catch (error) {
  dump('JetError: ${error.message}', tag: 'API');
  if (error.isServer) {
    dump('Status code: ${error.statusCode}');
  }
  // Handle error
}
```

## See Also

- [Networking Documentation](NETWORKING.md)
- [Forms Documentation](FORMS.md)
- [Debugging Documentation](DEBUGGING.md)

