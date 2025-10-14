/// Jet Forms Hooks
///
/// Provides hook-based utilities for simplified form handling.
///
/// The [useJetForm] hook allows you to create forms without defining
/// separate notifier classes, making it ideal for simple forms and
/// rapid prototyping.
///
/// Example:
/// ```dart
/// class MyPage extends HookConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final form = useJetForm<MyRequest, MyResponse>(
///       decoder: (json) => MyRequest.fromJson(json),
///       action: (request) => apiService.submit(request),
///       onSuccess: (response, request) {
///         // Handle success
///       },
///     );
///
///     return JetSimpleForm(
///       controller: form,
///       children: [
///         FormBuilderTextField(name: 'field1'),
///         FormBuilderTextField(name: 'field2'),
///       ],
///     );
///   }
/// }
/// ```
library;

export 'jet_form_controller.dart';
export 'use_jet_form.dart';
