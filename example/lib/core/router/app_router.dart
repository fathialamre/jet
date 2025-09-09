import 'package:example/core/router/app_router.gr.dart';
import 'package:jet/jet_framework.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter({required this.ref});

  final Ref ref;
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page,),
    AutoRoute(page: RegisterRoute.page, initial: true),
    AutoRoute(page: OtpRoute.page),
    AutoRoute(page: InputsExampleRoute.page),
  ];

  @override
  List<AutoRouteGuard> get guards => [
    // AuthGuard(ref: ref),
  ];
}

final appRouter = AutoDisposeProvider<AppRouter>(
  (ref) => AppRouter(ref: ref),
);
