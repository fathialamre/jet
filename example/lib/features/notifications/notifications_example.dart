import 'package:flutter/material.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/helpers/jet_logger.dart' show dump;

/// Notifications Example Page
///
/// Demonstrates how to use JetNotifications for local notifications
@RoutePage()
class NotificationsExamplePage extends StatelessWidget {
  const NotificationsExamplePage({super.key});

  /// Check if JetNotifications is initialized
  void _checkInitializationStatus(BuildContext context) {
    final isInitialized = JetNotifications.isInitialized;
    context.showToast(
      isInitialized
          ? 'JetNotifications is initialized ✅'
          : 'JetNotifications is NOT initialized ❌',
    );
  }

  Future<void> _sendSimpleNotification(BuildContext context) async {
    try {
      // Check if JetNotifications is initialized before sending
      if (!JetNotifications.isInitialized) {
        context.showToast('JetNotifications is not initialized!');
        return;
      }

      await JetNotifications.sendNotification(
        title: "Hello from Jet!",
        body: "This is a simple notification from the Jet framework.",
        payload: "simple_notification",
      );
    } catch (e) {
      dump('Failed to send notification: $e', tag: 'Notification Error');
    }
  }

  Future<void> _sendScheduledNotification(BuildContext context) async {
    try {
      final scheduledTime = DateTime.now().add(const Duration(seconds: 5));

      await JetNotifications.sendNotification(
        title: "Scheduled Notification",
        body: "This notification was scheduled for 5 seconds from now.",
        at: scheduledTime,
        payload: "scheduled_notification",
      );

      context.showToast('Notification scheduled for 5 seconds from now');
    } catch (e) {
      dump('Failed to schedule notification: $e', tag: 'Notification Error');
    }
  }

  Future<void> _sendAdvancedNotification(BuildContext context) async {
    try {
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
    } catch (e) {
      dump(
        'Failed to send advanced notification: $e',
        tag: 'Notification Error',
      );
    }
  }

  Future<void> _sendOrderNotification(BuildContext context) async {
    try {
      await JetNotifications.sendNotification(
        title: "Order Update",
        body: "Your order #12345 has been shipped!",
        id: 1, // This will trigger OrderNotificationEvent
        payload: "12345",
        channelId: "orders_channel",
        channelName: "Order Notifications",
        channelDescription: "Notifications about your orders",
        importance: Importance.high,
        priority: Priority.high,
        color: Colors.green,
        actions: [
          const AndroidNotificationAction(
            'view_order',
            'View Order',
          ),
          const AndroidNotificationAction(
            'track_order',
            'Track Order',
          ),
        ],
      );
      context.showToast('Order notification sent!');
    } catch (e) {
      dump('Failed to send order notification: $e', tag: 'Notification Error');
    }
  }

  Future<void> _cancelAllNotifications(BuildContext context) async {
    try {
      await JetNotifications.cancelAllNotifications();
      context.showToast('All notifications cancelled');
    } catch (e) {
      dump('Failed to cancel notifications: $e', tag: 'Notification Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jet Notifications Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Basic Notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            JetButton(
              text: 'Send Simple Notification',
              onTap: () => _sendSimpleNotification(context),
            ),
            const SizedBox(height: 8),
            JetButton(
              text: 'Send Scheduled Notification (5s)',
              onTap: () => _sendScheduledNotification(context),
            ),
            const SizedBox(height: 8),
            JetButton(
              text: 'Send Advanced Notification',
              onTap: () => _sendAdvancedNotification(context),
            ),
            const SizedBox(height: 8),
            JetButton(
              text: 'Check Initialization Status',
              onTap: () => _checkInitializationStatus(context),
            ),
            const SizedBox(height: 24),
            const Text(
              'Event-Driven Notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            JetButton(
              text: 'Send Order Notification (ID: 1)',
              onTap: () => _sendOrderNotification(context),
            ),
            const SizedBox(height: 24),
            JetButton.outlined(
              text: 'Cancel All Notifications',
              onTap: () => _cancelAllNotifications(context),
            ),
          ],
        ),
      ),
    );
  }
}
