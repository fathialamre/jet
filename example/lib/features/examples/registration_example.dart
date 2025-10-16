import 'package:flutter/material.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/forms/forms.dart';
import 'package:jet/helpers/jet_logger.dart';
import 'package:jet/jet_framework.dart';

/// Registration form example demonstrating JetPasswordField.withConfirmation()
///
/// This example shows how to use the new password confirmation feature
/// with automatic matching validation.
@RoutePage()
class RegistrationExamplePage extends HookConsumerWidget {
  const RegistrationExamplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Create a form key for password matching validation
    final formKey = useMemoized(() => GlobalKey<JetFormState>());

    // Use the useJetForm hook to create a form controller
    final form = useJetForm<Map<String, dynamic>, Map<String, dynamic>>(
      ref: ref,
      decoder: (json) => json,
      action: (request) async {
        dump('Registration form submission: $request');

        // Simulate API call
        await 2.sleep();

        // Return mock successful response
        return {
          'userId': DateTime.now().millisecondsSinceEpoch.toString(),
          'message': 'Registration successful!',
          'email': request['email'],
        };
      },
      onSuccess: (response, request) {
        context.showToast('Registration successful!');
        dump('Success: $response');
      },
      onError: (error, stackTrace) {
        dump('Error: $error');
        context.showToast('Registration failed');
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: JetForm(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'Create Account',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Fill in the form below to create your account',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),

              // Name field
              JetTextField(
                name: 'name',
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: JetValidators.compose([
                  JetValidators.required(),
                  JetValidators.minLength(3),
                ]),
              ),
              const SizedBox(height: 16),

              // Email field
              JetTextField(
                name: 'email',
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: JetValidators.compose([
                  JetValidators.required(),
                  JetValidators.email(),
                ]),
              ),
              const SizedBox(height: 24),

              // Password confirmation using withConfirmation()
              JetPasswordField.withConfirmation(
                name: 'password',
                formKey: formKey,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock),
                  helperText: 'Must be at least 8 characters',
                ),
                confirmationDecoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: JetValidators.compose([
                  JetValidators.required(),
                  JetValidators.minLength(
                    8,
                    errorText: 'Password must be at least 8 characters',
                  ),
                ]),
                spacing: 16,
              ),
              const SizedBox(height: 24),

              // Terms checkbox
              JetCheckbox(
                name: 'terms',
                title: const Text('I agree to the Terms and Conditions'),
                subtitle: const Text('You must accept to continue'),
                validator: JetValidators.equal(
                  true,
                  errorText: 'You must accept the terms',
                ),
              ),
              const SizedBox(height: 32),

              // Submit button
              if (form.isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    // Validate and submit the form
                    if (formKey.currentState?.validate() ?? false) {
                      formKey.currentState?.save();
                      form.submit();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 16),
                  ),
                ),

              // Success message
              if (form.hasValue) ...[
                const SizedBox(height: 24),
                Card(
                  color: Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green.shade700,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Success!',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          form.response?['message'] ??
                              'Registration successful!',
                          style: TextStyle(color: Colors.green.shade700),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              // Info box
              const SizedBox(height: 24),
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Password Confirmation',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This form uses JetPasswordField.withConfirmation() which automatically creates both password fields with matching validation.',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• First field validates password strength\n'
                        '• Second field validates both strength and matching\n'
                        '• Auto-generates field name: password_confirmation',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
