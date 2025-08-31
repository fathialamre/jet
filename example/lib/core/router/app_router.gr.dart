// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:example/features/auth/login/pages/login_page.dart' as _i1;
import 'package:example/features/auth/register/pages/register_page.dart' as _i4;
import 'package:example/features/auth/register/pages/verify_register_page.dart'
    as _i5;
import 'package:example/features/posts/data/models/post_response.dart' as _i8;
import 'package:example/features/posts/post_details/pages/post_details_page.dart'
    as _i2;
import 'package:example/features/posts/posts_page.dart' as _i3;
import 'package:flutter/material.dart' as _i7;

/// generated route for
/// [_i1.LoginPage]
class LoginRoute extends _i6.PageRouteInfo<void> {
  const LoginRoute({List<_i6.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i1.LoginPage();
    },
  );
}

/// generated route for
/// [_i2.PostDetailsPage]
class PostDetailsRoute extends _i6.PageRouteInfo<PostDetailsRouteArgs> {
  PostDetailsRoute({
    _i7.Key? key,
    required _i8.PostResponse post,
    List<_i6.PageRouteInfo>? children,
  }) : super(
         PostDetailsRoute.name,
         args: PostDetailsRouteArgs(key: key, post: post),
         initialChildren: children,
       );

  static const String name = 'PostDetailsRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PostDetailsRouteArgs>();
      return _i2.PostDetailsPage(key: args.key, post: args.post);
    },
  );
}

class PostDetailsRouteArgs {
  const PostDetailsRouteArgs({this.key, required this.post});

  final _i7.Key? key;

  final _i8.PostResponse post;

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
/// [_i3.PostsPage]
class PostsRoute extends _i6.PageRouteInfo<void> {
  const PostsRoute({List<_i6.PageRouteInfo>? children})
    : super(PostsRoute.name, initialChildren: children);

  static const String name = 'PostsRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i3.PostsPage();
    },
  );
}

/// generated route for
/// [_i4.RegisterPage]
class RegisterRoute extends _i6.PageRouteInfo<void> {
  const RegisterRoute({List<_i6.PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i4.RegisterPage();
    },
  );
}

/// generated route for
/// [_i5.VerifyRegisterPage]
class VerifyRegisterRoute extends _i6.PageRouteInfo<VerifyRegisterRouteArgs> {
  VerifyRegisterRoute({
    _i7.Key? key,
    required String phone,
    List<_i6.PageRouteInfo>? children,
  }) : super(
         VerifyRegisterRoute.name,
         args: VerifyRegisterRouteArgs(key: key, phone: phone),
         initialChildren: children,
       );

  static const String name = 'VerifyRegisterRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VerifyRegisterRouteArgs>();
      return _i5.VerifyRegisterPage(key: args.key, phone: args.phone);
    },
  );
}

class VerifyRegisterRouteArgs {
  const VerifyRegisterRouteArgs({this.key, required this.phone});

  final _i7.Key? key;

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
