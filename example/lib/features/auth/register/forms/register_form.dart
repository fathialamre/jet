import 'package:example/features/auth/register/models/register_request.dart';
import 'package:example/features/auth/register/models/register_response.dart';
import 'package:jet/helpers/jet_logger.dart';
import 'package:jet/jet_framework.dart';

class RegisterForm extends JetFormNotifier<RegisterRequest, RegisterResponse> {
  RegisterForm(super.ref);

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
}

// @riverpod
// Future<RegisterForm> registerForm(Ref ref) async {
//   return RegisterForm(ref);
// }

final registerFormProvider = JetFormProvider<RegisterRequest, RegisterResponse>(
  (ref) => RegisterForm(ref),
);
