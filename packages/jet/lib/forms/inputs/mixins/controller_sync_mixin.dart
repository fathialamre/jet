import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A mixin that provides bidirectional sync between a TextEditingController
/// and a FormFieldState with circular update protection.
///
/// This mixin prevents infinite loops by using a syncing guard that ensures
/// updates from the controller don't trigger updates to the state and vice versa.
///
/// Usage in a HookWidget:
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   final controller = useTextEditingController(text: state.initialValue ?? '');
///
///   // Set up bidirectional sync with circular update protection
///   useControllerSync(controller, state);
///
///   return TextField(controller: controller, ...);
/// }
/// ```
mixin ControllerSyncMixin {
  // This mixin is intentionally empty as it only provides the hook function below
}

/// Hook that sets up bidirectional sync between a TextEditingController
/// and a FormFieldState with circular update protection.
///
/// This hook:
/// - Syncs controller text changes to form state
/// - Syncs form state changes back to controller
/// - Prevents circular updates using a syncing guard
/// - Only updates when values actually differ
///
/// Example:
/// ```dart
/// final controller = useTextEditingController(text: state.initialValue ?? '');
/// useControllerSync(controller, state);
/// ```
void useControllerSync(
  TextEditingController controller,
  FormFieldState<String?> state,
) {
  // Track if we're currently syncing to avoid circular updates
  final isSyncing = useRef(false);

  // Sync controller changes to form state
  useEffect(
    () {
      void listener() {
        if (isSyncing.value) return;

        final controllerText = controller.text;
        final stateValue = state.value ?? '';

        // Only update if values differ to avoid unnecessary rebuilds
        if (controllerText != stateValue) {
          isSyncing.value = true;
          state.didChange(controllerText);
          isSyncing.value = false;
        }
      }

      controller.addListener(listener);

      // Cleanup
      return () {
        controller.removeListener(listener);
      };
    },
    [controller],
  );

  // Sync form state changes back to controller (programmatic updates)
  useEffect(
    () {
      if (isSyncing.value) return null;

      final stateValue = state.value ?? '';
      final controllerText = controller.text;

      // Only update controller if form state changed externally
      if (controllerText != stateValue) {
        isSyncing.value = true;
        controller.text = stateValue;
        controller.selection = TextSelection.collapsed(
          offset: stateValue.length,
        );
        isSyncing.value = false;
      }
      return null;
    },
    [state.value],
  );
}
