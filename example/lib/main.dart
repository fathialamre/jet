import 'package:example/core/config/app.dart';
import 'package:example/core/router/app_router.dart';
import 'package:jet/jet_framework.dart';

void main() async {
  final config = AppConfig();

  Jet.fly(
    setup: () => Boot.start(
      config,
      routerProvider: appRouter,
    ),
    setupFinished: (jet) => Boot.finished(jet, config),
  );
}
