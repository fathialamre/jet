import 'package:example/features/login/pages/login_page.dart';
import 'package:jet/jet_framework.dart';

class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    NamedRouteDef(
      name: 'LoginRoute',
      builder: (context, args) => LoginPage(),
      initial: true,
    ),
  ];
}

final appRouter = AutoDisposeProvider<AppRouter>(
  (ref) => AppRouter(),
);
