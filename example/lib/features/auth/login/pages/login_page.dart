import 'package:example/core/extensions/build_context.dart';
import 'package:flutter/material.dart';
import 'package:jet/extensions/text_extensions.dart';
import 'package:jet/jet_framework.dart';
import '../notifiers/login_form_notifier.dart';
import '../data/models/login_request.dart';
import '../data/models/login_response.dart';

@RoutePage()
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ThemeSwitcher.toggleButton(context),
          LanguageSwitcher.toggleButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.localizations.welcome,
              textAlign: TextAlign.center,
            ).headlineLarge(context).bold(),

            Text(
              context.localizations.loginToContinue,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 48),

            // Login form using JetFormBuilder
            JetFormBuilder<LoginRequest, LoginResponse>(
              initialValues: {
                'phone': '0913335396',
                'password': '12345678',
                'otp': '123456',
              },
              provider: loginFormProvider,
              onSuccess: (response, request) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Login successful! Token: ${response.token.substring(0, 10)}...',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              builder: (context, ref, form, formState) {
                return [
                  FormBuilderPhoneNumberField(
                    name: 'phone',
                    hintText: context.localizations.enterPhoneNumber,
                    isRequired: true,
                  ),
                  // Password field using FormBuilderPasswordField
                  FormBuilderPasswordField(
                    name: 'password',
                    hintText: context.localizations.enterPassword,
                    isRequired: true,
                    formKey: form.formKey,
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }
}
