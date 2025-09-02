import 'package:example/features/auth/login/data/models/login_request.dart';
import 'package:example/features/auth/login/data/models/login_response.dart';
import 'package:example/features/auth/shared/data/services/auth_service.dart';
import 'package:jet/helpers/jet_logger.dart';
import 'package:jet/jet_framework.dart';

class LoginFormNotifier extends JetFormNotifier<LoginRequest, LoginResponse> {
  LoginFormNotifier(super.ref);

  @override
  LoginRequest decoder(Map<String, dynamic> json) {
    return LoginRequest.fromJson(json);
  }

  @override
  Future<LoginResponse> action(LoginRequest data) async {
    await Future.delayed(const Duration(seconds: 1));
    // dump(data);
    // final response = await ref.read(authServiceProvider).login(data);
    // return response;
    return LoginResponse(token: 'afkhasduehugfagfyegfiue');
  }
}

// Provider for the login form
final loginFormProvider = JetFormProvider<LoginRequest, LoginResponse>(
  (ref) => LoginFormNotifier(ref),
);
