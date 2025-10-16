import 'package:flutter/widgets.dart';
import 'value_transformer.dart';

/// A single form field in a JetForm.
///
/// This is the base class for all Jet form fields. It maintains the current
/// state of the form field so that updates and validation errors are
/// visually reflected in the UI.
///
/// This widget wraps Flutter's [FormField] and adds additional functionality
/// specific to the Jet framework.
class JetFormField<T> extends FormField<T> {
  /// Used to reference the field within the form, or to reference form data
  /// after the form is submitted.
  final String name;

  /// Called just before field value is saved. Used to massage data just before
  /// committing the value.
  ///
  /// Example: Convert age string to number
  /// ```dart
  /// JetTextField(
  ///   name: 'age',
  ///   valueTransformer: (text) => num.tryParse(text),
  ///   validator: JetValidators.numeric(),
  /// )
  /// ```
  final ValueTransformer<T?>? valueTransformer;

  /// Called when the field value is changed.
  final ValueChanged<T?>? onChanged;

  /// The focus node for this field.
  final FocusNode? focusNode;

  /// Creates a single form field.
  const JetFormField({
    super.key,
    super.onSaved,
    super.initialValue,
    super.autovalidateMode,
    super.enabled = true,
    super.validator,
    super.restorationId,
    required super.builder,
    super.errorBuilder,
    super.onReset,
    required this.name,
    this.valueTransformer,
    this.onChanged,
    this.focusNode,
  });

  @override
  JetFormFieldState<JetFormField<T>, T> createState() =>
      JetFormFieldState<JetFormField<T>, T>();
}

