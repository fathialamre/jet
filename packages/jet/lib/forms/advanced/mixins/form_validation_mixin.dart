import 'package:flutter/material.dart';
import 'package:jet/forms/core/jet_form_field.dart';

/// Mixin that provides validation capabilities for forms
mixin FormValidationMixin {
  /// Configuration for form validation behavior
  bool get validateOnChange => false;
  bool get validateOnFocusLoss => false;
  bool get autoValidate => false;

  /// Override to provide custom field validation
  List<String> validateField(String fieldName, dynamic value) {
    return [];
  }

  /// Validate a specific field and update its error state
  void validateSpecificField(
    String fieldName,
    GlobalKey<JetFormState> formKey,
  ) {
    final formState = formKey.currentState;
    if (formState == null) return;

    final field = formState.fields[fieldName];
    if (field == null) return;

    final errors = validateField(fieldName, field.value);
    if (errors.isNotEmpty) {
      field.invalidate(errors.first);
    } else {
      field.validate();
    }
  }

  /// Validate all fields without triggering submission
  bool validateAllFields(GlobalKey<JetFormState> formKey) {
    final formState = formKey.currentState;
    if (formState == null) return false;

    bool isValid = true;
    for (final entry in formState.fields.entries) {
      final fieldName = entry.key;
      final field = entry.value;

      final errors = validateField(fieldName, field.value);
      if (errors.isNotEmpty) {
        field.invalidate(errors.first);
        isValid = false;
      }
    }

    return isValid && formState.saveAndValidate();
  }

  /// Extract validation errors from form state
  Map<String, List<String>> extractFormErrors(JetFormState? formState) {
    if (formState == null) return {};

    final errors = <String, List<String>>{};
    formState.fields.forEach((fieldName, field) {
      if (field.hasError && field.errorText != null) {
        errors[fieldName] = [field.errorText!];
      }
    });
    return errors;
  }

  /// Invalidate specific fields with error messages
  void invalidateFields(
    Map<String, List<String>> fieldErrors,
    GlobalKey<JetFormState> formKey,
  ) {
    fieldErrors.forEach((field, errorText) {
      formKey.currentState?.fields[field]?.invalidate(errorText.first);
    });
  }
}
