/// Jet Forms Module
///
/// A comprehensive form management solution for Flutter applications using the Jet framework.
///
/// This module provides:
/// - **State Management**: AsyncFormValue pattern for form states
/// - **Form Notifiers**: JetFormNotifier for handling form logic
/// - **Form Builder**: JetFormBuilder for constructing forms
/// - **Input Widgets**: Pre-built form fields with validation
///
/// ## Basic Usage
///
/// ```dart
/// // 1. Define your form notifier
/// class LoginFormNotifier extends JetFormNotifier<LoginRequest, LoginResponse> {
///   @override
///   LoginRequest decoder(Map<String, dynamic> json) {
///     return LoginRequest.fromJson(json);
///   }
///
///   @override
///   Future<LoginResponse> action(LoginRequest data) async {
///     return await apiService.login(data);
///   }
/// }
///
/// // 2. Create a provider
/// final loginFormProvider = JetFormProvider<LoginRequest, LoginResponse>(
///   (ref) => LoginFormNotifier(ref),
/// );
///
/// // 3. Build your form UI
/// JetFormBuilder<LoginRequest, LoginResponse>(
///   provider: loginFormProvider,
///   builder: (context, ref, form, state) {
///     return [
///       JetTextField(name: 'email'),
///       JetPasswordField(name: 'password'),
///     ];
///   },
///   onSuccess: (response, request) {
///     // Handle success
///   },
/// )
/// ```
library jet_forms;

// Core types and state management
export 'common.dart';

// Mixins for form functionality
export 'mixins/mixins.dart';

// Notifiers
export 'notifiers/notifiers.dart';

// Widgets
export 'widgets/widgets.dart';

// Input fields
export 'inputs/inputs.dart';
