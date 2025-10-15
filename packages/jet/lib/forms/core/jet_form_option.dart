import 'package:flutter/widgets.dart';

/// A reusable option class for form fields that support multiple choices.
///
/// Used by fields like [JetDropdown], [JetRadioGroup], [JetCheckboxGroup],
/// [JetChoiceChips], and [JetFilterChips].
///
/// Example:
/// ```dart
/// JetDropdown<String>(
///   name: 'country',
///   options: [
///     JetFormOption(value: 'us', child: Text('United States')),
///     JetFormOption(value: 'uk', child: Text('United Kingdom')),
///     JetFormOption(value: 'ca', child: Text('Canada')),
///   ],
/// )
/// ```
class JetFormOption<T> {
  /// The value of this option.
  final T value;

  /// The widget to display for this option.
  final Widget child;

  /// Whether this option is enabled.
  ///
  /// If false, the option will be displayed but not selectable.
  final bool enabled;

  /// Creates a form option.
  const JetFormOption({
    required this.value,
    required this.child,
    this.enabled = true,
  });
}
