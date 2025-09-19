import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Abstract base class for handling notification events in the Jet framework.
///
/// This class provides a type-safe, extensible way to handle different types
/// of notifications. Each notification type should extend this class and
/// implement the required methods.
///
/// Example usage:
/// ```dart
/// class OrderNotificationEvent extends JetNotificationEvent {
///   @override
///   int get id => 1;
///
///   @override
///   String get name => 'OrderNotification';
///
///   @override
///   Future<void> onTap(NotificationResponse response) async {
///     // Handle order notification tap
///   }
/// }
/// ```
abstract class JetNotificationEvent {
  /// Unique identifier for this notification type.
  ///
  /// This ID should be unique across all notification events in your app.
  /// It's used to match notifications with their corresponding event handlers.
  int get id;

  /// Human-readable name for this notification event.
  ///
  /// Used for debugging and logging purposes.
  String get name;

  /// Handle notification tap event.
  ///
  /// This method is called when a user taps on a notification, regardless
  /// of whether the app is in the foreground, background, or terminated.
  ///
  /// The [response] contains information about the notification including
  /// the payload, action ID, and input text (if applicable).
  Future<void> onTap(NotificationResponse response);

  /// Handle notification received event.
  ///
  /// This method is called when a notification is received while the app
  /// is in the foreground. It's useful for updating UI state or showing
  /// in-app notifications.
  ///
  /// The [response] contains information about the received notification.
  Future<void> onReceive(NotificationResponse response);

  /// Handle notification dismissed event.
  ///
  /// This method is called when a notification is dismissed by the user
  /// or system. It's optional and can be overridden if needed.
  ///
  /// The [response] contains information about the dismissed notification.
  Future<void> onDismiss(NotificationResponse response) async {
    // Default implementation does nothing
  }

  /// Handle notification action button pressed.
  ///
  /// This method is called when a user taps on an action button in a
  /// notification. It's optional and can be overridden if needed.
  ///
  /// The [response] contains information about the notification and action.
  /// The [actionId] identifies which action button was pressed.
  Future<void> onAction(NotificationResponse response, String actionId) async {
    // Default implementation does nothing
  }

  /// Validate that the notification payload is valid for this event type.
  ///
  /// Override this method to add custom validation logic for the payload.
  /// This is called before [onTap] and [onReceive] methods.
  ///
  /// Returns true if the payload is valid, false otherwise.
  bool validatePayload(String? payload) {
    return true; // Default implementation accepts all payloads
  }

  /// Get the notification category for this event type.
  ///
  /// This is used for grouping related notifications and can be used
  /// for platform-specific features like notification channels.
  String? get category => null;

  /// Get the notification priority for this event type.
  ///
  /// This can be used to determine the importance of notifications
  /// of this type.
  NotificationPriority get priority => NotificationPriority.normal;

  /// Check if this event should handle the given notification response.
  ///
  /// Override this method to add custom logic for determining whether
  /// this event should handle a particular notification.
  bool shouldHandle(NotificationResponse response) {
    return response.id == id && validatePayload(response.payload);
  }
}

/// Enum for notification priorities.
enum NotificationPriority {
  /// Low priority - notifications may be delayed or grouped
  low,

  /// Normal priority - standard notification behavior
  normal,

  /// High priority - notifications are shown immediately
  high,

  /// Critical priority - notifications bypass do not disturb mode
  critical,
}

/// Extension on NotificationPriority for platform-specific mapping.
extension NotificationPriorityExtension on NotificationPriority {
  /// Convert to Android importance level.
  int get androidImportance {
    switch (this) {
      case NotificationPriority.low:
        return 2; // Importance.low
      case NotificationPriority.normal:
        return 3; // Importance.default
      case NotificationPriority.high:
        return 4; // Importance.high
      case NotificationPriority.critical:
        return 5; // Importance.max
    }
  }

  /// Convert to iOS interruption level.
  String get iosInterruptionLevel {
    switch (this) {
      case NotificationPriority.low:
        return 'passive';
      case NotificationPriority.normal:
        return 'active';
      case NotificationPriority.high:
        return 'timeSensitive';
      case NotificationPriority.critical:
        return 'critical';
    }
  }
}
