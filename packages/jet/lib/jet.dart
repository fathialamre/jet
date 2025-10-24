import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/config/jet_config.dart';
import 'package:jet/router/router_provider.dart';

class Jet {
  final JetConfig config;
  final RouterProvider? routerProvider;

  Jet({
    required this.config,
    this.routerProvider,
  });

  late Ref _ref;

  RouterProvider get getRouterProvider {
    if (routerProvider == null) {
      throw Exception(
        'Router provider not configured. Pass routerProvider to Jet constructor.',
      );
    }
    return routerProvider!;
  }

  RootStackRouter get router => _ref.read(routerProvider!);

  /// Set the Ref for accessing Riverpod providers throughout the app.
  ///
  /// This ref is used by services and adapters to access Riverpod state
  /// outside of the widget tree, such as in notification handlers, background tasks,
  /// and other non-UI contexts.
  ///
  /// The ref is automatically set during app initialization by the jetProvider override,
  /// before any adapters are executed.
  Jet setRef(Ref ref) {
    _ref = ref;
    return this;
  }

  /// Get the Ref for accessing Riverpod providers.
  ///
  /// The ref is guaranteed to be set before adapters run, so you can safely
  /// access it without null checks in adapter boot() methods and services.
  ///
  /// Example usage in adapters:
  /// ```dart
  /// class MyAdapter extends JetAdapter {
  ///   @override
  ///   Future<Jet?> boot(Jet jet) async {
  ///     final ref = jet.ref;  // No null check needed!
  ///     MyService.setRef(ref);
  ///   }
  /// }
  /// ```
  Ref get ref => _ref;

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
