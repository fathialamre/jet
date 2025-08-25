import 'package:example/core/extensions/build_context.dart';
import 'package:example/features/auth/login/data/models/login_response.dart';
import 'package:example/features/auth/register/notifiers/verify_register_form_notifier.dart';
import 'package:example/features/auth/shared/data/models/verify_register_request.dart';
import 'package:flutter/material.dart';
import 'package:jet/extensions/text_extensions.dart';
import 'package:jet/helpers/jet_logger.dart';
import 'package:jet/jet_framework.dart';

@RoutePage()
class VerifyRegisterPage extends ConsumerWidget {
  const VerifyRegisterPage({super.key, required this.phone});

  final String phone;

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
            JetFormBuilder<VerifyRegisterRequest, LoginResponse>(
              initialValues: {
                'otp': '123456',
              },
              provider: verifyRegisterFormProvider,
              onSuccess: (response, request) {
                dump(response);
              },
              builder: (context, ref, form, formState) {
                return [];
              },
            ),
          ],
        ),
      ),
    );
  }
}
