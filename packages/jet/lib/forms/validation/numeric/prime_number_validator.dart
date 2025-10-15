import '../base_validator.dart';

/// Validator that requires a prime number.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'prime',
///   validator: PrimeNumberValidator().validate,
/// )
/// ```
class PrimeNumberValidator<T> extends BaseValidator<T> {
  /// Creates a prime number validator.
  const PrimeNumberValidator({
    super.errorText,
    super.checkNullOrEmpty,
  });

  bool _isPrime(int n) {
    if (n <= 1) return false;
    if (n <= 3) return true;
    if (n % 2 == 0 || n % 3 == 0) return false;

    for (int i = 5; i * i <= n; i += 6) {
      if (n % i == 0 || n % (i + 2) == 0) return false;
    }

    return true;
  }

  @override
  String? validateValue(T valueCandidate) {
    int? value;

    if (valueCandidate is int) {
      value = valueCandidate;
    } else if (valueCandidate is num) {
      value = (valueCandidate as num).toInt();
    } else if (valueCandidate is String) {
      value = int.tryParse(valueCandidate);
    }

    if (value == null) {
      return errorText ?? 'Value must be an integer';
    }

    if (!_isPrime(value)) {
      return errorText ?? 'Value must be a prime number';
    }
    return null;
  }
}
