import 'package:example/core/router/app_router.gr.dart';
import 'package:example/core/router/guards/auth_guard.dart';
import 'package:jet/jet_framework.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter({required this.ref});

  final Ref ref;
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, keepHistory: false, initial: true),
    AutoRoute(
      page: RegisterRoute.page,
    ),
    AutoRoute(page: VerifyRegisterRoute.page),
    AutoRoute(page: PostsRoute.page, ),
    AutoRoute(page: PostDetailsRoute.page),
    AutoRoute(
      page: ProfileRoute.page,
      guards: [AuthGuard(ref: ref)],
    ),
    AutoRoute(page: HomeRoute.page),
  ];

  @override
  List<AutoRouteGuard> get guards => [
    // AuthGuard(ref: ref),
  ];
}

final appRouter = AutoDisposeProvider<AppRouter>(
  (ref) => AppRouter(ref: ref),
);
