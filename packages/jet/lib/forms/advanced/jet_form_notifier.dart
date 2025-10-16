import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/forms/advanced/mixins/form_error_handling_mixin.dart';
import 'package:jet/forms/advanced/mixins/form_lifecycle_mixin.dart';
import 'package:jet/forms/advanced/mixins/form_validation_mixin.dart';
import '../../networking/errors/jet_error.dart';
import '../common.dart';
import '../core/jet_form_field.dart';

typedef JetFormProvider<Request, Response> =
    Provider<AsyncFormValue<Request, Response>>;

/// Base interface for form notifiers that provides access to state and methods
abstract class FormNotifierBase<Request, Response> {
  AsyncFormValue<Request, Response> get state;
  set state(AsyncFormValue<Request, Response> value);

  GlobalKey<JetFormState> get formKey;
  Future<void> submit();
  void invalidateFormFields(Map<String, List<String>> fieldErrors);
  void reset();
  Request decoder(Map<String, dynamic> json);
  Future<Response> action(Request data);
  bool get hasChanges;
}

/// Mixin version of JetFormNotifier for use with Riverpod's @riverpod annotation
///
/// Use this mixin when you need to work with Riverpod's code generation:
/// ```dart
/// @riverpod
/// class MyForm extends _$MyForm with JetFormMixin<Request, Response> {
///   // implementation
/// }
/// ```
mixin JetFormMixin<Request, Response>
    implements
        FormNotifierBase<Request, Response>,
        FormValidationMixin,
        FormErrorHandlingMixin,
        FormLifecycleMixin<Request, Response> {
  @override
  final GlobalKey<JetFormState> formKey = GlobalKey<JetFormState>();

  /// Cache for validation results to avoid redundant validations
  final Map<String, List<String>> _validationCache = {};

  /// Track last validated values to detect when cache should be invalidated
  final Map<String, dynamic> _lastValidatedValues = {};

  // FormLifecycleMixin implementation
  FormLifecycleCallbacks<Request, Response>? _callbacks;

  @override
  void setLifecycleCallbacks(
    FormLifecycleCallbacks<Request, Response>? callbacks,
  ) {
    _callbacks = callbacks;
  }

  @override
  void triggerSubmissionStart() {
    _callbacks?.onSubmissionStart?.call();
  }

  @override
  void triggerSuccess(Response response, Request request) {
    _callbacks?.onSuccess?.call(response, request);
  }

  @override
  void triggerSubmissionError(Object error, StackTrace stackTrace) {
    _callbacks?.onSubmissionError?.call(error, stackTrace);
  }

  @override
  void triggerValidationError(Object error, StackTrace stackTrace) {
    _callbacks?.onValidationError?.call(error, stackTrace);
  }

  // FormValidationMixin implementation
  @override
  bool get validateOnChange => false;

  @override
  bool get validateOnFocusLoss => false;

  @override
  bool get autoValidate => false;

  @override
  List<String> validateField(String fieldName, dynamic value) {
    return [];
  }

  /// Internal method to validate field with caching support
  List<String> _validateFieldWithCache(String fieldName, dynamic value) {
    // Check if value changed since last validation
    final lastValue = _lastValidatedValues[fieldName];

    // Return cached result if value hasn't changed (using deep equality)
    if (_valuesEqual(lastValue, value) &&
        _validationCache.containsKey(fieldName)) {
      return _validationCache[fieldName]!;
    }

    // Value changed or no cache, perform validation
    final errors = validateField(fieldName, value);

    // Update cache
    _lastValidatedValues[fieldName] = value;
    _validationCache[fieldName] = errors;

    return errors;
  }

  /// Compare two values with deep equality for common types
  ///
  /// Supports:
  /// - Lists (using listEquals)
  /// - Maps (using mapEquals)
  /// - Sets (converting to lists)
  /// - Primitives (using ==)
  ///
  /// Note: For custom classes, implement proper equality (== and hashCode)
  /// or the cache will always miss on those values.
  bool _valuesEqual(dynamic a, dynamic b) {
    // Same reference
    if (identical(a, b)) return true;

    // Both null
    if (a == null && b == null) return true;

    // One null
    if (a == null || b == null) return false;

    // Different types
    if (a.runtimeType != b.runtimeType) return false;

    // Lists - use deep equality
    if (a is List && b is List) {
      return listEquals(a, b);
    }

    // Maps - use deep equality
    if (a is Map && b is Map) {
      return mapEquals(a, b);
    }

    // Sets - convert to lists and compare
    if (a is Set && b is Set) {
      return listEquals(a.toList(), b.toList());
    }

    // Fallback to standard equality
    return a == b;
  }

  /// Invalidate validation cache for a specific field or all fields
  void invalidateValidationCache([String? fieldName]) {
    if (fieldName != null) {
      _validationCache.remove(fieldName);
      _lastValidatedValues.remove(fieldName);
    } else {
      _validationCache.clear();
      _lastValidatedValues.clear();
    }
  }

  @override
  void validateSpecificField(
    String fieldName,
    GlobalKey<JetFormState> formKey,
  ) {
    final formState = formKey.currentState;
    if (formState == null) return;

    final field = formState.fields[fieldName];
    if (field == null) return;

    // Use cached validation
    final errors = _validateFieldWithCache(fieldName, field.value);
    if (errors.isNotEmpty) {
      field.invalidate(errors.first);
    } else {
      field.validate();
    }
  }

  @override
  bool validateAllFields(GlobalKey<JetFormState> formKey) {
    final formState = formKey.currentState;
    if (formState == null) return false;

    bool isValid = true;
    for (final entry in formState.fields.entries) {
      final fieldName = entry.key;
      final field = entry.value;

      // Use cached validation for better performance
      final errors = _validateFieldWithCache(fieldName, field.value);
      if (errors.isNotEmpty) {
        field.invalidate(errors.first);
        isValid = false;
      }
    }

    return isValid && formState.saveAndValidate();
  }

  @override
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

  @override
  void invalidateFields(
    Map<String, List<String>> fieldErrors,
    GlobalKey<JetFormState> formKey,
  ) {
    fieldErrors.forEach((field, errorText) {
      formKey.currentState?.fields[field]?.invalidate(errorText.first);
    });
  }

  // FormErrorHandlingMixin implementation
  @override
  JetError convertToJetError(Object error, StackTrace stackTrace) {
    if (error is JetError) {
      return error;
    }

    return JetError.unknown(
      message: error.toString(),
      rawError: error,
      stackTrace: stackTrace,
    );
  }

  @override
  JetError createValidationError(Map<String, List<String>> formErrors) {
    return JetError.validation(
      message: 'Please fix the form errors',
      errors: formErrors,
    );
  }

  // Form submission and management methods
  @override
  Future<void> submit() async {
    final formState = formKey.currentState;
    if (formState == null || !formState.saveAndValidate()) {
      // Extract form validation errors
      final formErrors = extractFormErrors(formState);
      final validationError = createValidationError(formErrors);

      state = AsyncFormValue.error(
        validationError,
        StackTrace.current,
        request: state.request,
        response: state.response,
      );

      triggerValidationError(validationError, StackTrace.current);
      return;
    }

    // Notify submission start
    triggerSubmissionStart();

    // Preserve current data while loading
    state = AsyncFormValue.loading(
      request: state.request,
      response: state.response,
    );

    try {
      final requestData = decoder(formState.value);
      final responseData = await action(requestData);

      state = AsyncFormValue.data(request: requestData, response: responseData);

      triggerSuccess(responseData, requestData);
    } catch (error, stackTrace) {
      state = AsyncFormValue.error(error, stackTrace);
      triggerSubmissionError(error, stackTrace);
    }
  }

  @override
  Request decoder(Map<String, dynamic> json);

  @override
  void invalidateFormFields(Map<String, List<String>> fieldErrors) {
    invalidateFields(fieldErrors, formKey);
  }

  @override
  void reset() {
    formKey.currentState?.reset();
    // Clear validation cache on reset
    invalidateValidationCache();
    state = const AsyncFormValue.idle();
  }

  /// Validate a specific field
  void validateSingleField(String fieldName) {
    validateSpecificField(fieldName, formKey);
  }

  /// Validate all fields without submitting
  bool validateForm() {
    return validateAllFields(formKey);
  }

  @override
  Future<Response> action(Request data);

  void setValue(String fieldName, dynamic value) {
    formKey.currentState?.fields[fieldName]?.didChange(value);
  }

  void setValues(Map<String, dynamic> values) {
    values.forEach((fieldName, value) {
      setValue(fieldName, value);
    });
  }

  /// Returns true if any form field value differs from its initial value
  @override
  bool get hasChanges => formKey.currentState?.hasChanges ?? false;
}

/// Traditional class-based JetFormNotifier for backward compatibility
///
/// Use this when you're not using Riverpod's @riverpod annotation:
/// ```dart
/// class MyForm extends JetFormNotifier<Request, Response> {
///   @override
///   AsyncFormValue<Request, Response> build() {
///     return const AsyncFormIdle();
///   }
///   // implementation
/// }
/// ```
abstract class JetFormNotifier<Request, Response>
    extends Notifier<AsyncFormValue<Request, Response>>
    with JetFormMixin<Request, Response> {
  @override
  AsyncFormValue<Request, Response> build();
}
