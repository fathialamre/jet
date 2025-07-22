import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FormBuilderPhoneNumberField extends HookWidget {
  final String name;
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final bool showPrefixIcon;
  final bool isRequired;
  final String hintText;
  final bool autofocus;
  final bool enabled;

  const FormBuilderPhoneNumberField({
    super.key,
    required this.name,
    this.initialValue,
    this.validator,
    this.showPrefixIcon = true,
    this.prefixIcon,
    this.autofocus = false,
    this.isRequired = true,
    this.hintText = '',
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      autofocus: autofocus,
      decoration: InputDecoration(
        prefixIcon: showPrefixIcon ? Icon(LucideIcons.phone) : prefixIcon,
        hintText: hintText,
      ),
      validator:
          validator ??
          FormBuilderValidators.compose([
            if (isRequired) FormBuilderValidators.required(),
            FormBuilderValidators.numeric(),
            FormBuilderValidators.minLength(10),
            FormBuilderValidators.maxLength(15),
          ]),
    );
  }
}
