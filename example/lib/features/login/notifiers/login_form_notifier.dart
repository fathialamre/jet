import 'package:example/features/login/data/services/login_service.dart';
import 'package:jet/jet_framework.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class LoginFormNotifier extends JetFormNotifier<LoginRequest, LoginResponse> {
  LoginFormNotifier(super.ref);

  @override
  LoginRequest decoder(Map<String, dynamic> json) {
    return LoginRequest.fromJson(json);
  }

  @override
  Future<LoginResponse> action(LoginRequest data) async {
    final response = await ref.read(loginServiceProvider).login(data);
    return response;
  }
}

// Provider for the login form
final loginFormProvider = JetFormProvider<LoginRequest, LoginResponse>(
  (ref) => LoginFormNotifier(ref),
);
