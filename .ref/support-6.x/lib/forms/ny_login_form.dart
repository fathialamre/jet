import '/widgets/ny_form.dart';

/// NyLoginForm class
class NyLoginForm extends NyFormData {
  NyLoginForm({
    String? name,
    this.emailValidationRule,
    this.emailValidationMessage,
    this.passwordValidationRule,
    this.passwordValidationMessage,
    this.passwordViewable = true,
    this.autofocus = false,
    String? style,
  })  : _style = style ?? "compact",
        super(name ?? "login");

  /// Email field - Validation rule
  String? emailValidationRule;

  /// Email field - Validation message
  String? emailValidationMessage;

  /// Password field - Validation rule
  String? passwordValidationRule;

  /// Password field - Validation message
  String? passwordValidationMessage;

  /// Password viewable
  bool passwordViewable;

  /// Style of the fields
  final String? _style;

  /// Autofocus
  bool autofocus;

  @override
  fields() => [
        Field.email("Email",
            autofocus: autofocus,
            validate: emailValidationRule == null
                ? null
                : FormValidator.rule(emailValidationRule,
                    message: emailValidationMessage),
            style: _style),
        Field.password("Password",
            viewable: passwordViewable,
            validate: passwordValidationRule == null
                ? null
                : FormValidator.rule(passwordValidationRule,
                    message: passwordValidationMessage),
            style: _style),
      ];
}
