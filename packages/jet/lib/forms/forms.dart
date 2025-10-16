/// Jet Forms Module
///
/// A comprehensive form management solution for Flutter applications.
///
/// ## Two Approaches Available
///
/// ### 🎯 Simple Forms (Recommended for Getting Started)
///
/// Use `useJetForm` hook with `JetSimpleForm` for straightforward forms.
/// Perfect for most use cases: login, registration, settings, contact forms, etc.
///
/// **When to use:**
/// - Standard forms with 3-20 fields
/// - Basic validation and error handling
/// - Simple submit → success/error flow
/// - 80% of typical app forms
///
/// **Quick Example:**
/// ```dart
/// class LoginPage extends HookConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final form = useJetForm<LoginRequest, LoginResponse>(
///       ref: ref,
///       decoder: (json) => LoginRequest.fromJson(json),
///       action: (request) => apiService.login(request),
///       onSuccess: (response, request) {
///         context.showToast('Login successful!');
///       },
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
///
/// 📖 **See:** `docs/FORMS_SIMPLE.md` for complete guide
///
/// ---
///
/// ### 🚀 Advanced Forms (For Complex Requirements)
///
/// Use `JetFormNotifier` with `JetFormBuilder` for enterprise features.
/// Needed for complex scenarios that require fine-grained control.
///
/// **When to use:**
/// - Multi-step wizards (3+ steps)
/// - Conditional field visibility
/// - Complex cross-field validation
/// - Server-side validation with field-specific errors
/// - Form state persistence across navigation
/// - Custom lifecycle hooks
/// - Validation result caching
///
/// **Quick Example:**
/// ```dart
/// @riverpod
/// class LoginForm extends _$LoginForm with JetFormMixin<LoginRequest, LoginResponse> {
///   @override
///   AsyncFormValue<LoginRequest, LoginResponse> build() {
///     return const AsyncFormIdle();
///   }
///
///   @override
///   LoginRequest decoder(Map<String, dynamic> json) => LoginRequest.fromJson(json);
///
///   @override
///   Future<LoginResponse> action(LoginRequest data) => apiService.login(data);
///
///   // Add custom validation, lifecycle hooks, etc.
/// }
/// ```
///
/// 📖 **See:** `docs/FORMS_ADVANCED.md` for complete guide
///
/// ---
///
/// ## Not Sure Which to Use?
///
/// **Start with Simple Forms** (`useJetForm`). You can always migrate to Advanced
/// Forms later if you need enterprise features.
///
/// See `WHICH_APPROACH.md` for a decision tree.
///
library;

// ============================================================================
// SIMPLE FORMS - Start Here (80% of use cases)
// ============================================================================
// Use for: login, registration, settings, contact forms
// Learn more: docs/FORMS_SIMPLE.md

export 'simple/simple.dart';

// ============================================================================
// ADVANCED FORMS - Enterprise Features (20% of use cases)
// ============================================================================
// Use for: multi-step wizards, conditional fields, complex validation
// Learn more: docs/FORMS_ADVANCED.md

export 'advanced/advanced.dart';

// ============================================================================
// SHARED - Used by Both Approaches
// ============================================================================
// Core form state and types
export 'common.dart';
export 'core/core.dart';

// Form input widgets (works with both Simple and Advanced)
export 'inputs/inputs.dart';

// Validation rules (70+ validators)
export 'validation/validation.dart';

// Localization for form messages
export 'localization/localization.dart';

// Form change detection
export 'widgets/jet_form_change_listener.dart';
export 'widgets/widgets.dart';
