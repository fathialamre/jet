import 'package:flutter/material.dart';
import '../common.dart';
import '../core/jet_form_field.dart';

/// A controller that manages form state and actions for simple forms.
///
/// This controller is returned by the [useJetForm] hook and provides
/// convenient access to form state, validation, and submission logic.
///
/// Example:
/// ```dart
/// final form = useJetForm<LoginRequest, LoginResponse>(
///   decoder: (json) => LoginRequest.fromJson(json),
///   action: (request) => apiService.login(request),
/// );
///
/// // Access state
/// if (form.isLoading) { ... }
/// if (form.hasError) { ... }
///
/// // Perform actions
/// form.submit();
/// form.reset();
/// ```
class JetFormController<Request, Response> {
  /// The form key used to access form state and validation
  final GlobalKey<JetFormState> formKey;

  /// The current state of the form
  final AsyncFormValue<Request, Response> state;

  /// Function to submit the form
  final VoidCallback submit;

  /// Function to reset the form to its initial state
  final VoidCallback reset;

  /// Function to validate a specific field
  final void Function(String fieldName) validateField;

  /// Function to validate all fields without submitting
  final bool Function() validateForm;

  /// Function to invalidate specific fields with error messages
  final void Function(Map<String, List<String>> fieldErrors) invalidateFields;

  const JetFormController({
    required this.formKey,
    required this.state,
    required this.submit,
    required this.reset,
    required this.validateField,
    required this.validateForm,
    required this.invalidateFields,
  });

  /// Whether the form is currently in a loading state
  bool get isLoading => state.isLoading;

  /// Whether the form has an error
  bool get hasError => state.hasError;

  /// Whether the form has successfully submitted data
  bool get hasValue => state.hasValue;

  /// Whether the form is in its initial idle state
  bool get isIdle => state.isIdle;

  /// The request data if available
  Request? get request => state.request;

  /// The response data if available
  Response? get response => state.response;

  /// The error object if available
  Object? get error => state.error;

  /// Get the current form values as a Map
  Map<String, dynamic>? get values => formKey.currentState?.value;

  /// Returns true if any form field value differs from its initial value
  bool get hasChanges => formKey.currentState?.hasChanges ?? false;

  /// Save the current form state
  bool save() => formKey.currentState?.saveAndValidate() ?? false;
}
