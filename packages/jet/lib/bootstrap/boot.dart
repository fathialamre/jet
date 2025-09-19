import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/config/jet_config.dart';
import 'package:jet/helpers/jet_logger.dart';
import 'package:jet/jet.dart';
import 'package:jet/adapters/jet_adapter.dart';
import 'package:jet/widgets/main/jet_app.dart';

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

Future<void> runJetApp({required Jet jet}) async {
  dump('NEW APP RUNNER');
  runApp(
    ProviderScope(
      overrides: [
        jetProvider.overrideWith(
          (ref) => jet,
        ),
      ],
      child: JetApp(jet: jet),
    ),
  );
}

final jetProvider = Provider<Jet>((ref) => throw UnimplementedError());
