import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Wrapper class for NotificationResponse that provides additional functionality
/// and type safety for notification handling in the Jet framework.
///
/// This class extends the basic NotificationResponse with additional methods
/// and properties that are useful for notification event handling.
class NotificationResponseWrapper {
  /// The original NotificationResponse from flutter_local_notifications
  final NotificationResponse response;

  /// Creates a wrapper around a NotificationResponse
  const NotificationResponseWrapper(this.response);

  /// The notification ID
  int get id => response.id ?? 0;

  /// The notification payload
  String? get payload => response.payload;

  /// The action ID (if the notification was triggered by an action)
  String? get actionId => response.actionId;

  /// The input text (if the notification had a text input action)
  String? get input => response.input;

  /// The notification tag (Android only) - not available in current version
  String? get tag => null;

  /// The notification channel ID (Android only) - not available in current version
  String? get channelId => null;

  /// The notification category (iOS only) - not available in current version
  String? get category => null;

  /// The notification thread identifier (iOS only) - not available in current version
  String? get threadIdentifier => null;

  /// The notification user info (iOS only) - not available in current version
  Map<String, dynamic>? get userInfo => null;

  /// Check if this response was triggered by a notification tap
  bool get isTap => actionId == null;

  /// Check if this response was triggered by an action button
  bool get isAction => actionId != null;

  /// Check if this response has a payload
  bool get hasPayload => payload != null && payload!.isNotEmpty;

  /// Check if this response has input text
  bool get hasInput => input != null && input!.isNotEmpty;

  /// Parse the payload as JSON if it's valid JSON
  Map<String, dynamic>? get payloadAsJson {
    if (!hasPayload) return null;

    try {
      return jsonDecode(payload!) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Get a specific value from the payload JSON
  T? getPayloadValue<T>(String key) {
    final json = payloadAsJson;
    if (json == null) return null;

    return json[key] as T?;
  }

  /// Get the notification type from the payload
  String? get notificationType => getPayloadValue<String>('type');

  /// Get the notification data from the payload
  Map<String, dynamic>? get notificationData =>
      getPayloadValue<Map<String, dynamic>>('data');

  /// Get the notification title from the payload
  String? get notificationTitle => getPayloadValue<String>('title');

  /// Get the notification body from the payload
  String? get notificationBody => getPayloadValue<String>('body');

  /// Check if this notification matches a specific type
  bool isType(String type) {
    return notificationType == type;
  }

  /// Check if this notification has a specific action
  bool hasAction(String action) {
    return actionId == action;
  }

  /// Get a human-readable description of this response
  String get description {
    final buffer = StringBuffer();
    buffer.write('NotificationResponse(id: $id');

    if (hasPayload) {
      buffer.write(', payload: $payload');
    }

    if (isAction) {
      buffer.write(', action: $actionId');
    }

    if (hasInput) {
      buffer.write(', input: $input');
    }

    if (tag != null) {
      buffer.write(', tag: $tag');
    }

    buffer.write(')');
    return buffer.toString();
  }

  /// Convert to a map for serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'payload': payload,
      'actionId': actionId,
      'input': input,
      'tag': tag,
      'channelId': channelId,
      'category': category,
      'threadIdentifier': threadIdentifier,
      'userInfo': userInfo,
      'isTap': isTap,
      'isAction': isAction,
      'hasPayload': hasPayload,
      'hasInput': hasInput,
    };
  }

  @override
  String toString() => description;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationResponseWrapper && other.response == response;
  }

  @override
  int get hashCode => response.hashCode;
}
