# Networking Documentation

Complete guide to HTTP networking in the Jet framework.

## Table of Contents

- [Overview](#overview)
- [Basic Setup](#basic-setup)
- [Making Requests](#making-requests)
- [Response Handling](#response-handling)
- [Error Handling](#error-handling)
- [Network Logging](#network-logging)
- [Interceptors](#interceptors)
- [Best Practices](#best-practices)

## Overview

Jet provides a type-safe HTTP client built on **[Dio](https://pub.dev/packages/dio)** with automatic error handling, configurable logging, and custom interceptors support. Dio is a powerful HTTP client for Dart/Flutter that supports interceptors, global configuration, FormData, request cancellation, file downloading, and timeout handling.

**Packages Used:**
- **dio** - ^5.4.0 - [pub.dev](https://pub.dev/packages/dio) | [Documentation](https://pub.dev/documentation/dio/latest/) - HTTP client with interceptors
- **pretty_dio_logger** - ^1.3.1 - [pub.dev](https://pub.dev/packages/pretty_dio_logger) - Beautiful console logging for requests/responses

**Key Features:**
- ✅ Type-safe API requests with generic support
- ✅ Automatic error conversion to JetError
- ✅ Configurable request/response logging
- ✅ Interceptor support for custom headers, tokens, etc.
- ✅ Built-in timeout handling
- ✅ Request/response transformation
- ✅ FormData support for file uploads
- ✅ Request cancellation support
- ✅ Global configuration per service

## Basic Setup

Create an API service by extending `JetApiService`:

```dart
import 'package:jet/jet.dart';

class UserApiService extends JetApiService {
  @override
  String get baseUrl => 'https://api.example.com/v1';

  @override
  Map<String, dynamic> get defaultHeaders => {
    ...super.defaultHeaders,
    'Authorization': 'Bearer ${getToken()}',
    'Accept': 'application/json',
  };

  String? getToken() {
    return JetStorage.readSecure('auth_token');
  }
}

// Create provider
final userApiServiceProvider = Provider<UserApiService>((ref) {
  return UserApiService();
});
```

## Making Requests

### GET Requests

```dart
class UserApiService extends JetApiService {
  @override
  String get baseUrl => 'https://api.example.com/v1';

  // Simple GET without decoder
  Future<ResponseModel<dynamic>> getUsers() async {
    return await get('/users');
  }

  // GET with decoder for type safety
  Future<ResponseModel<List<User>>> getUsersTyped() async {
    return await get<List<User>>(
      '/users',
      decoder: (data) => (data as List)
          .map((json) => User.fromJson(json))
          .toList(),
    );
  }

  // GET with query parameters
  Future<ResponseModel<List<User>>> searchUsers(String query) async {
    return await get<List<User>>(
      '/users/search',
      queryParameters: {'q': query, 'limit': 20},
      decoder: (data) => (data as List)
          .map((json) => User.fromJson(json))
          .toList(),
    );
  }

  // GET single resource
  Future<ResponseModel<User>> getUser(String userId) async {
    return await get<User>(
      '/users/$userId',
      decoder: (data) => User.fromJson(data),
    );
  }
}
```

### POST Requests

```dart
class UserApiService extends JetApiService {
  @override
  String get baseUrl => 'https://api.example.com/v1';

  // POST with request body
  Future<ResponseModel<User>> createUser(CreateUserRequest request) async {
    return await post<User>(
      '/users',
      data: request.toJson(),
      decoder: (data) => User.fromJson(data),
    );
  }

  // POST with form data
  Future<ResponseModel<bool>> uploadAvatar(File imageFile) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(
        imageFile.path,
        filename: 'avatar.jpg',
      ),
    });

    return await post<bool>(
      '/users/avatar',
      data: formData,
      decoder: (data) => data['success'] as bool,
    );
  }
}
```

### PUT Requests

```dart
class UserApiService extends JetApiService {
  @override
  String get baseUrl => 'https://api.example.com/v1';

  // PUT to update resource
  Future<ResponseModel<User>> updateUser(
    String userId,
    UpdateUserRequest request,
  ) async {
    return await put<User>(
      '/users/$userId',
      data: request.toJson(),
      decoder: (data) => User.fromJson(data),
    );
  }
}
```

### PATCH Requests

```dart
class UserApiService extends JetApiService {
  @override
  String get baseUrl => 'https://api.example.com/v1';

  // PATCH for partial updates
  Future<ResponseModel<User>> patchUser(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    return await patch<User>(
      '/users/$userId',
      data: updates,
      decoder: (data) => User.fromJson(data),
    );
  }
}
```

### DELETE Requests

```dart
class UserApiService extends JetApiService {
  @override
  String get baseUrl => 'https://api.example.com/v1';

  // DELETE resource
  Future<ResponseModel<bool>> deleteUser(String userId) async {
    return await delete<bool>(
      '/users/$userId',
      decoder: (data) => data['success'] as bool,
    );
  }
}
```

## Response Handling

### ResponseModel

All Jet API methods return a `ResponseModel<T>` for type-safe response handling:

```dart
class ResponseModel<T> {
  final T? data;           // Decoded response data
  final int? statusCode;   // HTTP status code
  final String? message;   // Response message
  final bool success;      // Request success status
  final dynamic raw;       // Raw response data
}
```

### Using ResponseModel

```dart
// In your UI or business logic
Future<void> loadUsers() async {
  try {
    final response = await ref.read(userApiServiceProvider).getUsers();
    
    if (response.success && response.data != null) {
      // Success - use response.data
      final users = response.data!;
      setState(() {
        _users = users;
      });
    } else {
      // Handle unsuccessful response
      context.showToast(response.message ?? 'Failed to load users');
    }
  } on JetError catch (error) {
    // Handle JetError
    if (error.isNoInternet) {
      context.showToast('No internet connection');
    } else if (error.isServer) {
      context.showToast('Server error: ${error.message}');
    }
  } catch (error) {
    // Handle unexpected errors
    dump('Unexpected error: $error');
  }
}
```

## Error Handling

Jet automatically converts HTTP errors to `JetError` for consistent error handling:

### Error Types

```dart
try {
  final response = await apiService.getData();
} on JetError catch (error) {
  if (error.isNoInternet) {
    // Network error - no connection
    context.showToast('No internet connection');
  } else if (error.isServer) {
    // Server error (5xx)
    context.showToast('Server error: ${error.message}');
  } else if (error.isValidation) {
    // Validation error (422)
    // Handle validation errors
    final errors = error.errors; // Map<String, List<String>>
    showValidationErrors(errors);
  } else if (error.isUnauthorized) {
    // Unauthorized (401)
    context.router.pushNamed('/login');
  } else if (error.isNotFound) {
    // Not found (404)
    context.showToast('Resource not found');
  }
}
```

### JetError Properties

```dart
class JetError {
  final String message;              // Error message
  final int? statusCode;             // HTTP status code
  final Map<String, List<String>>? errors;  // Validation errors
  final dynamic data;                // Additional error data
  
  // Convenience getters
  bool get isNoInternet;             // No network connection
  bool get isServer;                 // 5xx errors
  bool get isValidation;             // 422 validation errors
  bool get isUnauthorized;           // 401 unauthorized
  bool get isNotFound;               // 404 not found
}
```

### Creating Custom Errors

```dart
// Validation error
throw JetError.validation(errors: {
  'email': ['Email is required', 'Invalid email format'],
  'password': ['Password must be at least 8 characters'],
});

// Server error
throw JetError.server(
  message: 'Internal server error',
  statusCode: 500,
);

// No internet error
throw JetError.noInternet();

// Custom error
throw JetError.unknown(
  message: 'Something went wrong',
  data: {'details': '...'},
);
```

## Network Logging

Configure request/response logging through `JetDioLoggerConfig`:

### Setup Logging in App Config

```dart
import 'package:jet/jet.dart';

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

### Logging Configuration Options

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `request` | `bool` | `true` | Log request info |
| `requestHeader` | `bool` | `true` | Log request headers |
| `requestBody` | `bool` | `true` | Log request body |
| `responseBody` | `bool` | `true` | Log response body |
| `responseHeader` | `bool` | `false` | Log response headers |
| `error` | `bool` | `true` | Log errors |
| `compact` | `bool` | `true` | Compact JSON output |
| `maxWidth` | `int` | `90` | Console output width |
| `enabled` | `bool` | `true` | Enable/disable all logging |

### Environment-Specific Logging

```dart
class AppConfig extends JetConfig {
  @override
  JetDioLoggerConfig get dioLoggerConfig => JetDioLoggerConfig(
    request: true,
    requestHeader: true,
    requestBody: kDebugMode,  // Only in debug mode
    responseBody: kDebugMode,
    responseHeader: false,
    error: true,
    compact: true,
    enabled: kDebugMode,      // Only enable in debug mode
  );
}
```

## Interceptors

Add custom interceptors for advanced functionality:

### Bearer Token Interceptor

```dart
import 'package:jet/jet.dart';

class AuthApiService extends JetApiService {
  @override
  String get baseUrl => 'https://api.example.com/v1';

  @override
  List<Interceptor> get interceptors => [
    JetBearerTokenInterceptor(
      tokenProvider: () async {
        return await JetStorage.readSecure('auth_token');
      },
    ),
    ...super.interceptors,
  ];
}
```

### Custom Interceptor

```dart
import 'package:dio/dio.dart';

class CustomInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add custom headers
    options.headers['X-Custom-Header'] = 'value';
    
    // Log request
    print('Request: ${options.method} ${options.uri}');
    
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Process response
    print('Response: ${response.statusCode}');
    
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle errors
    print('Error: ${err.message}');
    
    super.onError(err, handler);
  }
}

// Use in API service
class MyApiService extends JetApiService {
  @override
  List<Interceptor> get interceptors => [
    CustomInterceptor(),
    ...super.interceptors,
  ];
}
```

## Best Practices

### 1. Use Type-Safe Decoders

```dart
// Good - type-safe with decoder
Future<ResponseModel<List<User>>> getUsers() async {
  return await get<List<User>>(
    '/users',
    decoder: (data) => (data as List)
        .map((json) => User.fromJson(json))
        .toList(),
  );
}

// Avoid - no type safety
Future<ResponseModel<dynamic>> getUsers() async {
  return await get('/users');
}
```

### 2. Centralize API Services

```dart
// Good - single API service file
class ApiService extends JetApiService {
  @override
  String get baseUrl => 'https://api.example.com/v1';

  // User endpoints
  Future<ResponseModel<List<User>>> getUsers() async {...}
  Future<ResponseModel<User>> createUser(CreateUserRequest request) async {...}
  
  // Post endpoints
  Future<ResponseModel<List<Post>>> getPosts() async {...}
  Future<ResponseModel<Post>> createPost(CreatePostRequest request) async {...}
}

// Or organize by resource
class UserApiService extends JetApiService {...}
class PostApiService extends JetApiService {...}
```

### 3. Handle Errors Consistently

```dart
// Good - consistent error handling
try {
  final response = await apiService.getData();
  // Handle success
} on JetError catch (error) {
  if (error.isNoInternet) {
    context.showToast('No internet connection');
  } else if (error.isServer) {
    context.showToast('Server error');
  }
} catch (error) {
  dump('Unexpected error: $error');
}
```

### 4. Use Providers for API Services

```dart
// Good - use Riverpod providers
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// In widgets/notifiers
final apiService = ref.read(apiServiceProvider);
final response = await apiService.getData();
```

### 5. Secure Sensitive Data

```dart
// Good - don't log request bodies in production
class AppConfig extends JetConfig {
  @override
  JetDioLoggerConfig get dioLoggerConfig => JetDioLoggerConfig(
    requestBody: kDebugMode,  // Only in debug
    enabled: kDebugMode,      // Only in debug
  );
}
```

### 6. Use Query Parameters Properly

```dart
// Good - use queryParameters
Future<ResponseModel<List<User>>> searchUsers(
  String query,
  int page,
  int limit,
) async {
  return await get<List<User>>(
    '/users/search',
    queryParameters: {
      'q': query,
      'page': page,
      'limit': limit,
    },
    decoder: (data) => (data as List)
        .map((json) => User.fromJson(json))
        .toList(),
  );
}

// Avoid - manual URL construction
Future<ResponseModel<List<User>>> searchUsers(String query) async {
  return await get<List<User>>(
    '/users/search?q=$query&limit=20', // Don't do this
    decoder: (data) => ...,
  );
}
```

## See Also

- [Error Handling Documentation](ERROR_HANDLING.md) - JetError and error handling
- [State Management Documentation](STATE_MANAGEMENT.md) - Using providers
- [Forms Documentation](FORMS.md) - Form submission with API calls

