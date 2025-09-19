import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../events/jet_notification_event.dart';

/// Configuration class for notification events in the Jet framework.
///
/// This class provides configuration options for notification events,
/// including channel settings, priority, and other platform-specific options.
class NotificationEventConfig {
  /// The notification event this config applies to
  final JetNotificationEvent event;

  /// Android channel ID for this event type
  final String? androidChannelId;

  /// Android channel name for this event type
  final String? androidChannelName;

  /// Android channel description for this event type
  final String? androidChannelDescription;

  /// Android importance level for this event type
  final Importance? androidImportance;

  /// Android priority level for this event type
  final Priority? androidPriority;

  /// Android notification color for this event type
  final Color? androidColor;

  /// Android notification icon for this event type
  final String? androidIcon;

  /// Android notification large icon for this event type
  final String? androidLargeIcon;

  /// Android notification sound for this event type
  final String? androidSound;

  /// Android notification vibration pattern for this event type
  final List<int>? androidVibrationPattern;

  /// Android notification actions for this event type
  final List<AndroidNotificationAction>? androidActions;

  /// iOS interruption level for this event type
  final InterruptionLevel? iosInterruptionLevel;

  /// iOS sound for this event type
  final String? iosSound;

  /// iOS badge number for this event type
  final int? iosBadgeNumber;

  /// iOS thread identifier for this event type
  final String? iosThreadIdentifier;

  /// iOS category identifier for this event type
  final String? iosCategoryIdentifier;

  /// Whether to show notification when app is in foreground
  final bool showInForeground;

  /// Whether to show notification when app is in background
  final bool showInBackground;

  /// Whether to show notification when app is terminated
  final bool showWhenTerminated;

  /// Whether to auto-cancel the notification when tapped
  final bool autoCancel;

  /// Whether to show notification timestamp
  final bool showWhen;

  /// Whether to enable notification lights (Android)
  final bool enableLights;

  /// Whether to enable notification vibration (Android)
  final bool enableVibration;

  /// Whether to show notification progress
  final bool showProgress;

  /// Maximum progress value
  final int? maxProgress;

  /// Current progress value
  final int? progress;

  /// Whether progress is indeterminate
  final bool indeterminate;

  /// Creates a new NotificationEventConfig
  const NotificationEventConfig({
    required this.event,
    this.androidChannelId,
    this.androidChannelName,
    this.androidChannelDescription,
    this.androidImportance,
    this.androidPriority,
    this.androidColor,
    this.androidIcon,
    this.androidLargeIcon,
    this.androidSound,
    this.androidVibrationPattern,
    this.androidActions,
    this.iosInterruptionLevel,
    this.iosSound,
    this.iosBadgeNumber,
    this.iosThreadIdentifier,
    this.iosCategoryIdentifier,
    this.showInForeground = true,
    this.showInBackground = true,
    this.showWhenTerminated = true,
    this.autoCancel = true,
    this.showWhen = true,
    this.enableLights = false,
    this.enableVibration = true,
    this.showProgress = false,
    this.maxProgress,
    this.progress,
    this.indeterminate = false,
  });

  /// Create a default config for an event
  factory NotificationEventConfig.defaultFor(JetNotificationEvent event) {
    return NotificationEventConfig(
      event: event,
      androidChannelId: '${event.name.toLowerCase()}_channel',
      androidChannelName: '${event.name} Notifications',
      androidChannelDescription: 'Notifications for ${event.name}',
      androidImportance: _getImportanceFromPriority(event.priority),
      androidPriority: _getPriorityFromPriority(event.priority),
      showInForeground: true,
      showInBackground: true,
      showWhenTerminated: true,
      autoCancel: true,
      showWhen: true,
      enableLights: false,
      enableVibration: true,
    );
  }

  /// Create a high priority config for an event
  factory NotificationEventConfig.highPriority(JetNotificationEvent event) {
    return NotificationEventConfig(
      event: event,
      androidChannelId: '${event.name.toLowerCase()}_high_priority_channel',
      androidChannelName: '${event.name} (High Priority)',
      androidChannelDescription:
          'High priority notifications for ${event.name}',
      androidImportance: Importance.high,
      androidPriority: Priority.high,
      androidColor: const Color(0xFFE53E3E), // Red color for high priority
      iosInterruptionLevel: InterruptionLevel.timeSensitive,
      showInForeground: true,
      showInBackground: true,
      showWhenTerminated: true,
      autoCancel: true,
      showWhen: true,
      enableLights: true,
      enableVibration: true,
    );
  }

