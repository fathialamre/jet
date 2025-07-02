import 'package:example/core/router/app_router.dart';
import 'package:jet/jet_framework.dart';

class RouterAdapter implements JetAdapter {
  @override
  Future<Jet?> boot(Jet jet) async {
    jet.setRouter(appRouter);
    return jet;
  }

  @override
  Future<void> afterBoot(Jet jet) async {}
}
