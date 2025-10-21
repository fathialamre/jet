import 'package:example/features/posts/pages/post_details_page.dart';
import 'package:example/features/posts/pages/posts_page.dart';
import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  final Ref ref;

  AppRouter(this.ref);

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: PostsRoute.page, initial: true),
    AutoRoute(page: PostDetailsRoute.page),
  ];

  @override
  List<AutoRouteGuard> get guards => [
    // AuthGuard(ref: ref),
  ];
}

final appRouter = Provider<AppRouter>(AppRouter.new);
