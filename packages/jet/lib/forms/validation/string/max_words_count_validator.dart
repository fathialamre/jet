import '../base_validator.dart';

/// Validator that requires a maximum word count.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'summary',
///   validator: MaxWordsCountValidator(50).validate,
/// )
/// ```
class MaxWordsCountValidator extends BaseValidator<String> {
  /// The maximum number of words allowed.
  final int maxWordsCount;

  /// Creates a maximum words count validator.
  const MaxWordsCountValidator(
    this.maxWordsCount, {
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    final words = valueCandidate.trim().split(RegExp(r'\s+'));
    final wordCount = words.where((w) => w.isNotEmpty).length;

    if (wordCount > maxWordsCount) {
      return errorText ??
          'Value must contain at most $maxWordsCount word${maxWordsCount > 1 ? 's' : ''}';
    }
    return null;
  }
}

