import 'package:example/core/router/app_router.gr.dart';
import 'package:jet/jet_framework.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  final Ref ref;

  AppRouter(this.ref);

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: HomeRoute.page,
      initial: true,
    ),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: SimpleTodoRoute.page),
    AutoRoute(page: TodoRoute.page),
    AutoRoute(page: SettingsRoute.page),
    AutoRoute(page: NotificationsExampleRoute.page),
  ];

  @override
  List<AutoRouteGuard> get guards => [
    // AuthGuard(ref: ref),
  ];
}

final appRouter = Provider<AppRouter>(AppRouter.new);
