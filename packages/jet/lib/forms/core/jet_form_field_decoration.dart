import 'package:flutter/material.dart';
import 'jet_form_field.dart';

/// A [JetFormField] that provides [InputDecoration] for fields.
///
/// This is the base class for form fields that use Material Design's
/// [InputDecoration], such as text fields, dropdowns, etc.
abstract class JetFormFieldDecoration<T> extends JetFormField<T> {
  /// The decoration to show around the field.
  final InputDecoration decoration;

  /// Creates a form field with decoration support.
  const JetFormFieldDecoration({
    super.key,
    required super.name,
    super.validator,
    super.onSaved,
    super.initialValue,
    super.autovalidateMode,
    super.enabled,
    super.onChanged,
    super.valueTransformer,
    super.focusNode,
    super.restorationId,
    required super.builder,
    super.errorBuilder,
    super.onReset,
    this.decoration = const InputDecoration(),
  });

  @override
  JetFormFieldDecorationState<JetFormFieldDecoration<T>, T> createState() =>
      JetFormFieldDecorationState<JetFormFieldDecoration<T>, T>();
}

/// State for [JetFormFieldDecoration].
class JetFormFieldDecorationState<F extends JetFormFieldDecoration<T>, T>
    extends JetFormFieldState<F, T> {
  /// Returns the effective decoration with error text applied.
  InputDecoration get decoration {
    final InputDecoration effectiveDecoration = widget.decoration;

    return effectiveDecoration.copyWith(
      errorText: widget.decoration.errorText ?? errorText,
      enabled: enabled,
    );
  }
}
