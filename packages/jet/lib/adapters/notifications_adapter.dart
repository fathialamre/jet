import 'package:jet/adapters/jet_adapter.dart';
import 'package:jet/jet.dart';
import 'package:jet/notifications/jet_notifications.dart';

class NotificationsAdapter extends JetAdapter {
  @override
  Future<Jet?> boot(Jet jet) async {
    await JetNotifications.initialize();
    return jet;
  }
}
