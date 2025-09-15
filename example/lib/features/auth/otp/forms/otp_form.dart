import 'package:example/features/auth/otp/models/opt_request.dart';
import 'package:example/features/auth/otp/models/otp_response.dart';
import 'package:example/features/auth/register/forms/register_form.dart';
import 'package:jet/helpers/jet_logger.dart';
import 'package:jet/jet_framework.dart';

class OtpForm extends JetFormNotifier<OtpRequest, OtpResponse> {
  OtpForm(super.ref);

  @override
  bool get autoValidate => true;

  @override
  OtpRequest decoder(Map<String, dynamic> json) {
    return OtpRequest.fromJson(json);
  }

  @override
  Future<OtpResponse> action(OtpRequest data) async {
    final registerFormState = ref.read(registerFormProvider);
    dump(registerFormState.request?.phone, tag: 'OTP_VERIFICATION');
    await 2.sleep(); // Simulate network delay
    return OtpResponse(
      name: 'John Doe',
    );
  }

  @override
  List<String> validateField(String fieldName, dynamic value) {
    if (fieldName == 'otp') {
      if (value == null || value.toString().isEmpty) {
        return ['OTP is required'];
      }
      if (value.toString().length != 6) {
        return ['OTP must be 6 digits'];
      }
      if (!RegExp(r'^\d{6}$').hasMatch(value.toString())) {
        return ['OTP must contain only numbers'];
      }
    }
    return [];
  }

  /// Validate just the OTP field in real-time
  void validateOtpField() {
    validateSingleField('otp');
  }
}

final otpFormProvider = JetFormProvider<OtpRequest, OtpResponse>(
  (ref) => OtpForm(ref),
);
