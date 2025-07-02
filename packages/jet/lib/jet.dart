import 'package:jet/config/jet_config.dart';
import 'package:jet/router/jet_router.dart';

class Jet {
  final JetConfig config;

  Jet({required this.config});

  AutoRouteProvider? _routerProvider;

  setRouter(AutoRouteProvider provider) {
    _routerProvider = provider;
  }

  AutoRouteProvider get routerProvider {
    if (_routerProvider == null) {
      throw Exception(
        'You must register a router provider before using adapters',
      );
    }
    return _routerProvider!;
  }

  static Future<Jet> fly({
    required Future<Jet> Function() setup,
    Future<void> Function(Jet jet)? setupFinished,
  }) async {
    final jetApp = await setup();

    if (setupFinished != null) {
      await setupFinished(jetApp);
    }

    return jetApp;
  }
}
