import 'package:jet/adapters/jet_adapter.dart';
import 'package:jet/jet.dart';
import 'package:jet/storage/local_storage.dart';

class StorageAdapter extends JetAdapter {
  @override
  Future<Jet> boot(Jet jet) async {
    await JetStorage.init();
    return jet;
  }
}
