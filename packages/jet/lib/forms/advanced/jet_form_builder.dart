import 'package:flutter/material.dart';
import '../core/jet_form_field.dart';

/// A stateless widget that builds a Jet form with validation and state management.
///
/// [JetFormBuilder] is the primary widget for creating forms in the Jet framework.
/// It wraps Flutter's form functionality with additional features like:
/// - Automatic field registration and value tracking
/// - Centralized validation management
/// - Initial value population
/// - Dynamic enable/disable states
/// - Field lifecycle management
///
/// This widget works in conjunction with Jet form fields (like [JetEmailField],
/// [JetPasswordField], etc.) to provide a complete form solution.
///
/// ## Basic Usage
///
/// ```dart
/// final formKey = GlobalKey<JetFormState>();
///
/// JetFormBuilder(
///   key: formKey,
///   child: Column(
///     children: [
///       JetEmailField(name: 'email'),
///       JetPasswordField(name: 'password'),
///     ],
///   ),
/// )
/// ```
///
/// ## Accessing Form State
///
/// You can access the form state using the provided key or the [of] method:
///
/// ```dart
/// // Using the key
/// final values = formKey.currentState?.value;
/// final isValid = formKey.currentState?.validate();
///
/// // Using the of method
/// final formState = JetFormBuilder.of(context);
/// ```
///
/// ## Advanced Features
///
/// - **Initial Values**: Pre-populate fields using the [initialValue] map
/// - **Auto-validation**: Configure when validation occurs with [autovalidateMode]
/// - **Dynamic State**: Enable/disable all fields with the [enabled] property
/// - **Selective Collection**: Skip disabled fields when collecting values
///
/// See also:
/// - [JetForm], the underlying form implementation
/// - [JetFormState], for interacting with the form state
/// - Form field widgets like [JetEmailField], [JetPasswordField], etc.
class JetFormBuilder extends StatelessWidget {
  /// Creates a [JetFormBuilder] widget.
  ///
  /// The [child] parameter is required and typically contains a widget tree
  /// with Jet form fields that will be managed by this form.
  const JetFormBuilder({
    super.key,
    required this.child,
    this.onChanged,
    this.autovalidateMode,
    this.initialValue = const {},
    this.skipDisabled = false,
    this.enabled = true,
    this.clearValueOnUnregister = false,
  });

  /// The widget tree containing form fields to be managed by this form.
  ///
  /// This is typically a [Column], [ListView], or other layout widget containing
  /// Jet form field widgets.
  final Widget child;

  /// Callback invoked whenever any form field value changes.
  ///
  /// This callback is triggered after any field's value is updated, allowing
  /// you to respond to form changes in real-time. Use this for:
  /// - Live form validation
  /// - Conditional field visibility
  /// - Real-time form state updates
  ///
  /// Note: This is called frequently, so avoid expensive operations.
  final VoidCallback? onChanged;

  /// Controls when form fields should auto-validate.
  ///
  /// This setting determines the validation behavior for all fields in the form:
  /// - [AutovalidateMode.disabled]: No automatic validation
  /// - [AutovalidateMode.always]: Validate on every change
  /// - [AutovalidateMode.onUserInteraction]: Validate after first user interaction
  ///
  /// Individual form fields can override this with their own [autovalidateMode].
  ///
  /// Defaults to [AutovalidateMode.disabled] if not specified.
  final AutovalidateMode? autovalidateMode;

  /// Initial values for form fields, keyed by field name.
  ///
  /// Use this to pre-populate fields when the form is first built. The map
  /// keys should match the `name` property of your form fields.
  ///
  /// Example:
  /// ```dart
  /// JetFormBuilder(
  ///   initialValue: {
  ///     'email': 'user@example.com',
  ///     'name': 'John Doe',
  ///     'age': 25,
  ///   },
  ///   child: Column(
  ///     children: [
  ///       JetEmailField(name: 'email'),
  ///       JetTextField(name: 'name'),
  ///       JetNumberField(name: 'age'),
  ///     ],
  ///   ),
  /// )
  /// ```
  ///
  /// Defaults to an empty map.
  final Map<String, dynamic> initialValue;

  /// Whether to exclude disabled fields from form value collection.
  ///
  /// When `true`, calling `formState.value` will not include values from
  /// fields that are currently disabled. This is useful when you want to
  /// submit only enabled fields to your backend.
  ///
  /// When `false` (default), all field values are included regardless of
  /// their enabled state.
  final bool skipDisabled;

  /// Whether all form fields should be enabled or disabled.
  ///
  /// When `false`, all fields in the form will be disabled, preventing
  /// user interaction. Individual fields can override this by setting
  /// their own `enabled` property.
  ///
  /// This is useful for:
  /// - Disabling the entire form during submission
  /// - Read-only form display modes
  /// - Conditional form access
  ///
  /// Defaults to `true`.
  final bool enabled;

  /// Whether to clear field values when they are unregistered from the form.
  ///
  /// When a field is removed from the widget tree (e.g., due to conditional
  /// rendering), this setting controls whether its value should be cleared
  /// from the form state.
  ///
  /// - `true`: Remove the field's value when it's unmounted
  /// - `false`: Keep the field's value in form state even after unmounting
  ///
  /// Defaults to `false`, preserving values for fields that may be shown again.
  final bool clearValueOnUnregister;

  @override
  Widget build(BuildContext context) {
    return JetForm(
      key: key as GlobalKey<JetFormState>?,
      onChanged: onChanged,
      autovalidateMode: autovalidateMode,
      initialValue: initialValue,
      skipDisabled: skipDisabled,
      enabled: enabled,
      clearValueOnUnregister: clearValueOnUnregister,
      child: child,
    );
  }

  /// Retrieves the [JetFormState] from the closest [JetFormBuilder] ancestor.
  ///
  /// This static method allows descendant widgets to access the form state
  /// without requiring a [GlobalKey].
  ///
  /// Returns `null` if there is no [JetFormBuilder] ancestor in the widget tree.
  ///
  /// Example:
  /// ```dart
  /// // In a child widget
  /// void submitForm(BuildContext context) {
  ///   final formState = JetFormBuilder.of(context);
  ///   if (formState?.validate() == true) {
  ///     final values = formState?.value;
  ///     // Submit the form
  ///   }
  /// }
  /// ```
  ///
  /// See also:
  /// - [JetFormState], for available methods and properties
  static JetFormState? of(BuildContext context) {
    return JetForm.of(context);
  }
}

/// A type alias for [GlobalKey]<[JetFormState]>.
///
/// Use this type when declaring form keys for type safety and consistency:
///
/// ```dart
/// final JetFormKey formKey = GlobalKey<JetFormState>();
/// ```
typedef JetFormKey = GlobalKey<JetFormState>;

/// A type alias for Flutter's [FormFieldValidator].
///
/// This provides a consistent naming convention with other Jet types and
/// allows for future customization of validation behavior.
///
/// Used for custom field validators:
/// ```dart
/// JetFieldValidator<String> customValidator = (value) {
///   if (value == null || value.isEmpty) {
///     return 'This field is required';
///   }
///   return null;
/// };
/// ```
typedef JetFieldValidator<T> = FormFieldValidator<T>;
