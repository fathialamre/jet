import 'package:example/core/router/app_router.dart';
import 'package:jet/jet_framework.dart';


class RouterAdapter implements JetAdapter {
  @override
  Future<Jet?> boot(Jet jet) async {
    jet.setRouter(appRouter);
    // This adapter is deprecated and should not be used
    // Router is now configured via Boot.start(config, routerProvider: appRouter)
    return jet;
  }

  @override
  Future<void> afterBoot(Jet jet) async {}
}
