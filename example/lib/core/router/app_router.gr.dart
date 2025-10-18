// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [BigFormPage]
class BigFormRoute extends PageRouteInfo<void> {
  const BigFormRoute({List<PageRouteInfo>? children})
    : super(BigFormRoute.name, initialChildren: children);

  static const String name = 'BigFormRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BigFormPage();
    },
  );
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [PostsGridPage]
class PostsGridRoute extends PageRouteInfo<void> {
  const PostsGridRoute({List<PageRouteInfo>? children})
    : super(PostsGridRoute.name, initialChildren: children);

  static const String name = 'PostsGridRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PostsGridPage();
    },
  );
}

/// generated route for
/// [PostsHorizontalPage]
class PostsHorizontalRoute extends PageRouteInfo<void> {
  const PostsHorizontalRoute({List<PageRouteInfo>? children})
    : super(PostsHorizontalRoute.name, initialChildren: children);

  static const String name = 'PostsHorizontalRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PostsHorizontalPage();
    },
  );
}

/// generated route for
/// [PostsPage]
class PostsRoute extends PageRouteInfo<void> {
  const PostsRoute({List<PageRouteInfo>? children})
    : super(PostsRoute.name, initialChildren: children);

  static const String name = 'PostsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PostsPage();
    },
  );
}

/// generated route for
/// [UserPostsPage]
class UserPostsRoute extends PageRouteInfo<UserPostsRouteArgs> {
  UserPostsRoute({Key? key, required int userId, List<PageRouteInfo>? children})
    : super(
        UserPostsRoute.name,
        args: UserPostsRouteArgs(key: key, userId: userId),
        rawPathParams: {'userId': userId},
        initialChildren: children,
      );

  static const String name = 'UserPostsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<UserPostsRouteArgs>(
        orElse: () => UserPostsRouteArgs(userId: pathParams.getInt('userId')),
      );
      return UserPostsPage(key: args.key, userId: args.userId);
    },
  );
}

class UserPostsRouteArgs {
  const UserPostsRouteArgs({this.key, required this.userId});

  final Key? key;

  final int userId;

  @override
  String toString() {
    return 'UserPostsRouteArgs{key: $key, userId: $userId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UserPostsRouteArgs) return false;
    return key == other.key && userId == other.userId;
  }

  @override
  int get hashCode => key.hashCode ^ userId.hashCode;
}
