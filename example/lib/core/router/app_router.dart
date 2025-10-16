import 'package:jet/jet_framework.dart';
import '../../features/home/home_page.dart';
import '../../features/login/login_page.dart';
import '../../features/big_form/big_form_page.dart';
import '../../features/posts/posts_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  final Ref ref;

  AppRouter(this.ref);

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, path: '/', initial: true),
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(page: BigFormRoute.page, path: '/big-form'),
    AutoRoute(page: PostsRoute.page, path: '/posts'),
  ];

  @override
  List<AutoRouteGuard> get guards => [
    // AuthGuard(ref: ref),
  ];
}

final appRouter = Provider<AppRouter>(AppRouter.new);
