import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/config/jet_config.dart';
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
  // Create a ProviderContainer for accessing providers outside the widget tree
  // This is used by adapters, services, and background tasks throughout the app
  final container = ProviderContainer(
    overrides: [
      jetProvider.overrideWith((ref) => jet),
    ],
  );

  // Set the container on the Jet instance so adapters and services can access it
  jet.setContainer(container);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: JetApp(jet: jet),
    ),
  );
}

final jetProvider = Provider<Jet>((ref) => throw UnimplementedError());
