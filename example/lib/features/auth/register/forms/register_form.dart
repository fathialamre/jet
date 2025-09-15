import 'package:example/features/auth/register/models/register_request.dart';
import 'package:example/features/auth/register/models/register_response.dart';
import 'package:jet/helpers/jet_logger.dart';
import 'package:jet/jet_framework.dart';

class RegisterForm extends JetFormNotifier<RegisterRequest, RegisterResponse> {
  RegisterForm(super.ref);

  @override
  bool get validateOnChange => true;

  @override
  bool get validateOnFocusLoss => true;

  @override
  RegisterRequest decoder(Map<String, dynamic> json) {
    return RegisterRequest.fromJson(json);
  }

  @override
  Future<RegisterResponse> action(RegisterRequest data) async {
    dump(data);
    await 1.sleep();
    return RegisterResponse(ttl: '1300');
  }

  @override
  List<String> validateField(String fieldName, dynamic value) {
    switch (fieldName) {
      case 'email':
        if (value == null || value.toString().isEmpty) {
          return ['Email is required'];
        }
        if (!RegExp(
          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
        ).hasMatch(value.toString())) {
          return ['Please enter a valid email address'];
        }
        break;
      case 'phone':
        if (value == null || value.toString().isEmpty) {
          return ['Phone number is required'];
        }
        if (value.toString().length < 10) {
          return ['Phone number must be at least 10 digits'];
        }
        break;
      case 'password':
        if (value == null || value.toString().isEmpty) {
          return ['Password is required'];
        }
        if (value.toString().length < 8) {
          return ['Password must be at least 8 characters'];
        }
        break;
    }
    return [];
  }
}

// @riverpod
// Future<RegisterForm> registerForm(Ref ref) async {
//   return RegisterForm(ref);
// }

final registerFormProvider = JetFormProvider<RegisterRequest, RegisterResponse>(
  (ref) => RegisterForm(ref),
);
