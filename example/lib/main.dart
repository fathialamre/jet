import 'package:example/core/config/app.dart';
import 'package:jet/jet_framework.dart';

void main() async {
  final config = AppConfig();

  Jet.fly(
    setup: () => Boot.start(
      config,
    ),
    setupFinished: (jet) => Boot.finished(jet, config),
  );
}
