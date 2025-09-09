// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:example/features/auth/otp/pages/otp_page.dart' as _i3;
import 'package:example/features/auth/register/pages/register_page.dart' as _i4;
import 'package:example/features/home/home_page.dart' as _i1;
import 'package:example/features/inputs/inptus_example.dart' as _i2;
import 'package:flutter/material.dart' as _i6;

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i5.PageRouteInfo<void> {
  const HomeRoute({List<_i5.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i1.HomePage();
    },
  );
}

/// generated route for
/// [_i2.InputsExamplePage]
class InputsExampleRoute extends _i5.PageRouteInfo<void> {
  const InputsExampleRoute({List<_i5.PageRouteInfo>? children})
    : super(InputsExampleRoute.name, initialChildren: children);

  static const String name = 'InputsExampleRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i2.InputsExamplePage();
    },
  );
}

/// generated route for
/// [_i3.OtpPage]
class OtpRoute extends _i5.PageRouteInfo<OtpRouteArgs> {
  OtpRoute({
    _i6.Key? key,
    required String phone,
    List<_i5.PageRouteInfo>? children,
  }) : super(
         OtpRoute.name,
         args: OtpRouteArgs(key: key, phone: phone),
         initialChildren: children,
       );

  static const String name = 'OtpRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OtpRouteArgs>();
      return _i3.OtpPage(key: args.key, phone: args.phone);
    },
  );
}

class OtpRouteArgs {
  const OtpRouteArgs({this.key, required this.phone});

  final _i6.Key? key;

  final String phone;

  @override
  String toString() {
    return 'OtpRouteArgs{key: $key, phone: $phone}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OtpRouteArgs) return false;
    return key == other.key && phone == other.phone;
  }

  @override
  int get hashCode => key.hashCode ^ phone.hashCode;
}

/// generated route for
/// [_i4.RegisterPage]
class RegisterRoute extends _i5.PageRouteInfo<void> {
  const RegisterRoute({List<_i5.PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i4.RegisterPage();
    },
  );
}
