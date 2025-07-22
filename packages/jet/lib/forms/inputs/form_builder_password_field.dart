import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/jet_framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FormBuilderPasswordField extends HookWidget {
  final String name;
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final bool showPrefixIcon;
  final bool isRequired;
  final GlobalKey<FormBuilderState>? formKey;
  final String? identicalWith;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool autofocus;
  final bool enabled;

  const FormBuilderPasswordField({
    super.key,
    required this.name,
    this.initialValue,
    this.validator,
    this.prefixIcon,
    this.showPrefixIcon = true,
    this.isRequired = true,
    this.formKey,
    this.identicalWith,
    this.hintText = '',
    this.obscureText = true,
    this.keyboardType,
    this.readOnly = false,
    this.autofocus = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final obscureText = useState(true);

    void toggleVisibility() {
      obscureText.value = !obscureText.value;
    }

    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      obscureText: obscureText.value,
      enabled: enabled,
      decoration: InputDecoration(
        prefixIcon: showPrefixIcon ? Icon(LucideIcons.lock) : prefixIcon,
        hintText: hintText,
        suffixIcon: IconButton(
          icon: Icon(
            obscureText.value ? LucideIcons.eye : LucideIcons.eyeClosed,
          ),
          onPressed: toggleVisibility,
        ),
      ),
      validator: validator ??
          FormBuilderValidators.compose([
            if (isRequired) FormBuilderValidators.required(),
            (value) {
              if (identicalWith != null) {
                if (formKey == null) {
                  throw FlutterError(
                    'formKey is required when using identicalWith for this field $name',
                  );
                }
                if (value !=
                    formKey?.currentState?.fields[identicalWith]?.value) {
                  return context.jetI10n.passwordNotIdentical;
                }
              }
              return null;
            }
          ]),
    );
  }
}
