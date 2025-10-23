import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/config/jet_config.dart';
import 'package:jet/jet.dart';
import 'package:jet/bootstrap/adapter_initializer.dart';

class Boot {
  static Future<Jet> start(JetConfig config) async {
    WidgetsFlutterBinding.ensureInitialized();

    // Create the Jet instance
    // The ref will be set later by AdapterInitializer when ProviderScope is ready
    final jet = Jet(config: config);

    return jet;
  }

  static Future<void> finished(Jet jet, JetConfig config) async {
    runJetApp(jet: jet);
  }
}

Future<void> runJetApp({required Jet jet}) async {
  // Use standard ProviderScope with AdapterInitializer
  // The AdapterInitializer will boot adapters with ref access
  runApp(
    ProviderScope(
      overrides: [
        jetProvider.overrideWith((ref) => jet),
      ],
      observers: [
        // LoggerObserver(),
      ],
      child: AdapterInitializer(jet: jet),
    ),
  );
}

final jetProvider = Provider<Jet>((ref) => throw UnimplementedError());
