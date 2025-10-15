import 'package:faker_dart/faker_dart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

void main() {
  final Faker faker = Faker.instance;
  final String customErrorMessage = faker.lorem.sentence();

  group('EmailValidator -', () {
    test('should return null if the email address is valid', () {
      // Arrange
      final EmailValidator validator = EmailValidator(
        errorText: customErrorMessage,
      );
      const String validEmail = 'user@example.com';

      // Act
      final String? result = validator.validate(validEmail);

      // Assert
      expect(result, isNull);
    });

    test(
      'should return null if the email address is a valid generated email',
      () {
        // Arrange
        final EmailValidator validator = EmailValidator(
          errorText: customErrorMessage,
        );
        final String validEmail = faker.internet.email();

        // Act
        final String? result = validator.validate(validEmail);

        // Assert
        expect(result, isNull);
      },
    );

    test('should return the error text if the email address is invalid', () {
      // Arrange
      final EmailValidator validator = EmailValidator(
        errorText: customErrorMessage,
      );
      const String invalidEmail = 'invalid-email';

      // Act
      final String? result = validator.validate(invalidEmail);

      // Assert
      expect(result, customErrorMessage);
    });

    test('should return the error text if the email address is empty', () {
      // Arrange
      final EmailValidator validator = EmailValidator(
        errorText: customErrorMessage,
      );
      const String emptyEmail = '';

      // Act
      final String? result = validator.validate(emptyEmail);

      // Assert
      expect(result, customErrorMessage);
    });

    test('should return the error text if the email address is null', () {
      // Arrange
      final EmailValidator validator = EmailValidator(
        errorText: customErrorMessage,
      );
      const String? nullEmail = null;

      // Act
      final String? result = validator.validate(nullEmail);

      // Assert
      expect(result, customErrorMessage);
    });

    test('should return the error text if the email address is whitespace', () {
      // Arrange
      final EmailValidator validator = EmailValidator(
        errorText: customErrorMessage,
      );
      const String whitespaceEmail = ' ';

      // Act
      final String? result = validator.validate(whitespaceEmail);

      // Assert
      expect(result, customErrorMessage);
    });

    test(
      'should return the default error text if the email address is invalid and no custom error message is provided',
      () {
        // Arrange
        final EmailValidator validator = EmailValidator();
        const String invalidEmail = 'invalid-email';

        // Act
        final String? result = validator.validate(invalidEmail);

        // Assert
        expect(result, FormBuilderLocalizations.current.emailErrorText);
      },
    );

    test(
      'should return null if the email address is valid according to a custom regex',
      () {
        // Arrange
        final RegExp customRegex = RegExp(r'^[\w\.-]+@example\.com$');
        final EmailValidator validator = EmailValidator(
          regex: customRegex,
          errorText: customErrorMessage,
        );
        const String validEmail = 'user@example.com';

        // Act
        final String? result = validator.validate(validEmail);

        // Assert
        expect(result, isNull);
      },
    );

    test(
      'should return the custom error text if the email address is invalid according to a custom regex',
      () {
        // Arrange
        final RegExp customRegex = RegExp(r'^[\w\.-]+@example\.com$');
        final EmailValidator validator = EmailValidator(
          regex: customRegex,
          errorText: customErrorMessage,
        );
        const String invalidEmail = 'user@notexample.com';

        // Act
        final String? result = validator.validate(invalidEmail);

        // Assert
        expect(result, customErrorMessage);
      },
    );

    test(
      'should return null when the email address is null and null check is disabled',
      () {
        // Arrange
        final EmailValidator validator = EmailValidator(
          checkNullOrEmpty: false,
        );
        const String? nullEmail = null;

        // Act
        final String? result = validator.validate(nullEmail);

        // Assert
        expect(result, isNull);
      },
    );

    test(
      'should return null when the email address is empty and null check is disabled',
      () {
        // Arrange
        final EmailValidator validator = EmailValidator(
          checkNullOrEmpty: false,
        );
        const String emptyEmail = '';

        // Act
        final String? result = validator.validate(emptyEmail);

        // Assert
        expect(result, isNull);
      },
    );
  });
}
