import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/config/jet_config.dart';
import 'package:jet/router/jet_router.dart';

class Jet {
  final JetConfig config;

  Jet({required this.config});

  AutoRouteProvider? _routerProvider;
  late ProviderContainer _container;

  void setRouter(AutoRouteProvider provider) {
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

  /// Set the ProviderContainer for accessing Riverpod providers throughout the app.
  ///
  /// This container is used by services and adapters to access Riverpod state
  /// outside of the widget tree, such as in notification handlers, background tasks,
  /// and other non-UI contexts.
  ///
  /// The container is automatically set during app initialization in boot.dart,
  /// before any adapters are executed.
  void setContainer(ProviderContainer container) {
    _container = container;
  }

  /// Get the ProviderContainer for accessing Riverpod providers.
  ///
  /// The container is guaranteed to be set before adapters run, so you can safely
  /// access it without null checks in adapter boot() methods and services.
  ///
  /// Example usage in adapters:
  /// ```dart
  /// class MyAdapter extends JetAdapter {
  ///   @override
  ///   Future<Jet?> boot(Jet jet) async {
  ///     final container = jet.container;  // No null check needed!
  ///     MyService.setContainer(container);
  ///   }
  /// }
  /// ```
  ProviderContainer get container => _container;

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
