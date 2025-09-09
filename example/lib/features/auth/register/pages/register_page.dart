import 'package:example/core/router/app_router.gr.dart';
import 'package:example/features/auth/register/forms/register_form.dart';
import 'package:example/features/auth/register/models/register_request.dart';
import 'package:example/features/auth/register/models/register_response.dart';
import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';

@RoutePage()
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: JetFormBuilder<RegisterRequest, RegisterResponse>(
        initialValues: {'phone': '0914444444'},
        provider: registerFormProvider,
        builder: (context, ref, form, state) => [
          FormBuilderTextField(name: 'phone'),
        ],  
        onSuccess: (response, request) {
          context.router.push(OtpRoute(phone: request.phone));
        },
      ),
    );
  }
}