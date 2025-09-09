import 'package:jet/jet_framework.dart';
import 'package:example/features/pin_test_page.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter({required this.ref});

  final Ref ref;
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: PinTestRoute.page, path: '/', initial: true),
  ];

  @override
  List<AutoRouteGuard> get guards => [
    // AuthGuard(ref: ref),
  ];
}

final appRouter = AutoDisposeProvider<AppRouter>(
  (ref) => AppRouter(ref: ref),
);
