import 'package:flutter/material.dart';
import 'package:jet/extensions/build_context.dart';
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
                validator: JetValidators.minLength(
                  8,
                  errorText: 'Password must be at least 8 characters',
                ),
                isRequired: true, // Default is true, shown here for clarity
                spacing: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
