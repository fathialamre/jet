# 🔔 Using Riverpod in Notification Events

This guide explains how to access Riverpod providers from within notification event handlers in the Jet framework.

## Table of Contents
- [Overview](#overview)
- [How It Works](#how-it-works)
- [Basic Usage](#basic-usage)
- [Advanced Examples](#advanced-examples)
- [Best Practices](#best-practices)
- [Limitations](#limitations)

## Overview

Notification events in Jet now have access to Riverpod's `ProviderContainer`, allowing you to:
- ✅ Update app state when notifications are received or tapped
- ✅ Navigate to specific pages using the router
- ✅ Read and modify provider state
- ✅ Trigger side effects (API calls, database operations, etc.)
- ✅ Access all Riverpod providers from notification handlers

## How It Works

When your Jet app initializes, it creates a `ProviderContainer` and makes it available to the notification system. Any `JetNotificationEvent` can access this container through the `container` property.

```dart
@override
Future<void> onTap(NotificationResponse response) async {
  // Access any Riverpod provider
  container?.read(myProvider.notifier).doSomething();
}
```

## Basic Usage

### 1. Create a Provider

First, create any Riverpod provider you want to use:

```dart
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationState {
  final int unreadCount;
  final String? lastNotificationId;
  
  const NotificationState({
    this.unreadCount = 0,
    this.lastNotificationId,
  });
}

class NotificationStateNotifier extends Notifier<NotificationState> {
  @override
  NotificationState build() => const NotificationState();
  
  void markAsRead(String id) {
    state = NotificationState(
      unreadCount: state.unreadCount - 1,
      lastNotificationId: id,
    );
  }
  
  void incrementUnread() {
    state = NotificationState(
      unreadCount: state.unreadCount + 1,
      lastNotificationId: state.lastNotificationId,
    );
  }
}

final notificationStateProvider = 
    NotifierProvider<NotificationStateNotifier, NotificationState>(
  NotificationStateNotifier.new,
);
```

### 2. Use the Provider in Your Notification Event

```dart
import 'package:jet/notifications/events/jet_notification_event.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class OrderNotificationEvent extends JetNotificationEvent {
  @override
  int get id => 1;

  @override
  String get name => 'OrderNotification';

  @override
  Future<void> onTap(NotificationResponse response) async {
    // Access the container to read/modify providers
    container?.read(notificationStateProvider.notifier)
        .markAsRead(response.payload ?? '');
    
    // Navigate using the router
    final router = container?.read(routerProvider);
    router?.push(OrderDetailsRoute(orderId: response.payload));
  }

  @override
  Future<void> onReceive(NotificationResponse response) async {
    // Update state when notification is received
    container?.read(notificationStateProvider.notifier).incrementUnread();
  }
}
```

### 3. Watch the State in Your UI

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.watch(notificationStateProvider);
  
  return Text('Unread: ${state.unreadCount}');
}
```

## Advanced Examples

### Navigation on Notification Tap

```dart
@override
Future<void> onTap(NotificationResponse response) async {
  final router = container?.read(routerProvider);
  
  // Parse payload to determine which page to navigate to
  final payload = jsonDecode(response.payload ?? '{}');
  
  switch (payload['type']) {
    case 'order':
      router?.push(OrderRoute(id: payload['id']));
      break;
    case 'message':
      router?.push(ChatRoute(conversationId: payload['id']));
      break;
    default:
      router?.push(const HomeRoute());
  }
}
```

### Fetching Data from API

```dart
@override
Future<void> onTap(NotificationResponse response) async {
  final orderId = response.payload;
  
  // Trigger a provider to fetch fresh data
  container?.read(orderDetailsProvider(orderId).future).then((order) {
    // Data is now cached and available in the app
  });
  
  // Navigate to the page
  container?.read(routerProvider).push(OrderRoute(id: orderId));
}
```

### Showing In-App Notifications

```dart
@override
Future<void> onReceive(NotificationResponse response) async {
  // When notification is received while app is open,
  // show an in-app snackbar or dialog
  
  final messenger = container?.read(scaffoldMessengerProvider);
  messenger?.showSnackBar(
    SnackBar(content: Text('New order: ${response.payload}')),
  );
  
  // Update badge count
  container?.read(badgeCountProvider.notifier).increment();
}
```

### Complex State Updates

```dart
@override
Future<void> onTap(NotificationResponse response) async {
  final payload = jsonDecode(response.payload ?? '{}');
  final orderId = payload['orderId'];
  final status = payload['status'];
  
  // Update multiple providers
  container?.read(orderProvider.notifier).updateStatus(orderId, status);
  container?.read(notificationProvider.notifier).markAsRead(response.id);
  container?.read(analyticsProvider).trackNotificationTap('order', orderId);
  
  // Navigate
  container?.read(routerProvider).push(OrderRoute(id: orderId));
}
```

## Best Practices

### 1. Always Check for Null

The `container` property might be `null` if it hasn't been initialized yet. Always use the null-aware operator:

```dart
container?.read(myProvider); // ✅ Good
container.read(myProvider);  // ❌ Bad - might throw
```

### 2. Use Read, Not Watch

In notification events, use `read()` instead of `watch()` since you're not in a widget context:

```dart
container?.read(myProvider);       // ✅ Good
container?.watch(myProvider);      // ❌ Bad - watch is for widgets
```

### 3. Handle Errors Gracefully

Wrap provider access in try-catch blocks:

```dart
@override
Future<void> onTap(NotificationResponse response) async {
  try {
    container?.read(myProvider.notifier).doSomething();
  } catch (e) {
    dump('Error handling notification: $e');
  }
}
```

### 4. Keep Event Handlers Fast

Notification handlers should be quick. For long-running operations, trigger them in the background:

```dart
@override
Future<void> onTap(NotificationResponse response) async {
  // ✅ Quick state update
  container?.read(selectedOrderProvider.notifier).state = response.payload;
  
  // ✅ Navigate immediately
  container?.read(routerProvider).push(OrderRoute(id: response.payload));
  
  // ❌ Don't wait for slow operations
  // await heavyApiCall(); // Bad!
  
  // ✅ Trigger in background instead
  unawaited(container?.read(orderProvider(response.payload).future));
}
```

### 5. Use Providers for Navigation

Don't try to access `BuildContext` in notification events. Use providers instead:

```dart
// ✅ Good - Use router provider
container?.read(routerProvider).push(OrderRoute(id: orderId));

// ❌ Bad - No BuildContext available
// context.push('/order/$orderId'); // Won't work!
```

## Limitations

### Background/Terminated State

When your app is in the background or terminated, some providers might not be fully initialized. Consider:

1. **AsyncProviders**: Might not have completed loading
2. **Scoped Providers**: Won't be available if scope doesn't exist
3. **UI Providers**: Should not be accessed from background

### Solution: Defensive Coding

```dart
@override
Future<void> onTap(NotificationResponse response) async {
  // Check if provider is available
  final data = container?.read(myDataProvider);
  
  if (data != null) {
    // Use data
  } else {
    // Fallback behavior
    dump('Provider not available, using fallback');
  }
}
```

## Common Patterns

### Pattern 1: Navigate and Prefetch

```dart
@override
Future<void> onTap(NotificationResponse response) async {
  final orderId = response.payload;
  
  // Prefetch data in parallel with navigation
  final dataFuture = container?.read(orderProvider(orderId).future);
  container?.read(routerProvider).push(OrderRoute(id: orderId));
  
  // Data will be ready when page loads
  await dataFuture;
}
```

### Pattern 2: Update Badge Count

```dart
@override
Future<void> onReceive(NotificationResponse response) async {
  container?.read(badgeProvider.notifier).increment();
}

@override
Future<void> onTap(NotificationResponse response) async {
  container?.read(badgeProvider.notifier).decrement();
}
```

### Pattern 3: Analytics Tracking

```dart
@override
Future<void> onTap(NotificationResponse response) async {
  // Track that user tapped notification
  container?.read(analyticsProvider).logEvent(
    'notification_tapped',
    parameters: {
      'notification_id': response.id,
      'payload': response.payload,
    },
  );
}
```

## Summary

The `container` property in `JetNotificationEvent` gives you full access to your app's Riverpod providers, enabling rich interactions between notifications and your app state. Use it to create seamless user experiences when users interact with notifications.

For more examples, check out the example app in `example/lib/features/notifications/`.

