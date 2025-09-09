import 'package:example/features/auth/otp/models/opt_request.dart';
import 'package:example/features/auth/otp/models/otp_response.dart';
import 'package:example/features/auth/register/forms/register_form.dart';
import 'package:jet/helpers/jet_logger.dart';
import 'package:jet/jet_framework.dart';

class OtpForm extends JetFormNotifier<OtpRequest, OtpResponse> {
  OtpForm(super.ref);

  @override
  OtpRequest decoder(Map<String, dynamic> json) {
    return OtpRequest.fromJson(json);
  }

  @override
  Future<OtpResponse> action(OtpRequest data) async {
   final registerFormState = ref.read(registerFormProvider);
   dump(registerFormState.request?.phone, tag: 'ABC');
    await 1.sleep();
    return OtpResponse(
      name: 'John Doe',
    );
  }
}

final otpFormProvider = JetFormProvider<OtpRequest, OtpResponse>(
  (ref) => OtpForm(ref),
);
