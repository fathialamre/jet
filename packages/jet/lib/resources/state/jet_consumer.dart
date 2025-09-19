import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet_flutter_framework/bootstrap/boot.dart';
import 'package:jet_flutter_framework/jet.dart';

/// Abstract widget that provides access to Jet instance and WidgetRef
///
/// This widget extends ConsumerWidget to provide Riverpod functionality
/// and gives access to the Jet instance through the jetBuild method.
///
/// **Performance Note**: The Jet instance is watched (not read) to ensure
/// proper rebuilding when the Jet configuration changes.
///
/// Usage:
/// ```dart
/// class MyWidget extends JetConsumerWidget {
///   @override
///   Widget jetBuild(BuildContext context, WidgetRef ref, Jet jet) {
///     // Access jet instance and ref here
///     return Container();
///   }
/// }
/// ```
abstract class JetConsumerWidget extends ConsumerWidget {
  /// Creates a JetConsumer widget
  const JetConsumerWidget({super.key});

  /// Build method that provides context, WidgetRef, and Jet instance
  ///
  /// [context] - The build context
  /// [ref] - The WidgetRef for accessing Riverpod providers
  /// [jet] - The Jet instance for accessing framework features
  Widget jetBuild(BuildContext context, WidgetRef ref, Jet jet);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the Jet instance to ensure proper rebuilding
    final jet = ref.watch(jetProvider);

    // Call the abstract jetBuild method with context, ref, and jet instance
    return jetBuild(context, ref, jet);
  }
}

/// Convenience Consumer widget that provides Jet instance access
///
/// This is a functional alternative to JetConsumerWidget for cases where
/// you don't need to extend a class.
///
/// Usage:
/// ```dart
/// JetConsumer(
///   builder: (context, ref, jet) {
///     return Container();
///   },
/// )
/// ```
class JetConsumer extends ConsumerWidget {
  /// Creates a JetConsumer widget
  const JetConsumer({
    super.key,
    required this.builder,
  });

  /// Builder function that provides context, WidgetRef, and Jet instance
  final Widget Function(BuildContext context, WidgetRef ref, Jet jet) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the Jet instance to ensure proper rebuilding
    final jet = ref.watch(jetProvider);

    // Call the builder with context, ref, and jet instance
    return builder(context, ref, jet);
  }
}
