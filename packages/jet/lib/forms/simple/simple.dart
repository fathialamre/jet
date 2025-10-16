/// Simple Forms
///
/// Simplified form handling using hooks for 80% of use cases.
/// Perfect for: login, registration, settings, contact forms.
///
/// Example:
/// ```dart
/// class LoginPage extends HookConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final form = useJetForm<LoginRequest, LoginResponse>(
///       ref: ref,
///       decoder: (json) => LoginRequest.fromJson(json),
///       action: (request) => api.login(request),
///     );
///
///     return JetSimpleForm(
///       form: form,
///       children: [
///         JetTextField(name: 'email'),
///         JetPasswordField(name: 'password'),
///       ],
///     );
///   }
/// }
/// ```
library;

export 'jet_form_controller.dart';
export 'jet_simple_form.dart';
export 'use_jet_form.dart';
