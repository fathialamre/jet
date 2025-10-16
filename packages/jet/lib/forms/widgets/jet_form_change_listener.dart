import 'package:flutter/widgets.dart';
import 'package:jet/forms/forms.dart';
import '../core/jet_form_field.dart';

/// A widget that rebuilds when any form field value changes.
///
/// This is useful when you need to react to form value changes, such as
/// enabling/disabling buttons based on whether the form has changes.
///
/// Example:
/// ```dart
/// JetFormChangeListener(
///   formKey: form.formKey,
///   builder: (context) {
///     return ElevatedButton(
///       onPressed: form.hasChanges ? () => form.submit() : null,
///       child: Text('Submit'),
///     );
///   },
/// )
/// ```
class JetFormChangeListener extends StatelessWidget {
  /// The form key to listen to for changes
  final FormNotifierBase form;

  /// Builder function that is called when form values change
  final WidgetBuilder builder;

  const JetFormChangeListener({
    super.key,
    required this.form,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: form.formKey.currentState?.changeNotifier ?? ValueNotifier(0),
      builder: (context, _, _) => builder(context),
    );
  }
}
