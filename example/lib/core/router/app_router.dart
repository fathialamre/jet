import 'package:example/core/router/app_router.gr.dart';
import 'package:jet/jet_framework.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegisterRoute.page, ),
    AutoRoute(page: VerifyRegisterRoute.page),
    AutoRoute(page: PostsRoute.page, initial: true),
    AutoRoute(page: PostDetailsRoute.page),
  ];
}

final appRouter = AutoDisposeProvider<AppRouter>(
  (ref) => AppRouter(),
);