/// State for [JetFormField].
class JetFormFieldState<F extends JetFormField<T>, T>
    extends FormFieldState<T> {
  String? _customErrorText;
  JetFormState? _formState;
  bool _touched = false;
  bool _dirty = false;

  /// The focus node that is used to focus this field.
  late FocusNode effectiveFocusNode;

  /// The focus attachment for the [effectiveFocusNode].
  FocusAttachment? focusAttachment;

  @override
  F get widget => super.widget as F;

  /// Returns the parent [JetFormState] if it exists.
  JetFormState? get formState => _formState;

  /// Returns the initial value, which may be declared at the field, or by the
  /// parent [JetForm.initialValue]. When declared at both levels, the field
  /// initialValue prevails.
  T? get initialValue =>
      widget.initialValue ??
      (_formState?.initialValue ?? const <String, dynamic>{})[widget.name]
          as T?;

  /// Returns the transformed value using the valueTransformer if provided.
  dynamic get transformedValue =>
      widget.valueTransformer == null ? value : widget.valueTransformer!(value);

  @override
  String? get errorText => super.errorText ?? _customErrorText;

  @override
  bool get hasError => super.hasError || errorText != null;

  @override
  bool get isValid => super.isValid && _customErrorText == null;

  /// Returns true if the field is valid (ignoring custom errors).
  bool get valueIsValid => super.isValid;

  /// Returns true if the field has a validation error (ignoring custom errors).
  bool get valueHasError => super.hasError;

  /// Returns true if the field is enabled and the parent form is enabled.
  bool get enabled => widget.enabled && (_formState?.enabled ?? true);

  /// Returns true if the field is read only.
  bool get readOnly => !(_formState?.widget.skipDisabled ?? false);

  /// Returns true if the field value has been changed by user or code.
  bool get isDirty => _dirty;

  /// Returns true if the field has been focused by user or code.
  bool get isTouched => _touched;

  /// Registers the value transformer with the form.
  void registerTransformer(Map<String, Function> map) {
    final fun = widget.valueTransformer;
    if (fun != null) {
      map[widget.name] = fun;
    }
  }

  @override
  void initState() {
    super.initState();
    // Register this field when there is a parent JetForm
    _formState = JetForm.of(context);
    _formState?.registerField(widget.name, this);

    effectiveFocusNode = widget.focusNode ?? FocusNode(debugLabel: widget.name);
    // Register a touch handler
    effectiveFocusNode.addListener(_touchedHandler);
    focusAttachment = effectiveFocusNode.attach(context);
  }

  @override
  void didUpdateWidget(covariant JetFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.name != oldWidget.name) {
      _formState?.unregisterField(oldWidget.name, this);
      _formState?.registerField(widget.name, this);
    }
    if (widget.focusNode != oldWidget.focusNode) {
      focusAttachment?.detach();
      effectiveFocusNode.removeListener(_touchedHandler);
      effectiveFocusNode =
          widget.focusNode ?? FocusNode(canRequestFocus: enabled);
      effectiveFocusNode.addListener(_touchedHandler);
      focusAttachment = effectiveFocusNode.attach(context);
    }
  }

  @override
  void dispose() {
    effectiveFocusNode.removeListener(_touchedHandler);
    // Only dispose if we created the focus node
    if (widget.focusNode == null) {
      effectiveFocusNode.dispose();
    }
    _formState?.unregisterField(widget.name, this);
    super.dispose();
  }

  void _informFormForFieldChange() {
    if (_formState != null) {
      _dirty = true;
      if (enabled || readOnly) {
        _formState!.setInternalFieldValue<T>(widget.name, value);
        return;
      }
      _formState!.removeInternalFieldValue(widget.name);
    }
  }

  void _touchedHandler() {
    if (effectiveFocusNode.hasFocus && _touched == false) {
      setState(() => _touched = true);
    }
  }

  @override
  void setValue(T? value, {bool populateForm = true}) {
    super.setValue(value);
    if (populateForm) {
      _informFormForFieldChange();
    }
  }

  @override
  void didChange(T? value) {
    super.didChange(value);
    _informFormForFieldChange();
    widget.onChanged?.call(value);
  }

  @override
  void reset() {
    super.reset();
    didChange(initialValue);
    _dirty = false;
    if (_customErrorText != null) {
      setState(() => _customErrorText = null);
    }
  }

  @override
  bool validate({
    bool clearCustomError = true,
    bool focusOnInvalid = true,
    bool autoScrollWhenFocusOnInvalid = false,
  }) {
    if (clearCustomError) {
      setState(() => _customErrorText = null);
    }
    final isValid = super.validate() && !hasError;

    final fields =
        _formState?.fields ??
        <String, JetFormFieldState<JetFormField<dynamic>, dynamic>>{};

    if (!isValid &&
        focusOnInvalid &&
        (formState?.focusOnInvalid ?? true) &&
        enabled &&
        !fields.values.any((e) => e.effectiveFocusNode.hasFocus)) {
      focus();
      if (autoScrollWhenFocusOnInvalid) ensureScrollableVisibility();
    }

    return isValid;
  }

  /// Invalidate field with a custom error message.
  ///
  /// [shouldFocus]: Whether to focus the field (default: true)
  /// [shouldAutoScrollWhenFocus]: Whether to auto-scroll when focused (default: false)
  void invalidate(
    String errorText, {
    bool shouldFocus = true,
    bool shouldAutoScrollWhenFocus = false,
  }) {
    setState(() => _customErrorText = errorText);

    validate(
      clearCustomError: false,
      autoScrollWhenFocusOnInvalid: shouldAutoScrollWhenFocus,
      focusOnInvalid: shouldFocus,
    );
  }

  /// Request focus for this field.
  void focus() {
    FocusScope.of(context).requestFocus(effectiveFocusNode);
  }

  /// Scroll to make this field visible.
  void ensureScrollableVisibility() {
    Scrollable.ensureVisible(context);
  }
}

