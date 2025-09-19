import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../jet_notifications.dart';
import 'jet_notification_event.dart';

/// Registry for managing notification events in the Jet framework.
///
/// This class provides a centralized way to register, retrieve, and manage
/// notification events. It follows the singleton pattern to ensure consistent
/// access throughout the application.
///
/// Example usage:
/// ```dart
/// // Register an event
/// JetNotificationEventRegistry.register(OrderNotificationEvent());
///
/// // Get an event by ID
/// final event = JetNotificationEventRegistry.getEvent(1);
///
/// // Get all events
/// final allEvents = JetNotificationEventRegistry.getAllEvents();
/// ```
class JetNotificationEventRegistry {
  static final Map<int, JetNotificationEvent> _events = {};
  static final Map<String, List<JetNotificationEvent>> _eventsByCategory = {};

  /// Register a notification event.
  ///
  /// If an event with the same ID is already registered, it will be
  /// replaced with the new event and a warning will be logged.
  ///
  /// Throws [ArgumentError] if the event is null or has an invalid ID.
  static void register(JetNotificationEvent event) {
    if (event.id <= 0) {
      throw ArgumentError('Notification event ID must be greater than 0');
    }

    if (_events.containsKey(event.id)) {
      JetNotifications.observer?.onEventReplacement(
        eventId: event.id,
      );
    }

    _events[event.id] = event;

    // Group by category if specified
    if (event.category != null) {
      _eventsByCategory.putIfAbsent(event.category!, () => []);
      _eventsByCategory[event.category!]!.add(event);
    }

    JetNotifications.observer?.onEventRegistration(
      eventName: event.name,
      eventId: event.id,
    );
  }

  /// Register multiple notification events at once.
  ///
  /// This is a convenience method for registering multiple events
  /// in a single call.
  ///
  /// Throws [ArgumentError] if any event is null or has an invalid ID.
  static void registerAll(List<JetNotificationEvent> events) {
    for (final event in events) {
      register(event);
    }
  }

  /// Get a notification event by its ID.
  ///
  /// Returns the event if found, null otherwise.
  static JetNotificationEvent? getEvent(int id) {
    return _events[id];
  }

  /// Get all registered notification events.
  ///
  /// Returns a list of all registered events.
  static List<JetNotificationEvent> getAllEvents() {
    return _events.values.toList();
  }

  /// Get notification events by category.
  ///
  /// Returns a list of events that belong to the specified category.
  static List<JetNotificationEvent> getEventsByCategory(String category) {
    return _eventsByCategory[category] ?? [];
  }

  /// Get all available categories.
  ///
  /// Returns a list of all categories that have registered events.
  static List<String> getCategories() {
    return _eventsByCategory.keys.toList();
  }

  /// Check if an event with the given ID is registered.
  ///
  /// Returns true if the event is registered, false otherwise.
  static bool hasEvent(int id) {
    return _events.containsKey(id);
  }

  /// Get the number of registered events.
  ///
  /// Returns the total number of registered events.
  static int get eventCount => _events.length;

  /// Clear all registered events.
  ///
  /// This method removes all events from the registry. Use with caution
  /// as this will affect all notification handling.
  static void clear() {
    final count = _events.length;
    _events.clear();
    _eventsByCategory.clear();

    JetNotifications.observer?.onEventClearing(count: count);
  }

  /// Remove a specific event by ID.
  ///
  /// Returns true if the event was removed, false if it wasn't found.
  static bool unregister(int id) {
    final event = _events.remove(id);
    if (event != null) {
      // Remove from category grouping
      if (event.category != null) {
        _eventsByCategory[event.category!]?.remove(event);
        if (_eventsByCategory[event.category!]!.isEmpty) {
          _eventsByCategory.remove(event.category!);
        }
      }

      JetNotifications.observer?.onEventUnregistration(
        eventName: event.name,
        eventId: id,
      );
      return true;
    }
    return false;
  }

  /// Find an event that should handle the given notification response.
  ///
  /// This method iterates through all registered events and returns the
  /// first one that should handle the given response based on the
  /// [JetNotificationEvent.shouldHandle] method.
  ///
  /// Returns the event if found, null otherwise.
  static JetNotificationEvent? findHandler(NotificationResponse response) {
    for (final event in _events.values) {
      if (event.shouldHandle(response)) {
        return event;
      }
    }
    return null;
  }

  /// Get a summary of all registered events.
  ///
  /// Returns a map with event information for debugging purposes.
  static Map<String, dynamic> getSummary() {
    return {
      'totalEvents': _events.length,
      'categories': _eventsByCategory.keys.toList(),
      'events': _events.entries
          .map(
            (entry) => {
              'id': entry.key,
              'name': entry.value.name,
              'category': entry.value.category,
              'priority': entry.value.priority.name,
            },
          )
          .toList(),
    };
  }
}
