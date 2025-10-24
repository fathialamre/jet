import 'package:jet/jet_framework.dart';

@Deprecated(
  'RouterAdapter is deprecated. '
  'Pass routerProvider directly to Boot.start() instead. '
  'Example: Boot.start(config, routerProvider: appRouter)',
)
class RouterAdapter implements JetAdapter {
  @override
  Future<Jet?> boot(Jet jet) async {
    // This adapter is deprecated and should not be used
    // Router is now configured via Boot.start(config, routerProvider: appRouter)
    return jet;
  }

  @override
  Future<void> afterBoot(Jet jet) async {}
}
