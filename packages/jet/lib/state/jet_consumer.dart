import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/bootstrap/boot.dart';
import 'package:jet/jet.dart';

/// Abstract widget that provides direct access to Jet instance in the build method
///
/// This widget extends ConsumerStatefulWidget to provide Riverpod functionality
/// and passes the Jet instance directly to the build method alongside context and ref.
///
/// **Performance Note**: The Jet instance is watched (not read) to ensure
/// proper rebuilding when the Jet configuration changes.
///
/// Usage:
/// ```dart
/// class MyWidget extends JetConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref, Jet jet) {
///     // Direct access to jet instance
///     final router = jet.router;
///     final config = jet.config;
///
///     // Can still use ref for other providers
///     final user = ref.watch(userProvider);
///
///     return Container();
///   }
/// }
/// ```
///
/// **Migration Guide**: If migrating from the old jet(ref) pattern:
/// ```dart
/// // Before (old pattern - required calling jet(ref)):
/// class MyWidget extends JetConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final myJet = jet(ref);
///     return Text(myJet.config.title);
///   }
/// }
///
/// // After (new pattern - jet passed directly):
/// class MyWidget extends JetConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref, Jet jet) {
///     return Text(jet.config.title);
///   }
/// }
/// ```
abstract class JetConsumerWidget extends ConsumerStatefulWidget {
  /// Creates a JetConsumerWidget
  const JetConsumerWidget({super.key});

  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method when this widget is inserted into the tree
  /// and when the dependencies of this widget change.
  ///
  /// [context] - The build context
  /// [ref] - The WidgetRef for accessing providers
  /// [jet] - The Jet instance automatically provided by the framework
  Widget build(BuildContext context, WidgetRef ref, Jet jet);

  @override
  // ignore: library_private_types_in_public_api
  _JetConsumerState createState() => _JetConsumerState();
}

class _JetConsumerState extends ConsumerState<JetConsumerWidget> {
  @override
  Widget build(BuildContext context) {
    // Watch the jet provider to ensure rebuilds when jet changes
    final jet = ref.watch(jetProvider);
    // Call the widget's build method with all three parameters
    return widget.build(context, ref, jet);
  }
}

/// Abstract stateful widget that provides access to Jet instance and WidgetRef
///
/// This widget extends ConsumerStatefulWidget to provide Riverpod functionality
/// with state management and gives access to the Jet instance through the
/// ConsumerState.
///
/// **Performance Note**: The Jet instance is watched (not read) to ensure
/// proper rebuilding when the Jet configuration changes.
///
/// Usage:
/// ```dart
/// class MyStatefulWidget extends JetConsumerStatefulWidget {
///   const MyStatefulWidget({super.key});
///
///   @override
///   JetConsumerState<MyStatefulWidget> createState() => _MyStatefulWidgetState();
/// }
///
/// class _MyStatefulWidgetState extends JetConsumerState<MyStatefulWidget> {
///   @override
///   void initState() {
///     super.initState();
///     // Access jet in initState
///     final router = jet.router;
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     // Access jet and ref in build
///     final myJet = jet;
///     final data = ref.watch(someProvider);
///     return Container();
///   }
/// }
/// ```
abstract class JetConsumerStatefulWidget extends ConsumerStatefulWidget {
  /// Creates a JetConsumerStatefulWidget
  const JetConsumerStatefulWidget({super.key});

  @override
  JetConsumerState createState();

  
}

/// The State for a [JetConsumerStatefulWidget]
///
/// It has all the life-cycles of a normal [State], with the additional
/// benefit of having access to both [ref] and [jet] properties.
///
/// Example:
/// ```dart
/// class _MyWidgetState extends JetConsumerState<MyWidget> {
///   @override
///   void initState() {
///     super.initState();
///     // Can access jet in any lifecycle method
///     final config = jet.config;
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     // Access both jet and ref
///     final router = jet.router;
///     final user = ref.watch(userProvider);
///     return Container();
///   }
/// }
/// ```
abstract class JetConsumerState<T extends JetConsumerStatefulWidget>
    extends ConsumerState<T> {
  /// Getter to access the Jet instance
  ///
  /// This getter watches the Jet provider to ensure proper rebuilding
  /// when the Jet configuration changes.
  ///
  /// Returns the current Jet instance
  @protected
  Jet get jet => ref.watch(jetProvider);
}

/// Convenience Consumer widget that provides Jet instance access
///
/// This is a functional alternative to JetConsumerWidget for cases where
/// you don't need to extend a class. It follows the same pattern as
/// JetConsumerWidget by providing context, ref, and jet directly to
/// the builder function.
///
/// Usage:
/// ```dart
/// JetConsumer(
///   builder: (context, ref, jet) {
///     final router = jet.router;
///     final user = ref.watch(userProvider);
///
///     return Text('Welcome ${user.name}');
///   },
/// )
/// ```
///
/// This is ideal for:
/// - Simple widgets that don't need their own class
/// - Quick prototyping
/// - Inline widget creation
///
/// For more complex widgets, consider extending [JetConsumerWidget] instead.
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
