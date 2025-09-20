import 'package:jet/adapters/jet_adapter.dart';
import 'package:jet/helpers/jet_logger.dart';
import 'package:jet/jet.dart';
import 'package:jet/storage/jet_cache.dart';

class CacheAdapter extends JetAdapter {
  @override
  Future<Jet?> boot(Jet jet) async {
    await JetCache.init();

    dump('Cache adapter initialized', tag: 'JET_CACHE');
    return jet;
  }
}
