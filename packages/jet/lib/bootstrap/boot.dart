import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/config/jet_config.dart';
import 'package:jet/jet.dart';
import 'package:jet/adapters/jet_adapter.dart';
import 'package:jet/widgets/jet_main.dart';

class Boot {
  static Future<Jet> start(JetConfig config) async {
    WidgetsFlutterBinding.ensureInitialized();
    return bootApplication(config);
  }

  static Future<void> finished(Jet jet, JetConfig config) async {
    await bootFinished(jet, config);

    runJetApp(jet: jet);
  }
}

runJetApp({required Jet jet}) async {
  runApp(
    ProviderScope(
      overrides: [
        // jet.router.provider!,
        // jetProvider.overrideWith(
        //   (ref) => jet,
        // ),
      ],
      child: JetMain(jet: jet),
    ),
  );
}