/// Forward declaration of JetForm and JetFormState
/// (will be defined in jet_form.dart)
class JetForm extends StatefulWidget {
  const JetForm({
    super.key,
    required this.child,
    this.onChanged,
    this.autovalidateMode,
    this.onPopInvokedWithResult,
    this.initialValue = const <String, dynamic>{},
    this.skipDisabled = false,
    this.enabled = true,
    this.clearValueOnUnregister = false,
    this.canPop,
  });

  final Widget child;
  final VoidCallback? onChanged;
  final AutovalidateMode? autovalidateMode;
  final PopInvokedWithResultCallback<Object?>? onPopInvokedWithResult;
  final Map<String, dynamic> initialValue;
  final bool skipDisabled;
  final bool enabled;
  final bool clearValueOnUnregister;
  final bool? canPop;

  static JetFormState? of(BuildContext context) =>
      context.findAncestorStateOfType<JetFormState>();

  @override
  JetFormState createState() => JetFormState();
}

class JetFormState extends State<JetForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, JetFormFieldState<JetFormField<dynamic>, dynamic>> _fields =
      {};
  final Map<String, dynamic> _instantValue = {};
  final Map<String, dynamic> _savedValue = {};
  final Map<String, Function> _transformers = {};
  bool _focusOnInvalid = true;

  /// Notifier that triggers when form field values change
  final ValueNotifier<int> _changeNotifier = ValueNotifier<int>(0);

  bool get focusOnInvalid => _focusOnInvalid;
  bool get enabled => widget.enabled;
  bool get isValid => fields.values.every((field) => field.isValid);
  bool get isDirty => fields.values.any((field) => field.isDirty);
  bool get isTouched => fields.values.any((field) => field.isTouched);

  /// Listenable that notifies when form field values change
  ValueNotifier<int> get changeNotifier => _changeNotifier;

  /// Returns true if any field value differs from its initial value.
  /// Empty strings, lists, and maps are considered equal to null.
  bool get hasChanges {
    // Compare each registered field's current value with its initial value
    for (final entry in _fields.entries) {
      final fieldName = entry.key;
      final field = entry.value;
      final currentValue = _instantValue[fieldName];
      final fieldInitialValue = field.initialValue;

      if (!_valuesAreEqual(currentValue, fieldInitialValue)) {
        return true;
      }
    }

    return false;
  }

  /// Helper method to compare two values intelligently.
  /// Treats empty strings, lists, and maps as equal to null.
  bool _valuesAreEqual(dynamic value1, dynamic value2) {
    // Helper to normalize empty values to null
    dynamic normalize(dynamic val) {
      if (val == null) return null;
      if (val is String && val.isEmpty) return null;
      if (val is List && val.isEmpty) return null;
      if (val is Map && val.isEmpty) return null;
      return val;
    }

    final normalized1 = normalize(value1);
    final normalized2 = normalize(value2);

    // Basic equality
    return normalized1 == normalized2;
  }

  Map<String, String> get errors => {
    for (var element in fields.entries.where(
      (element) => element.value.hasError,
    ))
      element.key.toString(): element.value.errorText ?? '',
  };

  Map<String, dynamic> get initialValue => widget.initialValue;

  Map<String, JetFormFieldState<JetFormField<dynamic>, dynamic>> get fields =>
      _fields;

  Map<String, dynamic> get instantValue => Map<String, dynamic>.unmodifiable(
    _instantValue.map(
      (key, value) => MapEntry(
        key,
        _transformers[key] == null ? value : _transformers[key]!(value),
      ),
    ),
  );

  Map<String, dynamic> get value => Map<String, dynamic>.unmodifiable(
    _savedValue.map(
      (key, value) => MapEntry(
        key,
        _transformers[key] == null ? value : _transformers[key]!(value),
      ),
    ),
  );

  dynamic transformValue<T>(String name, T? v) {
    final t = _transformers[name];
    return t != null ? t.call(v) : v;
  }

  dynamic getTransformedValue<T>(String name, {bool fromSaved = false}) {
    return transformValue<T>(name, getRawValue(name));
  }

  T? getRawValue<T>(String name, {bool fromSaved = false}) {
    return (fromSaved ? _savedValue[name] : _instantValue[name]) ??
        initialValue[name];
  }

  void setInternalFieldValue<T>(String name, T? value) {
    _instantValue[name] = value;
    widget.onChanged?.call();
    // Notify listeners that form values have changed
    _changeNotifier.value++;
  }

  void removeInternalFieldValue(String name) {
    _instantValue.remove(name);
  }

  void registerField(String name, JetFormFieldState field) {
    final oldField = _fields[name];
    assert(() {
      if (oldField != null) {
        debugPrint(
          'Warning! Replacing duplicate Field for $name'
          ' -- this is OK to ignore as long as the field was intentionally replaced',
        );
      }
      return true;
    }());

    _fields[name] = field;
    field.registerTransformer(_transformers);

    if (widget.clearValueOnUnregister || (_instantValue[name] == null)) {
      _instantValue[name] = field.initialValue ?? initialValue[name];
    }

    field.setValue(_instantValue[name], populateForm: false);
  }

  void unregisterField(String name, JetFormFieldState field) {
    assert(
      _fields.containsKey(name),
      'Failed to unregister a field. Make sure that all field names in a form are unique.',
    );

    if (field == _fields[name]) {
      _fields.remove(name);
      _transformers.remove(name);
      if (widget.clearValueOnUnregister) {
        _instantValue.remove(name);
        _savedValue.remove(name);
      }
    } else {
      assert(() {
        debugPrint(
          'Warning! Ignoring Field unregistration for $name'
          ' -- this is OK to ignore as long as the field was intentionally replaced',
        );
        return true;
      }());
    }
  }

  void save() {
    _formKey.currentState!.save();
    _savedValue.clear();
    _savedValue.addAll(_instantValue);
  }

  bool validate({
    bool focusOnInvalid = true,
    bool autoScrollWhenFocusOnInvalid = false,
  }) {
    _focusOnInvalid = focusOnInvalid;
    final hasError = !_formKey.currentState!.validate();
    if (hasError) {
      final wrongFields = fields.values
          .where((element) => element.hasError)
          .toList();
      if (wrongFields.isNotEmpty) {
        if (focusOnInvalid) {
          wrongFields.first.focus();
        }
        if (autoScrollWhenFocusOnInvalid) {
          wrongFields.first.ensureScrollableVisibility();
        }
      }
    }
    return !hasError;
  }

  bool saveAndValidate({
    bool focusOnInvalid = true,
    bool autoScrollWhenFocusOnInvalid = false,
  }) {
    save();
    return validate(
      focusOnInvalid: focusOnInvalid,
      autoScrollWhenFocusOnInvalid: autoScrollWhenFocusOnInvalid,
    );
  }

  void reset() {
    _formKey.currentState?.reset();
  }

  void patchValue(Map<String, dynamic> val) {
    val.forEach((key, dynamic value) {
      _fields[key]?.didChange(value);
    });
  }

  @override
  void initState() {
    super.initState();
    // Auto validate if enabled
    if (enabled && widget.autovalidateMode == AutovalidateMode.always) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        validate(focusOnInvalid: false);
      });
    }
  }

  @override
  void dispose() {
    _changeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: widget.autovalidateMode,
      onPopInvokedWithResult: widget.onPopInvokedWithResult,
      canPop: widget.canPop,
      child: _JetFormScope(
        formState: this,
        child: FocusTraversalGroup(child: widget.child),
      ),
    );
  }
}

class _JetFormScope extends InheritedWidget {
  const _JetFormScope({
    required super.child,
    required JetFormState formState,
  }) : _formState = formState;

  final JetFormState _formState;

  JetForm get form => _formState.widget;

  @override
  bool updateShouldNotify(_JetFormScope oldWidget) =>
      oldWidget._formState != _formState;
}
