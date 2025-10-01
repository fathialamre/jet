import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jet/helpers/jet_logger.dart';

/// Observer class for handling notification-related events.
///
/// This class provides the default logging behavior for all notification events.
/// It uses the dump() helper function with appropriate tags for each event type.
/// You can extend this class to customize notification event handling.
class JetNotificationObserver {
  /// Handle notification initialization
  void onInitialization({required String message}) {
    dump(message, tag: 'JET_NOTIFICATIONS_INIT');
  }

  /// Handle notification initialization errors
  void onInitializationError({required String message, Object? error}) {
    dump(
      '$message${error != null ? ': $error' : ''}',
      tag: 'JET_NOTIFICATIONS_INIT_ERROR',
    );
  }

  /// Handle notification response
  void onResponse({required NotificationResponse response}) {
    dump(
      "Received notification response: ${response.id}",
      tag: 'JET_NOTIFICATIONS_RESPONSE',
    );
  }

  /// Handle when event handlers are found
  void onEventHandlerFound({
    required String eventName,
    required int notificationId,
    required NotificationResponse response,
  }) {
    dump(
      "Found event handler: $eventName for notification $notificationId",
      tag: 'JET_NOTIFICATIONS_EVENT_HANDLER',
    );
  }

  /// Handle when no event handlers are found
  void onNoEventHandler({
    required int notificationId,
    required NotificationResponse response,
  }) {
    dump(
      "No event handler found for notification $notificationId",
      tag: 'JET_NOTIFICATIONS_NO_HANDLER',
    );
  }

  /// Handle general notification errors
  void onError({required String message, Object? error}) {
    dump(
      '$message${error != null ? ': $error' : ''}',
      tag: 'JET_NOTIFICATIONS_ERROR',
    );
  }

  /// Handle background notification responses
  void onBackgroundResponse({required NotificationResponse response}) {
    dump(
      "Received background notification response: ${response.id}",
      tag: 'JET_NOTIFICATIONS_BACKGROUND_RESPONSE',
    );
  }

  /// Handle background event handlers found
  void onBackgroundEventHandlerFound({
    required String eventName,
    required int notificationId,
    required NotificationResponse response,
  }) {
    dump(
      "Found background event handler: $eventName for notification $notificationId",
      tag: 'JET_NOTIFICATIONS_BACKGROUND_HANDLER',
    );
  }

  /// Handle when no background event handlers are found
  void onNoBackgroundEventHandler({
    required int notificationId,
    required NotificationResponse response,
  }) {
    dump(
      "No background event handler found for notification $notificationId",
      tag: 'JET_NOTIFICATIONS_BACKGROUND_NO_HANDLER',
    );
  }

  /// Handle background notification errors
  void onBackgroundError({required String message, Object? error}) {
    dump(
      '$message${error != null ? ': $error' : ''}',
      tag: 'JET_NOTIFICATIONS_BACKGROUND_ERROR',
    );
  }

  /// Handle onReceive event triggering
  void onReceive({required int notificationId, String? payload}) {
    dump(
      "🚀 Triggering onReceive event for notification: $notificationId with payload: $payload",
      tag: 'JET_NOTIFICATIONS_ON_RECEIVE',
    );
  }

  /// Handle onReceive event handlers found
  void onReceiveHandlerFound({
    required String eventName,
    required int notificationId,
    required String? payload,
  }) {
    dump(
      "✅ Found event handler: $eventName for notification $notificationId",
      tag: 'JET_NOTIFICATIONS_ON_RECEIVE_HANDLER',
    );
  }

  /// Handle onReceive event completion
  void onReceiveCompleted({required int notificationId, String? payload}) {
    dump(
      "🎉 onReceive event completed for notification $notificationId",
      tag: 'JET_NOTIFICATIONS_ON_RECEIVE_COMPLETED',
    );
  }

  /// Handle when no onReceive handlers are found
  void onNoReceiveHandler({required int notificationId, String? payload}) {
    dump(
      "⚠️ No event handler found for notification $notificationId",
      tag: 'JET_NOTIFICATIONS_ON_RECEIVE_NO_HANDLER',
    );
  }

  /// Handle onReceive errors
  void onReceiveError({
    required String message,
    Object? error,
    int? notificationId,
    String? payload,
  }) {
    dump(
      "❌ Error triggering onReceive event: $message${error != null ? ': $error' : ''}",
      tag: 'JET_NOTIFICATIONS_ON_RECEIVE_ERROR',
    );
  }

  /// Handle notification scheduling
  void onScheduling({
    required String message,
    required DateTime scheduledTime,
  }) {
    dump(message, tag: 'JET_NOTIFICATIONS_SCHEDULE');
  }

  /// Handle parsed scheduled times
  void onSchedulingParsed({
    required String message,
    required DateTime parsedTime,
  }) {
    dump(message, tag: 'JET_NOTIFICATIONS_SCHEDULE_PARSED');
  }

  /// Handle successful scheduling
  void onSchedulingSuccess({
    required String message,
    required DateTime scheduledTime,
  }) {
    dump(message, tag: 'JET_NOTIFICATIONS_SCHEDULE_SUCCESS');
  }

  /// Handle background tap
  void onBackgroundTap({required NotificationResponse response}) {
    dump(
      "Background tap handler called for notification ${response.id}",
      tag: 'JET_NOTIFICATIONS_BACKGROUND_TAP',
    );
  }

  /// Handle background tap handlers found
  void onBackgroundTapHandlerFound({
    required String eventName,
    required int notificationId,
    required NotificationResponse response,
  }) {
    dump(
      "Found background event handler: $eventName for notification $notificationId",
      tag: 'JET_NOTIFICATIONS_BACKGROUND_TAP_HANDLER',
    );
  }

  /// Handle when no background tap handlers are found
  void onNoBackgroundTapHandler({
    required int notificationId,
    required NotificationResponse response,
  }) {
    dump(
      "No background event handler found for notification $notificationId",
      tag: 'JET_NOTIFICATIONS_BACKGROUND_TAP_NO_HANDLER',
    );
  }

  /// Handle background tap errors
  void onBackgroundTapError({
    required String message,
    Object? error,
    required NotificationResponse response,
  }) {
    dump(
      "Error in background tap handler: $message${error != null ? ': $error' : ''}",
      tag: 'JET_NOTIFICATIONS_BACKGROUND_TAP_ERROR',
    );
  }

  /// Handle event registry operations
  void onRegistryOperation({required String message}) {
    dump(message, tag: 'NOTIFICATION_REGISTRY');
  }

  /// Handle event replacement in registry
  void onEventReplacement({required int eventId}) {
    onRegistryOperation(
      message: 'Replacing existing notification event with ID $eventId',
    );
  }

  /// Handle event registration in registry
  void onEventRegistration({required String eventName, required int eventId}) {
    onRegistryOperation(
      message: 'Registered notification event: $eventName (ID: $eventId)',
    );
  }

  /// Handle event clearing from registry
  void onEventClearing({required int count}) {
    onRegistryOperation(
      message: 'Cleared $count notification events from registry',
    );
  }

  /// Handle event unregistration from registry
  void onEventUnregistration({
    required String eventName,
    required int eventId,
  }) {
    onRegistryOperation(
      message: 'Unregistered notification event: $eventName (ID: $eventId)',
    );
  }
}
