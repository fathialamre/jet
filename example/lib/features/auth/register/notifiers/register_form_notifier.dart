import 'package:example/features/auth/shared/data/models/register_request.dart';
import 'package:example/features/auth/shared/data/models/register_response.dart';
import 'package:example/features/auth/shared/data/services/auth_service.dart';
import 'package:jet/helpers/jet_logger.dart';
import 'package:jet/jet_framework.dart';

class RegisterFormNotifier
    extends JetFormNotifier<RegisterRequest, RegisterResponse> {
  RegisterFormNotifier(super.ref);

  @override
  RegisterRequest decoder(Map<String, dynamic> json) {
    return RegisterRequest.fromJson(json);
  }

  @override
  Future<RegisterResponse> action(RegisterRequest data) async {
    final response = await ref.read(authServiceProvider).register(data);
    dump(response);
    return response.data;
  }
}

// Provider for the login form
final registerFormProvider = JetFormProvider<RegisterRequest, RegisterResponse>(
  (ref) => RegisterFormNotifier(ref),
);
