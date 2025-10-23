import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/adapters/jet_adapter.dart';
import 'package:jet/jet.dart';
import 'package:jet/widgets/main/jet_app.dart';

/// Widget responsible for initializing adapters with access to WidgetRef.
///
/// This widget boots all adapters during initState, giving them access to
/// the Riverpod ref for reading providers. Once initialization is complete,
/// it renders the main JetApp.
///
/// Architecture:
/// 1. ProviderScope is created as root
/// 2. AdapterInitializer boots all adapters with ref access
/// 3. JetApp is rendered once adapters are ready
class AdapterInitializer extends ConsumerStatefulWidget {
  final Jet jet;

  const AdapterInitializer({
    super.key,
    required this.jet,
  });

  @override
  ConsumerState<AdapterInitializer> createState() => _AdapterInitializerState();
}

class _AdapterInitializerState extends ConsumerState<AdapterInitializer> {
  bool _isInitialized = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeAdapters();
  }

  Future<void> _initializeAdapters() async {
    try {
      // Store the ref in Jet so adapters can access it
      widget.jet.setRef(ref);

      // Boot all adapters with the Jet instance that now has ref access
      await bootApplication(widget.jet.config, jet: widget.jet);

      // Run afterBoot hooks
      await bootFinished(widget.jet, widget.jet.config);

      // Mark as initialized
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to initialize adapters: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show error if initialization failed
    if (_errorMessage != null) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Initialization Error',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Show loading screen while initializing
    if (!_isInitialized) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Initializing...',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Render the main app once initialized
    return JetApp(jet: widget.jet);
  }
}
