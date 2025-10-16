# Security Documentation

Complete guide to security features in the Jet framework.

## Overview

Jet provides built-in security features for protecting your application with biometric authentication using **[Guardo](https://pub.dev/packages/guardo)**, a powerful package for app lock functionality. Guardo provides seamless integration with device biometric authentication (fingerprint, face recognition) and PIN/pattern fallbacks.

**Packages Used:**
- **guardo** - ^1.1.0 - [pub.dev](https://pub.dev/packages/guardo) | [Documentation](https://pub.dev/documentation/guardo/latest/) - App lock with biometric authentication
- **local_auth** - ^2.1.7 - [pub.dev](https://pub.dev/packages/local_auth) - Biometric authentication (used by Guardo)
- **flutter_secure_storage** - ^9.0.0 - [pub.dev](https://pub.dev/packages/flutter_secure_storage) - Secure storage for sensitive data

**Key Benefits:**
- ✅ Biometric authentication (fingerprint, face ID, iris scan)
- ✅ PIN/pattern fallback when biometrics unavailable
- ✅ Persistent lock state with secure storage
- ✅ Auto-lock when app becomes inactive
- ✅ Force lock option for immediate protection
- ✅ Integration with device security settings
- ✅ Platform-specific authentication dialogs
- ✅ Customizable authentication messages
- ✅ Background protection (blur sensitive content)
- ✅ Session timeout configuration

## App Locker

Secure your app with biometric authentication using the Guardo package.

### Setup

Configure app lock in your app widget:

```dart
class AppWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lockState = ref.watch(appLockProvider);
    
    return MaterialApp.router(
      routerConfig: router,
      builder: (context, child) {
        return Guardo(
          enabled: lockState,  // App will lock when enabled
          child: child!,
        );
      },
    );
  }
}
```

### Toggle App Lock

```dart
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
```

### Manual Lock

```dart
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

## Security Features

- ✅ **Biometric authentication** - Fingerprint/face recognition
- ✅ **Persistent lock state** - Stored securely
- ✅ **Auto-lock functionality** - Lock when app becomes inactive
- ✅ **Force lock option** - Immediate protection
- ✅ **Integration with device security** - Uses system auth

## Best Practices

### 1. Use Secure Storage for Sensitive Data

```dart
// Good - encrypted storage
await JetStorage.writeSecure('auth_token', token);
await JetStorage.writeSecure('password', password);

// Avoid - unencrypted storage
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

### 3. Enable App Lock for Sensitive Apps

```dart
// Banking, health, or financial apps should enable app lock by default
if (isSensitiveApp) {
  await ref.read(appLockProvider.notifier).enable(context);
}
```

## See Also

- [Storage Documentation](STORAGE.md)
- [Sessions Documentation](SESSIONS.md)

