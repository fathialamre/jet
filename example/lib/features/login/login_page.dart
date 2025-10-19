import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';
import 'login_form.dart';
import 'models/login_request.dart';
import 'models/login_response.dart';

@RoutePage()
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Login Form
            JetFormConsumer<LoginRequest, LoginResponse>(
              provider: loginFormProvider,
              builder: (context, ref, form, formState) => [
                // Email Field
                JetTextField(
                  name: 'email',

                  keyboardType: TextInputType.emailAddress,
                  validator: JetValidators.compose([
                    JetValidators.required(),
                    JetValidators.email(),
                  ]),
                ),

                const SizedBox(height: 16),

                // Password Field
                JetPasswordField(
                  name: 'password',

                  validator: JetValidators.compose([
                    JetValidators.required(),
                    JetValidators.minLength(6),
                  ]),
                ),
                JetFormChangeListener(
                  form: form,
                  builder: (context) => JetButton.filled(
                    isEnabled: form.hasChanges ,
                    text: 'Login',
                    onTap: () => form.submit(),
                  ),
                  listenToFields: ['email', 'password'],
                ),
              ],
              onSuccess: (response, request) {
                // Navigate back or to home
                Navigator.of(context).pop();
              },
              onError: (error, stackTrace, invalidateFields) {
                // Show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Login failed: $error'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
