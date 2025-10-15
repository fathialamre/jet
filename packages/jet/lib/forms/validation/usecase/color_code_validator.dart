import '../base_validator.dart';

/// Validator that requires a valid color code.
///
/// Example:
/// ```dart
/// JetTextField(
///   name: 'color',
///   validator: ColorCodeValidator().validate,
/// )
/// ```
class ColorCodeValidator extends BaseValidator<String> {
  /// Color format to validate (hex, rgb, rgba, hsl, hsla)
  final String? format;

  /// Creates a color code validator.
  const ColorCodeValidator({
    this.format,
    super.errorText,
    super.checkNullOrEmpty,
  });

  @override
  String? validateValue(String valueCandidate) {
    final value = valueCandidate.trim();

    if (format == null || format == 'hex') {
      // Hex color: #RGB, #RRGGBB, #RRGGBBAA
      final hexPattern = RegExp(
        r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$',
      );
      if (hexPattern.hasMatch(value)) return null;
      if (format == 'hex') {
        return errorText ?? 'Please enter a valid hex color code';
      }
    }

    if (format == null || format == 'rgb') {
      // RGB: rgb(255, 255, 255)
      final rgbPattern = RegExp(
        r'^rgb\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*\)$',
      );
      if (rgbPattern.hasMatch(value)) return null;
      if (format == 'rgb') {
        return errorText ?? 'Please enter a valid RGB color';
      }
    }

    if (format == null || format == 'rgba') {
      // RGBA: rgba(255, 255, 255, 0.5)
      final rgbaPattern = RegExp(
        r'^rgba\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(0|1|0?\.\d+)\s*\)$',
      );
      if (rgbaPattern.hasMatch(value)) return null;
      if (format == 'rgba') {
        return errorText ?? 'Please enter a valid RGBA color';
      }
    }

    if (format == null || format == 'hsl') {
      // HSL: hsl(360, 100%, 100%)
      final hslPattern = RegExp(
        r'^hsl\(\s*(\d{1,3})\s*,\s*(\d{1,3})%\s*,\s*(\d{1,3})%\s*\)$',
      );
      if (hslPattern.hasMatch(value)) return null;
      if (format == 'hsl') {
        return errorText ?? 'Please enter a valid HSL color';
      }
    }

    if (format == null || format == 'hsla') {
      // HSLA: hsla(360, 100%, 100%, 0.5)
      final hslaPattern = RegExp(
        r'^hsla\(\s*(\d{1,3})\s*,\s*(\d{1,3})%\s*,\s*(\d{1,3})%\s*,\s*(0|1|0?\.\d+)\s*\)$',
      );
      if (hslaPattern.hasMatch(value)) return null;
      if (format == 'hsla') {
        return errorText ?? 'Please enter a valid HSLA color';
      }
    }

    return errorText ?? 'Please enter a valid color code';
  }
}
