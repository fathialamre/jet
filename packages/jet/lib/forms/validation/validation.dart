/// Jet Form Validation Library
///
/// A comprehensive validation system with 90+ validators across 10 categories.
///
/// ## Categories
///
/// - **Core**: compose, or, conditional, required, equal
/// - **String**: alphabetical, contains, match, uppercase, lowercase, word count
/// - **Numeric**: numeric, integer, float, min/max, range, even/odd, prime
/// - **Collection**: min/max/equal length, contains element, unique
/// - **Network**: email, URL, IP, phone, latitude, longitude
/// - **DateTime**: date, time, datetime, range, future, past
/// - **Identity**: names, username, password, SSN, address fields
/// - **Finance**: credit card, CVC, expiration, IBAN, BIC
/// - **File**: extension, size, name, MIME type, path
/// - **Bool**: isTrue, isFalse
/// - **Usecase**: UUID, JSON, ISBN, color code, base64, VIN
///
/// ## Example
///
/// ```dart
/// import 'package:jet/forms/validation/validation.dart';
///
/// // Using validators directly
/// final validator = EmailValidator().validate;
///
/// // Or use the JetValidators facade
/// import 'package:jet/forms/validators/jet_validators.dart';
/// final validator = JetValidators.email();
/// ```
library;

// Base validators
export 'base_validator.dart';
export 'translated_validator.dart';
export 'validator_extensions.dart';

// Core validators
export 'core/core.dart';

// Category validators
export 'string/string.dart';
export 'numeric/numeric.dart';
export 'collection/collection.dart';
export 'network/network.dart';
export 'datetime/datetime.dart';
export 'identity/identity.dart';
export 'finance/finance.dart';
export 'file/file.dart';
export 'bool/bool.dart';
export 'usecase/usecase.dart';
