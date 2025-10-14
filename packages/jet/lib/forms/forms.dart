/// Jet Forms Module
///
/// A comprehensive form management solution for Flutter applications using the Jet framework.
///
/// This module provides:
/// - **State Management**: AsyncFormValue pattern for form states
/// - **Form Notifiers**: JetFormNotifier for handling form logic
/// - **Form Builder**: JetFormBuilder for constructing forms
/// - **Form Hooks**: useJetForm for simplified inline forms
/// - **Input Widgets**: Pre-built form fields with validation
///
/// ## Basic Usage with JetFormNotifier
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
///
/// ## Simplified Usage with useJetForm Hook
///
/// ```dart
/// class LoginPage extends HookConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final form = useJetForm<LoginRequest, LoginResponse>(
///       decoder: (json) => LoginRequest.fromJson(json),
///       action: (request) => apiService.login(request),
///       onSuccess: (response, request) {
///         // Handle success
///       },
///     );
///
///     return JetSimpleForm(
///       controller: form,
///       children: [
///         FormBuilderTextField(name: 'email'),
///         JetPasswordField(name: 'password'),
///       ],
///     );
///   }
/// }
/// ```
library;

// Core types and state management
export 'common.dart';

// Notifiers
export 'notifiers/notifiers.dart';

// Widgets
export 'widgets/widgets.dart';

// Input fields
export 'inputs/inputs.dart';

// Hooks
export 'hooks/hooks.dart';
