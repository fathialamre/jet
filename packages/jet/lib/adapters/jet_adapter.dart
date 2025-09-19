import 'package:jet_flutter_framework/adapters/adapters.dart';
import 'package:jet_flutter_framework/config/jet_config.dart';
import 'package:jet_flutter_framework/jet.dart';

abstract class JetAdapter {
  Future<Jet?> boot(Jet jet) async => null;

  Future<void> afterBoot(Jet jet) async {}
}

Future<Jet> bootApplication(
  JetConfig config, {
  Future<void> Function(Jet jet)? setupFinished,
}) async {
  Jet jet = Jet(config: config);

  for (final adapter in [
    ...defaultAdapters,
    ...config.adapters,
  ]) {
    final jetObject = await adapter.boot(jet);
    if (jetObject != null) {
      jet = jetObject;
    }
  }

  if (setupFinished != null) {
    await setupFinished(jet);
  }

  return jet;
}

Future<Jet> bootFinished(Jet jet, JetConfig config) async {
  await Future.wait(config.adapters.map((adapter) => adapter.afterBoot(jet)));

  return jet;
}
