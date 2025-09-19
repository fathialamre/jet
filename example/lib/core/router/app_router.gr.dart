// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:example/features/home/home_page.dart' as _i1;
import 'package:example/features/notifications/notifications_example.dart'
    as _i2;
import 'package:example/features/settings/settings_page.dart' as _i3;
import 'package:example/features/todo/todo_page.dart' as _i4;

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
/// [_i2.NotificationsExamplePage]
class NotificationsExampleRoute extends _i5.PageRouteInfo<void> {
  const NotificationsExampleRoute({List<_i5.PageRouteInfo>? children})
    : super(NotificationsExampleRoute.name, initialChildren: children);

  static const String name = 'NotificationsExampleRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i2.NotificationsExamplePage();
    },
  );
}

/// generated route for
/// [_i3.SettingsPage]
class SettingsRoute extends _i5.PageRouteInfo<void> {
  const SettingsRoute({List<_i5.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i3.SettingsPage();
    },
  );
}

/// generated route for
/// [_i4.TodoPage]
class TodoRoute extends _i5.PageRouteInfo<void> {
  const TodoRoute({List<_i5.PageRouteInfo>? children})
    : super(TodoRoute.name, initialChildren: children);

  static const String name = 'TodoRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i4.TodoPage();
    },
  );
}
