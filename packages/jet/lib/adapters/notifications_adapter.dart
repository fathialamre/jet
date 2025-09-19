import 'package:jet_flutter_framework/adapters/jet_adapter.dart';
import 'package:jet_flutter_framework/jet.dart';
import 'package:jet_flutter_framework/notifications/jet_notifications.dart';
import 'package:jet_flutter_framework/notifications/events/jet_notification_event_registry.dart';
import 'package:jet_flutter_framework/helpers/jet_logger.dart';

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
