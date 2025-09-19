import 'package:jet_flutter_framework/adapters/jet_adapter.dart';
import 'package:jet_flutter_framework/jet.dart';
import 'package:jet_flutter_framework/notifications/jet_notifications.dart';

class NotificationsAdapter extends JetAdapter {
  @override
  Future<Jet?> boot(Jet jet) async {
    await JetNotifications.initialize();
    return jet;
  }
}
