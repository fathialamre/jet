# Routing Documentation

Complete guide to navigation and routing in the Jet framework.

## Overview

Jet uses **[AutoRoute](https://pub.dev/packages/auto_route)** for type-safe navigation with declarative routing. AutoRoute is a powerful routing package that provides code generation for type-safe route navigation, eliminating the need for string-based routes and providing compile-time safety.

**Package Used:**
- **auto_route** - [Documentation](https://auto-route.vercel.app/) | [pub.dev](https://pub.dev/packages/auto_route)

**Key Benefits:**
- ✅ Type-safe navigation with generated routes
- ✅ Declarative routing with annotations
- ✅ Nested navigation support
- ✅ Route guards for authentication
- ✅ Deep linking support
- ✅ Tab navigation and bottom navigation bars
- ✅ Automatic route parameters handling

## Setup

### 1. Create Router Configuration

```dart
import 'package:auto_route/auto_route.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, path: '/', initial: true),
    AutoRoute(page: ProfileRoute.page, path: '/profile'),
    AutoRoute(page: SettingsRoute.page, path: '/settings'),
  ];
}
```

### 2. Create Router Provider

```dart
final appRouterProvider = AutoDisposeProvider<AppRouter>((ref) {
  return AppRouter();
});
```

### 3. Initialize in Main

```dart
void main() async {
  final config = AppConfig();
  
  Jet.fly(
    setup: () => Boot.start(config),
    setupFinished: (jet) {
      jet.setRouter(appRouterProvider);
      Boot.finished(jet, config);
    },
  );
}
```

## Navigation

### Basic Navigation

```dart
// Navigate to a route
context.router.push(ProfileRoute());

// Navigate with parameters
context.router.push(ProfileRoute(userId: '123'));

// Navigate and remove current from stack
context.router.replace(LoginRoute());

// Go back
context.router.pop();

// Pop until first route
context.router.popUntilRoot();
```

### Named Routes

```dart
// Navigate by path
context.router.pushNamed('/profile');

// With query parameters
context.router.pushNamed(
  '/profile',
  queryParams: {'userId': '123'},
);
```

### Route Guards

```dart
class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (isAuthenticated()) {
      resolver.next();
    } else {
      router.push(LoginRoute());
    }
  }
}

// Use in routes
AutoRoute(
  page: ProfileRoute.page,
  path: '/profile',
  guards: [AuthGuard()],
)
```

## See Also

- [Configuration Documentation](CONFIGURATION.md)
- [Components Documentation](COMPONENTS.md)

