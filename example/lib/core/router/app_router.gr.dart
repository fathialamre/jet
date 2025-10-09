// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:example/features/home/home_page.dart' as _i1;
import 'package:example/features/login/login_page.dart' as _i2;
import 'package:example/features/notifications/notifications_example.dart'
    as _i3;
import 'package:example/features/settings/settings_page.dart' as _i4;
import 'package:example/features/todo/simple_todo_page.dart' as _i5;
import 'package:example/features/todo/todo_page.dart' as _i6;

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute({List<_i7.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i1.HomePage();
    },
  );
}

/// generated route for
/// [_i2.LoginPage]
class LoginRoute extends _i7.PageRouteInfo<void> {
  const LoginRoute({List<_i7.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i2.LoginPage();
    },
  );
}

/// generated route for
/// [_i3.NotificationsExamplePage]
class NotificationsExampleRoute extends _i7.PageRouteInfo<void> {
  const NotificationsExampleRoute({List<_i7.PageRouteInfo>? children})
    : super(NotificationsExampleRoute.name, initialChildren: children);

  static const String name = 'NotificationsExampleRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i3.NotificationsExamplePage();
    },
  );
}

/// generated route for
/// [_i4.SettingsPage]
class SettingsRoute extends _i7.PageRouteInfo<void> {
  const SettingsRoute({List<_i7.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.SettingsPage();
    },
  );
}

/// generated route for
/// [_i5.SimpleTodoPage]
class SimpleTodoRoute extends _i7.PageRouteInfo<void> {
  const SimpleTodoRoute({List<_i7.PageRouteInfo>? children})
    : super(SimpleTodoRoute.name, initialChildren: children);

  static const String name = 'SimpleTodoRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i5.SimpleTodoPage();
    },
  );
}

/// generated route for
/// [_i6.TodoPage]
class TodoRoute extends _i7.PageRouteInfo<void> {
  const TodoRoute({List<_i7.PageRouteInfo>? children})
    : super(TodoRoute.name, initialChildren: children);

  static const String name = 'TodoRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.TodoPage();
    },
  );
}
