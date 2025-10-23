import 'package:jet/adapters/jet_adapter.dart';
import 'package:jet/jet.dart';
import 'package:jet/notifications/jet_notifications.dart';
import 'package:jet/notifications/events/jet_notification_event_registry.dart';
import 'package:jet/helpers/jet_logger.dart';

class NotificationsAdapter extends JetAdapter {
  @override
  Future<Jet?> boot(Jet jet) async {
    try {
      // Register notification events from config
      if (jet.config.notificationEvents.isNotEmpty) {
        JetNotificationEventRegistry.registerAll(jet.config.notificationEvents);

        if (jet.config.enableNotificationEventLogging) {
          dump(
            'Registered ${jet.config.notificationEvents.length} notification events',
          );
        }
      }

      // Set the notification observer from config
      JetNotifications.setObserver(jet.config.notificationObserver);

      // Pass the WidgetRef from Jet to JetNotifications
      // This allows notification events to access Riverpod providers
      // The ref is guaranteed to be set before adapters run
      JetNotifications.setRef(jet.ref);

      // Initialize notifications
      await JetNotifications.initialize();

      return jet;
    } catch (e) {
      dump(
        'Failed to initialize notifications adapter: $e',
        tag: 'NOTIFICATIONS_ADAPTER',
      );
      rethrow;
    }
  }
}
