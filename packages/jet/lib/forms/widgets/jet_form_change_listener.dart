import 'package:flutter/widgets.dart';
import 'package:jet/forms/forms.dart';

/// A widget that rebuilds when form field values change.
///
/// This widget can listen to all form changes or specific field changes,
/// significantly reducing unnecessary rebuilds in complex forms.
///
/// Example (listen to all changes):
/// ```dart
/// JetFormChangeListener(
///   form: form,
///   builder: (context) {
///     return ElevatedButton(
///       onPressed: form.hasChanges ? () => form.submit() : null,
///       child: Text('Submit'),
///     );
///   },
/// )
/// ```
///
/// Example (listen to specific fields):
/// ```dart
/// JetFormChangeListener(
///   form: form,
///   listenToFields: ['email', 'password'],
///   builder: (context) {
///     final formState = form.formKey.currentState;
///     final email = formState?.instantValue['email'];
///     final password = formState?.instantValue['password'];
///     final canSubmit = email != null && password != null;
///     return ElevatedButton(
///       onPressed: canSubmit ? () => form.submit() : null,
///       child: Text('Login'),
///     );
///   },
/// )
/// ```
class JetFormChangeListener extends StatefulWidget {
  /// The form to listen to for changes
  final FormNotifierBase form;

  /// Builder function that is called when form values change
  final WidgetBuilder builder;

  /// Optional list of field names to listen to.
  /// If null or empty, listens to all fields.
  /// If provided, only rebuilds when these specific fields change.
  final List<String>? listenToFields;

  const JetFormChangeListener({
    super.key,
    required this.form,
    required this.builder,
    this.listenToFields,
  });

  @override
  State<JetFormChangeListener> createState() => _JetFormChangeListenerState();
}

class _JetFormChangeListenerState extends State<JetFormChangeListener> {
  /// Last known values of listened fields for change detection
  Map<String, dynamic>? _lastFieldValues;

  /// Cached widget to avoid unnecessary rebuilds
  Widget? _cachedWidget;

  /// Static fallback notifier to avoid creating new instances
  static final ValueNotifier<int> _fallbackNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    if (widget.listenToFields != null && widget.listenToFields!.isNotEmpty) {
      _lastFieldValues = {};
      // Initialize with current field values to avoid false positive on first render
      final formState = widget.form.formKey.currentState;
      if (formState != null) {
        for (final fieldName in widget.listenToFields!) {
          _lastFieldValues![fieldName] = formState.instantValue[fieldName];
        }
      }
    }
  }

  bool _shouldRebuild() {
    // If not listening to specific fields, always rebuild
    if (widget.listenToFields == null || widget.listenToFields!.isEmpty) {
      return true;
    }

    // Check if any of the listened fields changed
    final formState = widget.form.formKey.currentState;
    if (formState == null) return false;

    bool hasChanges = false;
    for (final fieldName in widget.listenToFields!) {
      final currentValue = formState.instantValue[fieldName];
      final lastValue = _lastFieldValues![fieldName];

      if (currentValue != lastValue) {
        _lastFieldValues![fieldName] = currentValue;
        hasChanges = true;
      }
    }

    return hasChanges;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable:
          widget.form.formKey.currentState?.changeNotifier ?? _fallbackNotifier,
      builder: (context, _, __) {
        // Only rebuild if the fields we care about changed
        // Check cachedWidget is not null to handle edge cases
        if (_lastFieldValues != null &&
            _cachedWidget != null &&
            !_shouldRebuild()) {
          // Return cached widget to avoid calling builder
          return _cachedWidget!;
        }

        // Rebuild and cache the new widget
        _cachedWidget = widget.builder(context);
        return _cachedWidget!;
      },
    );
  }
}
