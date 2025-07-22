import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/localization/notifiers/language_switcher_notifier.dart';
import '../notifiers/login_form_notifier.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = JetLocalizations.of(context);
    final currentLocale = ref.watch(languageSwitcherProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appName),
        actions: [
          ThemeSwitcher.toggleButton(context),
          LanguageSwitcher.toggleButton(),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome text
            Text(
              'Welcome ${currentLocale.languageCode}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'Current locale: ${currentLocale.languageCode}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 48),

            // Login form using JetFormBuilder
            JetFormBuilder<LoginRequest, LoginResponse>(
              initialValues: {
                'phone': '0913335396',
                'password': '12345678',
              },
              provider: loginFormProvider,
              onSuccess: (response, request) {
                // Handle successful login
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Login successful! Token: ${response.token.substring(0, 10)}...',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              submitButtonText: 'Login now',
              builder: (context, ref, form, formState) {
                return [
                  FormBuilderPhoneNumberField(
                    name: 'phone',
                    hintText: 'Enter your phone number',
                    isRequired: true,
                  ),
                  // Password field using FormBuilderPasswordField
                  FormBuilderPasswordField(
                    name: 'password',
                    hintText: 'Enter your password',
                    isRequired: true,
                    formKey: form.formKey,
                  ),

                  const SizedBox(height: 16),
                  // Custom OTP field built from scratch
                  Text(
                    'OTP Verification (Custom Field)',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  JetOtpField(
                    name: 'otp',
                    length: 6,
                    fieldWidth: 40,
                    onCompleted: (otp) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('OTP completed: $otp'),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the OTP';
                      }
                      if (value.length < 6) {
                        return 'Please enter all 6 digits';
                      }
                      return null;
                    },
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
