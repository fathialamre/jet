/// Advanced Forms
///
/// Full-featured form management for complex enterprise requirements.
/// Needed for: multi-step wizards, conditional fields, complex validation,
/// server-side validation integration, form state persistence.
///
/// Example:
/// ```dart
/// @riverpod
/// class LoginForm extends _$LoginForm with JetFormMixin<LoginRequest, LoginResponse> {
///   @override
///   AsyncFormValue<LoginRequest, LoginResponse> build() {
///     return const AsyncFormIdle();
///   }
///
///   @override
///   LoginRequest decoder(Map<String, dynamic> json) {
///     return LoginRequest.fromJson(json);
///   }
///
///   @override
///   Future<LoginResponse> action(LoginRequest data) async {
///     return await apiService.login(data);
///   }
///
///   // Custom validation logic
///   @override
///   List<String> validateField(String fieldName, dynamic value) {
///     if (fieldName == 'email' && !value.toString().contains('@company.com')) {
///       return ['Must use company email'];
///     }
///     return [];
///   }
/// }
/// ```
library;

export 'jet_form_builder.dart';
export 'jet_form_consumer.dart';
export 'jet_form_notifier.dart';
export 'mixins/mixins.dart';