  /// Create a low priority config for an event
  factory NotificationEventConfig.lowPriority(JetNotificationEvent event) {
    return NotificationEventConfig(
      event: event,
      androidChannelId: '${event.name.toLowerCase()}_low_priority_channel',
      androidChannelName: '${event.name} (Low Priority)',
      androidChannelDescription: 'Low priority notifications for ${event.name}',
      androidImportance: Importance.low,
      androidPriority: Priority.low,
      iosInterruptionLevel: InterruptionLevel.passive,
      showInForeground: false,
      showInBackground: true,
      showWhenTerminated: true,
      autoCancel: true,
      showWhen: true,
      enableLights: false,
      enableVibration: false,
    );
  }

  /// Create a silent config for an event
  factory NotificationEventConfig.silent(JetNotificationEvent event) {
    return NotificationEventConfig(
      event: event,
      androidChannelId: '${event.name.toLowerCase()}_silent_channel',
      androidChannelName: '${event.name} (Silent)',
      androidChannelDescription: 'Silent notifications for ${event.name}',
      androidImportance: Importance.min,
      androidPriority: Priority.min,
      iosInterruptionLevel: InterruptionLevel.passive,
      showInForeground: false,
      showInBackground: false,
      showWhenTerminated: false,
      autoCancel: true,
      showWhen: false,
      enableLights: false,
      enableVibration: false,
    );
  }

  /// Convert to Android notification details
  AndroidNotificationDetails toAndroidDetails() {
    return AndroidNotificationDetails(
      androidChannelId ?? '${event.name.toLowerCase()}_channel',
      androidChannelName ?? '${event.name} Notifications',
      channelDescription:
          androidChannelDescription ?? 'Notifications for ${event.name}',
      importance:
          androidImportance ?? _getImportanceFromPriority(event.priority),
      priority: androidPriority ?? _getPriorityFromPriority(event.priority),
      color: androidColor,
      icon: androidIcon,
      largeIcon: androidLargeIcon != null
          ? FilePathAndroidBitmap(androidLargeIcon!)
          : null,
      sound: androidSound != null
          ? RawResourceAndroidNotificationSound(androidSound!)
          : null,
      vibrationPattern: androidVibrationPattern != null
          ? Int64List.fromList(androidVibrationPattern!)
          : null,
      actions: androidActions,
      autoCancel: autoCancel,
      showWhen: showWhen,
      enableLights: enableLights,
      enableVibration: enableVibration,
      showProgress: showProgress,
      maxProgress: maxProgress ?? 0,
      progress: progress ?? 0,
      indeterminate: indeterminate,
    );
  }

  /// Convert to iOS notification details
  DarwinNotificationDetails toIOSDetails() {
    return DarwinNotificationDetails(
      presentAlert: showInForeground,
      presentBadge: showInForeground,
      presentSound: showInForeground,
      sound: iosSound,
      badgeNumber: iosBadgeNumber,
      threadIdentifier: iosThreadIdentifier,
      categoryIdentifier: iosCategoryIdentifier,
      interruptionLevel:
          iosInterruptionLevel ??
          _getInterruptionLevelFromPriority(event.priority),
    );
  }

  /// Convert to notification details
  NotificationDetails toNotificationDetails() {
    return NotificationDetails(
      android: toAndroidDetails(),
      iOS: toIOSDetails(),
    );
  }

  /// Helper method to convert NotificationPriority to Android Importance
  static Importance _getImportanceFromPriority(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return Importance.low;
      case NotificationPriority.normal:
        return Importance.defaultImportance;
      case NotificationPriority.high:
        return Importance.high;
      case NotificationPriority.critical:
        return Importance.max;
    }
  }

  /// Helper method to convert NotificationPriority to Android Priority
  static Priority _getPriorityFromPriority(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return Priority.low;
      case NotificationPriority.normal:
        return Priority.defaultPriority;
      case NotificationPriority.high:
        return Priority.high;
      case NotificationPriority.critical:
        return Priority.max;
    }
  }

  /// Helper method to convert NotificationPriority to iOS InterruptionLevel
  static InterruptionLevel _getInterruptionLevelFromPriority(
    NotificationPriority priority,
  ) {
    switch (priority) {
      case NotificationPriority.low:
        return InterruptionLevel.passive;
      case NotificationPriority.normal:
        return InterruptionLevel.active;
      case NotificationPriority.high:
        return InterruptionLevel.timeSensitive;
      case NotificationPriority.critical:
        return InterruptionLevel.critical;
    }
  }

  @override
  String toString() {
    return 'NotificationEventConfig(event: ${event.name}, channelId: $androidChannelId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationEventConfig &&
        other.event.id == event.id &&
        other.androidChannelId == androidChannelId;
  }

  @override
  int get hashCode => Object.hash(event.id, androidChannelId);
}
