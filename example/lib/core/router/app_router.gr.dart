// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i13;
import 'package:example/features/actions/actions/actions_page.dart' as _i1;
import 'package:example/features/auth/login/pages/login_page.dart' as _i4;
import 'package:example/features/auth/register/pages/register_page.dart'
    as _i10;
import 'package:example/features/auth/register/pages/verify_register_page.dart'
    as _i12;
import 'package:example/features/home/home_page.dart' as _i2;
import 'package:example/features/home/profile_page.dart' as _i9;
import 'package:example/features/main_layout/main_layout_page.dart' as _i5;
import 'package:example/features/posts/data/models/post_response.dart' as _i15;
import 'package:example/features/posts/post_details/pages/post_details_page.dart'
    as _i7;
import 'package:example/features/posts/posts_page.dart' as _i8;
import 'package:example/features/tabs/limited_page.dart' as _i3;
import 'package:example/features/tabs/pcakges_page.dart' as _i6;
import 'package:example/features/tabs/unlimited_page.dart' as _i11;
import 'package:flutter/material.dart' as _i14;

/// generated route for
/// [_i1.ActionsPage]
class ActionsRoute extends _i13.PageRouteInfo<void> {
  const ActionsRoute({List<_i13.PageRouteInfo>? children})
    : super(ActionsRoute.name, initialChildren: children);

  static const String name = 'ActionsRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i1.ActionsPage();
    },
  );
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i13.PageRouteInfo<void> {
  const HomeRoute({List<_i13.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomePage();
    },
  );
}

/// generated route for
/// [_i3.LimitedPage]
class LimitedRoute extends _i13.PageRouteInfo<void> {
  const LimitedRoute({List<_i13.PageRouteInfo>? children})
    : super(LimitedRoute.name, initialChildren: children);

  static const String name = 'LimitedRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i3.LimitedPage();
    },
  );
}

/// generated route for
/// [_i4.LoginPage]
class LoginRoute extends _i13.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i14.Key? key,
    dynamic Function(bool)? onResult,
    List<_i13.PageRouteInfo>? children,
  }) : super(
         LoginRoute.name,
         args: LoginRouteArgs(key: key, onResult: onResult),
         initialChildren: children,
       );

  static const String name = 'LoginRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoginRouteArgs>(
        orElse: () => const LoginRouteArgs(),
      );
      return _i4.LoginPage(key: args.key, onResult: args.onResult);
    },
  );
}

class LoginRouteArgs {
  const LoginRouteArgs({this.key, this.onResult});

  final _i14.Key? key;

  final dynamic Function(bool)? onResult;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onResult: $onResult}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LoginRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i5.MainLayoutPage]
class MainLayoutRoute extends _i13.PageRouteInfo<void> {
  const MainLayoutRoute({List<_i13.PageRouteInfo>? children})
    : super(MainLayoutRoute.name, initialChildren: children);

  static const String name = 'MainLayoutRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i5.MainLayoutPage();
    },
  );
}

/// generated route for
/// [_i6.PackagesPage]
class PackagesRoute extends _i13.PageRouteInfo<void> {
  const PackagesRoute({List<_i13.PageRouteInfo>? children})
    : super(PackagesRoute.name, initialChildren: children);

  static const String name = 'PackagesRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i6.PackagesPage();
    },
  );
}

/// generated route for
/// [_i7.PostDetailsPage]
class PostDetailsRoute extends _i13.PageRouteInfo<PostDetailsRouteArgs> {
  PostDetailsRoute({
    _i14.Key? key,
    required _i15.PostResponse post,
    List<_i13.PageRouteInfo>? children,
  }) : super(
         PostDetailsRoute.name,
         args: PostDetailsRouteArgs(key: key, post: post),
         initialChildren: children,
       );

  static const String name = 'PostDetailsRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PostDetailsRouteArgs>();
      return _i7.PostDetailsPage(key: args.key, post: args.post);
    },
  );
}

class PostDetailsRouteArgs {
  const PostDetailsRouteArgs({this.key, required this.post});

  final _i14.Key? key;

  final _i15.PostResponse post;

  @override
  String toString() {
    return 'PostDetailsRouteArgs{key: $key, post: $post}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PostDetailsRouteArgs) return false;
    return key == other.key && post == other.post;
  }

  @override
  int get hashCode => key.hashCode ^ post.hashCode;
}

/// generated route for
/// [_i8.PostsPage]
class PostsRoute extends _i13.PageRouteInfo<void> {
  const PostsRoute({List<_i13.PageRouteInfo>? children})
    : super(PostsRoute.name, initialChildren: children);

  static const String name = 'PostsRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i8.PostsPage();
    },
  );
}

/// generated route for
/// [_i9.ProfilePage]
class ProfileRoute extends _i13.PageRouteInfo<void> {
  const ProfileRoute({List<_i13.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i9.ProfilePage();
    },
  );
}

/// generated route for
/// [_i10.RegisterPage]
class RegisterRoute extends _i13.PageRouteInfo<void> {
  const RegisterRoute({List<_i13.PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i10.RegisterPage();
    },
  );
}

/// generated route for
/// [_i11.UnlimitedPage]
class UnlimitedRoute extends _i13.PageRouteInfo<void> {
  const UnlimitedRoute({List<_i13.PageRouteInfo>? children})
    : super(UnlimitedRoute.name, initialChildren: children);

  static const String name = 'UnlimitedRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i11.UnlimitedPage();
    },
  );
}

/// generated route for
/// [_i12.VerifyRegisterPage]
class VerifyRegisterRoute extends _i13.PageRouteInfo<VerifyRegisterRouteArgs> {
  VerifyRegisterRoute({
    _i14.Key? key,
    required String phone,
    List<_i13.PageRouteInfo>? children,
  }) : super(
         VerifyRegisterRoute.name,
         args: VerifyRegisterRouteArgs(key: key, phone: phone),
         initialChildren: children,
       );

  static const String name = 'VerifyRegisterRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VerifyRegisterRouteArgs>();
      return _i12.VerifyRegisterPage(key: args.key, phone: args.phone);
    },
  );
}

class VerifyRegisterRouteArgs {
  const VerifyRegisterRouteArgs({this.key, required this.phone});

  final _i14.Key? key;

  final String phone;

  @override
  String toString() {
    return 'VerifyRegisterRouteArgs{key: $key, phone: $phone}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VerifyRegisterRouteArgs) return false;
    return key == other.key && phone == other.phone;
  }

  @override
  int get hashCode => key.hashCode ^ phone.hashCode;
}
