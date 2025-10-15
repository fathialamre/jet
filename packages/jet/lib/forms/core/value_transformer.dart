/// A function that transforms a field value before it's saved or used.
///
/// This is useful for:
/// - Converting strings to numbers
/// - Trimming whitespace
/// - Formatting data
/// - Converting to different types
///
/// Example:
/// ```dart
/// valueTransformer: (value) => int.tryParse(value ?? '0')
/// ```
typedef ValueTransformer<T> = dynamic Function(T? value);

