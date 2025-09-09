import 'package:example/features/auth/otp/forms/otp_form.dart';
import 'package:example/features/auth/otp/models/opt_request.dart';
import 'package:example/features/auth/otp/models/otp_response.dart';
import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';

@RoutePage()
class OtpPage extends StatelessWidget {
  final String phone;
  const OtpPage({super.key, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP'),
      ),
      body: JetFormBuilder<OtpRequest, OtpResponse>(
        initialValues: {
          'phone': phone,
          'otp': '2000',
        },
        provider: otpFormProvider,
        builder: (context, ref, form, state) => [
          JetPinField(
            name: 'otp',
            initialValue: '123456',
          ),
        ],
      ),
    );
  }
}
