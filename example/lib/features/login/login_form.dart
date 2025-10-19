import 'package:jet/jet_framework.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'models/login_request.dart';
import 'models/login_response.dart';

part 'login_form.g.dart';

/// Login form notifier using Advanced Forms approach
///
/// This demonstrates the JetFormNotifier with JetFormMixin pattern
/// for handling form submission with custom validation and lifecycle hooks.
@riverpod
class LoginForm extends _$LoginForm
    with JetFormMixin<LoginRequest, LoginResponse> {
  @override
  AsyncFormValue<LoginRequest, LoginResponse> build() {
    return const AsyncFormIdle();
  }

  @override
  LoginRequest decoder(Map<String, dynamic> json) {
    return LoginRequest.fromJson(json);
  }

  @override
  Future<LoginResponse> action(LoginRequest data) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Simulate successful login
    return LoginResponse(
      token: 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: data.email,
      name: 'John Doe',
    );
  }

  /// Custom field validation (Advanced feature)
  @override
  List<String> validateField(String fieldName, dynamic value) {
    switch (fieldName) {
      case 'email':
        // Additional validation: must be a company email
        if (value != null &&
            value.toString().isNotEmpty &&
            !value.toString().contains('@')) {
          return ['Invalid email format'];
        }
        break;

      case 'password':
        // Additional validation: check password strength
        if (value != null && value.toString().length < 6) {
          return ['Password must be at least 6 characters'];
        }
        break;
    }
    return [];
  }
}
