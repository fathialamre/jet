import 'package:example/core/extensions/build_context.dart';
import 'package:example/core/router/app_router.gr.dart';
import 'package:example/features/auth/register/notifiers/register_form_notifier.dart';
import 'package:example/features/auth/shared/data/models/register_request.dart';
import 'package:example/features/auth/shared/data/models/register_response.dart';
import 'package:flutter/material.dart';
import 'package:jet/extensions/text_extensions.dart';
import 'package:jet/jet_framework.dart';

@RoutePage()
class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

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
            JetFormBuilder<RegisterRequest, RegisterResponse>(
              initialValues: {
                'phone': '01099999999',
                'name': 'Fathi',
                'password': '12345678',
                'password_confirmation': '12345678',
              },
              useDefaultErrorHandler: false,
              provider: registerFormProvider,
              onSuccess: (response, request) {
                context.router.push(VerifyRegisterRoute(phone: response.phone));
              },
              // showDefaultSubmitButton: false,
              builder: (context, ref, form, formState) {
                return [
                  FormBuilderPhoneNumberField(
                    name: 'phone',
                    hintText: context.localizations.enterPhoneNumber,
                    isRequired: true,
                  ),
                  FormBuilderTextField(
                    name: 'name',
                    decoration: InputDecoration(
                      hintText: context.localizations.enterName,
                      labelText: context.localizations.enterName,
                      prefixIcon: Icon(LucideIcons.user),
                    ),
                  ),
                  // Password field using FormBuilderPasswordField
                  FormBuilderPasswordField(
                    name: 'password',
                    hintText: context.localizations.enterPassword,
                    isRequired: true,
                  ),
                  FormBuilderPasswordField(
                    name: 'password_confirmation',
                    hintText: context.localizations.enterPassword,
                    isRequired: true,
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
