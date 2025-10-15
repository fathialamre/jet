import 'package:example/features/login/models/login_request.dart';
import 'package:example/features/login/models/login_response.dart';
import 'package:flutter/material.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/forms/forms.dart';
import 'package:jet/helpers/jet_logger.dart';
import 'package:jet/jet_framework.dart';

/// Example login page demonstrating the useJetForm hook.
///
/// This example shows how to use the useJetForm hook for a login form
/// without creating a separate form notifier class. Perfect for simple
/// forms with straightforward logic.
@RoutePage()
class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the useJetForm hook to create a form controller inline
    final form = useJetForm<LoginRequest, LoginResponse>(
      ref: ref,
      decoder: (json) => LoginRequest.fromJson(json),
      action: (request) async {
        dump('Login attempt: ${request.email}');

        // Simulate API call
        await 2.sleep();

        // Simulate validation error for specific email
        if (request.email == 'error@test.com') {
          throw JetError.validation(
            message: 'Invalid credentials',
            errors: {
              'email': ['This email is not registered'],
              'password': ['Please check your password'],
            },
          );
        }

        // Simulate server error
        if (request.email == 'server@test.com') {
          throw JetError.server(
            message: 'Server error occurred',
            statusCode: 500,
          );
        }

        // Return mock successful response
        return LoginResponse(
          token: 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
          userId: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'John Doe',
          email: request.email,
          loginAt: DateTime.now(),
        );
      },
      onSuccess: (response, request) {
        // Show success message
        context.showToast('Welcome back, ${response.name}!');
        dump('Login successful: $response');

        // In a real app, you would:
        // - Save the token to secure storage
        // - Update auth state
        // - Navigate to dashboard
        // Example:
        // await JetStorage.writeSecure('auth_token', response.token);
        // context.router.pushNamed('/dashboard');
      },
      onError: (error, stackTrace) {
        // Handle error - error is already shown by JetSimpleForm
        dump('Login error: $error');
      },
      onValidationError: (error, stackTrace) {
        // Handle validation error
        dump('Validation error: $error');
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login with useJetForm'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Information card
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Demo Login Form',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This form uses the useJetForm hook. Try these test emails:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTestCase(
                      context,
                      '• test@example.com - Success',
                      Icons.check_circle_outline,
                    ),
                    _buildTestCase(
                      context,
                      '• error@test.com - Validation Error',
                      Icons.error_outline,
                    ),
                    _buildTestCase(
                      context,
                      '• server@test.com - Server Error',
                      Icons.cloud_off_outlined,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Login form card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.login,
                          color: Theme.of(context).colorScheme.primary,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Sign In',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Use JetSimpleForm with the controller from the hook
                    JetSimpleForm<LoginRequest, LoginResponse>(
                      controller: form,
                      submitButtonText: 'Sign In',
                      fieldSpacing: 16,
                      expandSubmitButton: true,
                      showSubmitButton: false,
                      children: [
                        JetEmailField(
                          name: 'email',
                          validator: JetValidators.compose([
                            JetValidators.required(),
                            JetValidators.email(),
                          ]),
                        ),
                        JetPasswordField(
                          name: 'password',
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          isRequired: true,
                          formKey: form.formKey,
                          validator: JetValidators.compose([
                            JetValidators.required(),
                            JetValidators.minLength(6),
                          ]),
                        ),
                        FormBuilderCheckbox(
                          name: 'rememberMe',
                          title: Row(
                            children: [
                              Text(
                                'Remember me',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          initialValue: false,
                        ),
                        JetButton(
                          text: 'Sign In',
                          onTap: form.submit,
                        ),
                      ],
                    ),

                    // Forgot password link
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          context.showToast('Forgot password clicked');
                        },
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Show success state
            if (form.hasValue) ...[
              const SizedBox(height: 16),
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
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Login Successful!',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        label: 'User ID',
                        value: form.response!.userId,
                        color: Colors.green.shade700,
                      ),
                      _InfoRow(
                        label: 'Name',
                        value: form.response!.name,
                        color: Colors.green.shade700,
                      ),
                      _InfoRow(
                        label: 'Email',
                        value: form.response!.email,
                        color: Colors.green.shade700,
                      ),
                      _InfoRow(
                        label: 'Token',
                        value: '${form.response!.token.substring(0, 20)}...',
                        color: Colors.green.shade700,
                      ),
                      _InfoRow(
                        label: 'Login Time',
                        value: form.response!.loginAt.toString().substring(
                          0,
                          19,
                        ),
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: JetButton.outlined(
                              text: 'Try Again',
                              onTap: form.reset,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: JetButton.filled(
                              text: 'Dashboard',
                              onTap: () {
                                context.showToast('Navigate to dashboard');
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Show loading state info
            if (form.isLoading) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Authenticating...',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTestCase(BuildContext context, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
