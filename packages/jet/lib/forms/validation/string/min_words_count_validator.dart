import '../base_validator.dart';

/// Validator that requires a minimum word count.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'description',
///   validator: MinWordsCountValidator(10).validate,
/// )
/// ```
class MinWordsCountValidator extends BaseValidator<String> {
  /// The minimum number of words required.
  final int minWordsCount;

  /// Creates a minimum words count validator.
  const MinWordsCountValidator(
    this.minWordsCount, {
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    final words = valueCandidate.trim().split(RegExp(r'\s+'));
    final wordCount = words.where((w) => w.isNotEmpty).length;

    if (wordCount < minWordsCount) {
      return errorText ??
          'Value must contain at least $minWordsCount word${minWordsCount > 1 ? 's' : ''}';
    }
    return null;
  }
}

