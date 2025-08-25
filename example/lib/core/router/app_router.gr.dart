// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:example/features/auth/login/pages/login_page.dart' as _i1;
import 'package:example/features/auth/register/pages/register_page.dart' as _i2;
import 'package:example/features/auth/register/pages/verify_register_page.dart'
    as _i3;
import 'package:flutter/material.dart' as _i5;

/// generated route for
/// [_i1.LoginPage]
class LoginRoute extends _i4.PageRouteInfo<void> {
  const LoginRoute({List<_i4.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i1.LoginPage();
    },
  );
}

/// generated route for
/// [_i2.RegisterPage]
class RegisterRoute extends _i4.PageRouteInfo<void> {
  const RegisterRoute({List<_i4.PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i2.RegisterPage();
    },
  );
}

/// generated route for
/// [_i3.VerifyRegisterPage]
class VerifyRegisterRoute extends _i4.PageRouteInfo<VerifyRegisterRouteArgs> {
  VerifyRegisterRoute({
    _i5.Key? key,
    required String phone,
    List<_i4.PageRouteInfo>? children,
  }) : super(
         VerifyRegisterRoute.name,
         args: VerifyRegisterRouteArgs(key: key, phone: phone),
         initialChildren: children,
       );

  static const String name = 'VerifyRegisterRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VerifyRegisterRouteArgs>();
      return _i3.VerifyRegisterPage(key: args.key, phone: args.phone);
    },
  );
}

class VerifyRegisterRouteArgs {
  const VerifyRegisterRouteArgs({this.key, required this.phone});

  final _i5.Key? key;

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
