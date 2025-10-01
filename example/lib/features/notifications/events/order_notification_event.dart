import 'package:example/features/notifications/providers/notification_state_provider.dart';
import 'package:jet/helpers/jet_logger.dart';
import 'package:jet/jet_framework.dart';

/// Example notification event for handling order-related notifications.
///
/// This class demonstrates how to implement a JetNotificationEvent for
/// order notifications, including handling taps, receives, and actions.
///
/// It also shows how to use the `container` property to access Riverpod
/// providers and update app state from notification events.
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
    if (payload == null || payload.isEmpty) {
      dump('Order notification received without payload');
      return false;
    }

    // Basic validation - check if payload contains order ID
    try {
      final orderId = int.parse(payload);
      return orderId > 0;
    } catch (e) {
      dump('Invalid order notification payload: $payload');
      return false;
    }
  }

  @override
  Future<void> onTap(NotificationResponse response) async {
    dump('Order notification tapped: ${response.payload}');

    try {
      final orderId = response.payload ?? '0';

      // ✅ USE CONTAINER TO ACCESS RIVERPOD PROVIDERS (NO NULL CHECKS NEEDED!)

      // Update notification state using Riverpod
      container
          .read(notificationStateProvider.notifier)
          .incrementTapCount(orderId);

      // Get current state
      final currentState = container.read(notificationStateProvider);
      dump('📊 Notification tapped ${currentState.tapCount} times');
      dump('📦 Last order ID: ${currentState.lastOrderId}');

      // Navigate to order details page using router
      // container.read(routerProvider).push(OrderRoute(id: orderId));

      // You can also read other providers:
      // - Update order status: container.read(orderProvider.notifier).selectOrder(orderId);
      // - Show in-app notification: container.read(snackBarProvider.notifier).show('Order tapped');
      // - Mark as read: container.read(notificationProvider.notifier).markAsRead(response.id);

      dump('✅ Successfully updated app state from notification tap');
    } catch (e) {
      dump('❌ Failed to handle order notification tap: $e');
    }
  }

  @override
  Future<void> onReceive(NotificationResponse response) async {
    dump('🎯 ORDER NOTIFICATION RECEIVED: ${response.payload}');

    try {
      final orderId = response.payload ?? '0';

      // ✅ USE CONTAINER TO ACCESS RIVERPOD PROVIDERS (NO NULL CHECKS NEEDED!)

      // Update notification state
      container
          .read(notificationStateProvider.notifier)
          .incrementReceiveCount(orderId);

      // Get current state
      final currentState = container.read(notificationStateProvider);
      dump('📨 Notification received ${currentState.receiveCount} times');
      dump('📦 Last order ID: ${currentState.lastOrderId}');

      // Update order status in app state
      // container.read(orderProvider.notifier).updateOrderStatus(orderId);

      // Show in-app notification
      // container.read(snackBarProvider.notifier).show('New order update available');

      // Update notification badge
      // container.read(badgeProvider.notifier).increment();

      dump('✅ Successfully updated app state from notification receive');
    } catch (e) {
      dump('❌ Failed to handle order notification receive: $e');
    }
  }

  @override
  Future<void> onAction(NotificationResponse response, String actionId) async {
    dump(
      'Order notification action triggered: $actionId for order ${response.payload}',
    );

    try {
      final orderId = int.parse(response.payload ?? '0');

      switch (actionId) {
        case 'view_order':
          await onTap(response);
          break;

        case 'track_order':
          // Navigate to order tracking page
          // Example: context.go('/orders/$orderId/track');
          dump('Navigated to order tracking for order ID: $orderId');
          break;

        case 'cancel_order':
          // Show cancellation dialog
          // Example: showCancelOrderDialog(orderId);
          dump('Showing cancel order dialog for order ID: $orderId');
          break;

        case 'contact_support':
          // Navigate to support page with order context
          // Example: context.go('/support?orderId=$orderId');
          dump('Navigated to support for order ID: $orderId');
          break;

        default:
          dump('Unknown order notification action: $actionId');
      }
    } catch (e) {
      dump('Failed to handle order notification action: $e');
    }
  }

  @override
  Future<void> onDismiss(NotificationResponse response) async {
    dump('Order notification dismissed: ${response.payload}');

    try {
      final orderId = int.parse(response.payload ?? '0');

      // Mark notification as dismissed in app state
      // Example: ref.read(notificationProvider.notifier).markAsDismissed(response.id);

      // Update order notification status
      // Example: ref.read(orderProvider.notifier).markNotificationDismissed(orderId);

      dump('Marked order notification as dismissed for order ID: $orderId');
    } catch (e) {
      dump('Failed to handle order notification dismiss: $e');
    }
  }

  /// Get the order ID from the notification payload
  int? getOrderId(String? payload) {
    if (payload == null || payload.isEmpty) return null;

    try {
      return int.parse(payload);
    } catch (e) {
      return null;
    }
  }

  /// Check if the notification is for a specific order
  bool isForOrder(String? payload, int orderId) {
    final notificationOrderId = getOrderId(payload);
    return notificationOrderId == orderId;
  }

  /// Get notification actions for order notifications
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
    const AndroidNotificationAction(
      'contact_support',
      'Contact Support',
      icon: DrawableResourceAndroidBitmap('ic_support'),
    ),
  ];
}
