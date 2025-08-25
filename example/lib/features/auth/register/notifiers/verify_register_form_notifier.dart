import 'package:example/features/auth/login/data/models/login_response.dart';
import 'package:example/features/auth/shared/data/models/verify_register_request.dart';
import 'package:example/features/auth/shared/data/services/auth_service.dart';
import 'package:jet/helpers/jet_logger.dart';
import 'package:jet/jet_framework.dart';

class VerifyRegisterFormNotifier
    extends JetFormNotifier<VerifyRegisterRequest, LoginResponse> {
  VerifyRegisterFormNotifier(super.ref);

  @override
  VerifyRegisterRequest decoder(Map<String, dynamic> json) {
    return VerifyRegisterRequest.fromJson(json);
  }

  @override
  Future<LoginResponse> action(VerifyRegisterRequest data) async {
    final response = await ref.read(authServiceProvider).verifyRegister(data);
    dump(response);
    return response.data;
  }
}

// Provider for the login form
final verifyRegisterFormProvider =
    JetFormProvider<VerifyRegisterRequest, LoginResponse>(
      (ref) => VerifyRegisterFormNotifier(ref),
    );
