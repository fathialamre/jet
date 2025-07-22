import 'package:example/features/login/pages/login_page.dart';
import 'package:example/features/posts/post_details/pages/post_details_page.dart';
import 'package:example/features/posts/posts_page.dart';
import 'package:example/features/products/products_page.dart';
import 'package:jet/jet_framework.dart';

class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    NamedRouteDef(
      name: 'LoginRoute',
      builder: (context, args) => LoginPage(),
            initial: true,

    ),
    NamedRouteDef(
      name: 'PostsRoute',
      builder: (context, args) => PostsPage(),
    ),
    NamedRouteDef(
      name: 'PostDetailsRoute',
      builder: (context, args) => PostDetailsPage(),
    ),
    NamedRouteDef(
      name: 'InfiniteScrollExampleRoute',
      builder: (context, args) => ProductsPage(),
    ),
  ];
}

final appRouter = AutoDisposeProvider<AppRouter>(
  (ref) => AppRouter(),
);
