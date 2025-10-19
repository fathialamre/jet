# Storage Documentation

Complete guide to local storage in the Jet framework.

## Overview

JetStorage provides secure local storage for lightweight data with support for regular and encrypted storage. It combines the power of **SharedPreferences** for regular data and **Flutter Secure Storage** for sensitive information that needs encryption.

**Packages Used:**
- **shared_preferences** - [pub.dev](https://pub.dev/packages/shared_preferences) - For regular key-value storage
- **flutter_secure_storage** - [pub.dev](https://pub.dev/packages/flutter_secure_storage) - For encrypted secure storage

**Key Benefits:**
- ✅ Type-safe read/write operations with generics
- ✅ Encrypted secure storage for sensitive data (tokens, passwords)
- ✅ JSON serialization support for complex objects
- ✅ Default values to prevent null issues
- ✅ Automatic error handling
- ✅ Platform-specific secure storage (Keychain on iOS, KeyStore on Android)
- ✅ Simple, unified API for both storage types

## Basic Usage

### Regular Storage

Built on SharedPreferences for non-sensitive data:

```dart
// Write data
await JetStorage.write('user_name', 'John Doe');
await JetStorage.write('user_age', 25);
await JetStorage.write('settings', {'theme': 'dark', 'language': 'en'});

// Read data
String? name = JetStorage.read<String>('user_name');
int? age = JetStorage.read<int>('user_age');
Map<String, dynamic>? settings = JetStorage.read<Map<String, dynamic>>('settings');

// With default values
String name = JetStorage.read<String>('user_name', defaultValue: 'Guest');

// Delete data
await JetStorage.delete('user_name');

// Clear all
await JetStorage.clear();
```

### Secure Storage

Encrypted storage for sensitive data:

```dart
// Write secure data
await JetStorage.writeSecure('auth_token', 'your-jwt-token');
await JetStorage.writeSecure('api_key', 'secret-api-key');

// Read secure data
String? token = await JetStorage.readSecure('auth_token');
String? apiKey = await JetStorage.readSecure('api_key');

// Delete secure data
await JetStorage.deleteSecure('auth_token');

// Clear all secure data
await JetStorage.clearSecure();
```

## Features

- ✅ Type-safe read/write operations
- ✅ Encrypted secure storage for sensitive data
- ✅ JSON serialization support
- ✅ Default values
- ✅ Error handling

## Best Practices

### 1. Use Secure Storage for Sensitive Data

```dart
// Good - sensitive data encrypted
await JetStorage.writeSecure('auth_token', token);
await JetStorage.writeSecure('password', password);

// Avoid - sensitive data unencrypted
await JetStorage.write('auth_token', token);
```

### 2. Clear Data on Logout

```dart
Future<void> logout() async {
  await SessionManager.clear();
  await JetStorage.clearSecure();
  context.router.pushNamed('/login');
}
```

### 3. Use Type Safety

```dart
// Good - type-safe
String? name = JetStorage.read<String>('user_name');
int? age = JetStorage.read<int>('user_age');

// Avoid - dynamic type
var name = JetStorage.read('user_name');
```

## See Also

- [Security Documentation](SECURITY.md)
- [Sessions Documentation](SESSIONS.md)

