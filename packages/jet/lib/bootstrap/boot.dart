import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/config/jet_config.dart';
import 'package:jet/helpers/provider_observer.dart';
import 'package:jet/jet.dart';
import 'package:jet/adapters/jet_adapter.dart';
import 'package:jet/widgets/main/jet_app.dart';

class Boot {
  static Future<Jet> start(JetConfig config) async {
    WidgetsFlutterBinding.ensureInitialized();

    // Create the Jet instance first
    final jet = Jet(config: config);

    // Create the ProviderContainer BEFORE booting adapters
    // This allows adapters to access the container during their boot process
    final container = ProviderContainer(
      overrides: [
        jetProvider.overrideWith((ref) => jet),
      ],
      observers: [
        LoggerObserver(),
      ],
    );

    // Set the container on the Jet instance so adapters can access it
    jet.setContainer(container);

    // Now boot the application with the container already set
    return bootApplication(config, jet: jet);
  }

  static Future<void> finished(Jet jet, JetConfig config) async {
    await bootFinished(jet, config);

    runJetApp(jet: jet);
  }
}

Future<void> runJetApp({required Jet jet}) async {
  // The container is already created and set in Boot.start()
  // Just run the app with the existing container
  runApp(
    UncontrolledProviderScope(
      container: jet.container,
      child: JetApp(jet: jet),
    ),
  );
}

final jetProvider = Provider<Jet>((ref) => throw UnimplementedError());
