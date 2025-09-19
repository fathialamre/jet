import 'package:jet_flutter_framework/adapters/jet_adapter.dart';
import 'package:jet_flutter_framework/jet.dart';
import 'package:jet_flutter_framework/storage/local_storage.dart';

class StorageAdapter extends JetAdapter {
  @override
  Future<Jet> boot(Jet jet) async {
    await JetStorage.init();
    return jet;
  }
}
