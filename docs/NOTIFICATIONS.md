# Notifications Documentation

Complete guide to local notifications in the Jet framework.

## Overview

Jet provides a comprehensive local notification system built on **[flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)**, the most popular and reliable package for local notifications in Flutter. The system includes advanced event-driven architecture, type-safe configuration, and intelligent notification management with action buttons, scheduling, and custom handlers.

**Packages Used:**
- **flutter_local_notifications** - ^16.3.0 - [pub.dev](https://pub.dev/packages/flutter_local_notifications) | [Documentation](https://pub.dev/documentation/flutter_local_notifications/latest/) - Cross-platform local notifications
- **timezone** - ^0.9.2 - [pub.dev](https://pub.dev/packages/timezone) - Timezone support for scheduled notifications
- **flutter_timezone** - ^1.0.8 - [pub.dev](https://pub.dev/packages/flutter_timezone) - Get device timezone

**Key Benefits:**
- ✅ Cross-platform support (iOS and Android)
- ✅ Event-driven architecture with type-safe handlers
- ✅ Scheduled notifications with flexible timing
- ✅ Action buttons with custom handlers
- ✅ Rich notifications with images and styling
- ✅ Notification channels for Android
- ✅ Category-based organization
- ✅ Priority levels (low, normal, high, critical)
- ✅ Custom notification sounds
- ✅ Vibration patterns
- ✅ LED colors (Android)
- ✅ Payload validation and parsing
- ✅ Observer pattern for analytics and logging

## Table of Contents

- [Overview](#overview)
- [Setup](#setup)
- [Basic Notifications](#basic-notifications)
- [Scheduled Notifications](#scheduled-notifications)
- [Event-Driven Notifications](#event-driven-notifications)
- [Notification Management](#notification-management)
- [Platform Configuration](#platform-configuration)
- [Best Practices](#best-practices)

## Overview

Jet provides a comprehensive local notification system built on **flutter_local_notifications** with advanced event handling, type-safe configuration, and intelligent notification management.

**Key Features:**
- ✅ Cross-platform local notifications
- ✅ Scheduled notifications with flexible timing
- ✅ Event-driven architecture for type-safe handling
- ✅ Custom notification channels (Android)
- ✅ Action buttons with custom handlers
- ✅ Notification observer pattern
- ✅ Category-based organization

## Setup

Add the notifications adapter to your app configuration:

```dart
import 'package:jet/jet.dart';

class AppConfig extends JetConfig {
  @override
  List<JetAdapter> get adapters => [
    RouterAdapter(),
    NotificationsAdapter(), // Add notifications support
  ];
}
```

## Basic Notifications

Send simple notifications with minimal setup:

```dart
import 'package:jet/jet.dart';

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

## Scheduled Notifications

Schedule notifications for future delivery:

### Schedule for Specific Time

```dart
// Schedule notification for 5 seconds from now
final scheduledTime = DateTime.now().add(const Duration(seconds: 5));

await JetNotifications.sendNotification(
  title: "Scheduled Notification",
  body: "This notification was scheduled for 5 seconds from now.",
  at: scheduledTime,
  payload: "scheduled_notification",
);
```

### Daily Notifications

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Schedule daily notification at 9 AM
final dailyTime = Time(9, 0, 0);

await JetNotifications.scheduleDailyNotification(
  title: "Daily Reminder",
  body: "Don't forget to check your tasks!",
  time: dailyTime,
  payload: "daily_reminder",
);
```

### Advanced Scheduling

```dart
// Weekly notification
await JetNotifications.scheduleWeeklyNotification(
  title: "Weekly Report",
  body: "Your weekly report is ready",
  dayOfWeek: DayOfWeek.monday,
  time: Time(10, 0, 0),
  payload: "weekly_report",
);
```

## Event-Driven Notifications

Jet's notification system is built around **JetNotificationEvent** - a powerful abstraction for type-safe, event-driven notification handling.

### Creating Notification Events

```dart
import 'package:jet/jet.dart';

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

### Registering Events

**Important:** You must register your custom notification events in your app configuration:

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

**Alternative - Manual Registration:**

```dart
// Register individual events
JetNotificationEventRegistry.register(OrderNotificationEvent());
JetNotificationEventRegistry.register(PaymentNotificationEvent());

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

### Notification Configuration

Use **NotificationEventConfig** for fine-grained control:

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

### Sending Event-Based Notifications

```dart
// Send notification using event
final orderEvent = OrderNotificationEvent();

await JetNotifications.sendNotificationFromEvent(
  event: orderEvent,
  title: "Order #12345 Shipped",
  body: "Your order has been shipped and will arrive in 2-3 days",
  payload: "12345",
);
```

## Notification Management

Control and manage your notifications:

### Cancel Notifications

```dart
// Cancel specific notification
await JetNotifications.cancelNotification(notificationId);

// Cancel all notifications
await JetNotifications.cancelAllNotifications();
```

### Get Pending Notifications

```dart
// Get all pending scheduled notifications
final pendingNotifications = await JetNotifications.getPendingNotifications();

for (final notification in pendingNotifications) {
  print('Pending: ${notification.id} - ${notification.title}');
}
```

### Check Notification Status

```dart
// Check if notifications are enabled
final isEnabled = await JetNotifications.isNotificationEnabled();

if (!isEnabled) {
  // Show dialog to enable notifications
  showEnableNotificationsDialog();
}
```

## Platform Configuration

### Android Configuration

Add required permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

### iOS Configuration

Add notification capabilities in `ios/Runner/Info.plist`:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

### Notification Channels (Android)

Create custom notification channels:

```dart
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

## Best Practices

### 1. Use Event-Driven Architecture

```dart
// Good - type-safe event handling
class OrderEvent extends JetNotificationEvent {
  @override
  Future<void> onTap(NotificationResponse response) async {
    final orderId = int.parse(response.payload ?? '0');
    router.push(OrderDetailsRoute(orderId: orderId));
  }
}

// Avoid - manual payload parsing everywhere
await JetNotifications.sendNotification(
  title: "Order Update",
  body: "Order shipped",
  payload: "order:12345:shipped",
);
```

### 2. Validate Payloads

```dart
class UserEvent extends JetNotificationEvent {
  @override
  bool validatePayload(String? payload) {
    if (payload == null) return false;
    try {
      final userId = int.parse(payload);
      return userId > 0;
    } catch (e) {
      return false;
    }
  }
}
```

### 3. Organize by Categories

```dart
class OrderEvent extends JetNotificationEvent {
  @override
  String? get category => 'orders';
}

class PaymentEvent extends JetNotificationEvent {
  @override
  String? get category => 'payments';
}

// Get all order-related events
final orderEvents = JetNotificationEventRegistry.getEventsByCategory('orders');
```

### 4. Use Appropriate Priorities

```dart
class CriticalAlertEvent extends JetNotificationEvent {
  @override
  NotificationPriority get priority => NotificationPriority.critical;
}

class BackgroundUpdateEvent extends JetNotificationEvent {
  @override
  NotificationPriority get priority => NotificationPriority.low;
}
```

### 5. Register Events in App Config

```dart
// Good - centralized registration
class AppConfig extends JetConfig {
  @override
  List<JetNotificationEvent> get notificationEvents => [
    OrderEvent(),
    PaymentEvent(),
    MessageEvent(),
  ];
}

// Avoid - scattered manual registration
void main() {
  JetNotificationEventRegistry.register(OrderEvent());
  // ... elsewhere in app
  JetNotificationEventRegistry.register(PaymentEvent());
}
```

### 6. Handle Notification Permissions

```dart
class NotificationSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: JetNotifications.isNotificationEnabled(),
      builder: (context, snapshot) {
        final isEnabled = snapshot.data ?? false;
        
        return SwitchListTile(
          title: Text('Notifications'),
          subtitle: Text(
            isEnabled 
              ? 'You will receive notifications' 
              : 'Notifications are disabled'
          ),
          value: isEnabled,
          onChanged: (value) {
            if (!value) {
              showDisableConfirmationDialog();
            } else {
              showEnableInstructionsDialog();
            }
          },
        );
      },
    );
  }
}
```

## See Also

- [Session Management Documentation](SESSIONS.md) - User authentication
- [Error Handling Documentation](ERROR_HANDLING.md) - Error handling patterns
- [Security Documentation](SECURITY.md) - App security features

