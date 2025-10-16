import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/forms/forms.dart';

/// Request model for the form fields example
class FormFieldsRequest {
  final String email;
  final DateTime? birthdate;
  final String? country;
  final String? description;
  final bool terms;
  final bool newsletter;
  final bool notifications;

  FormFieldsRequest({
    required this.email,
    this.birthdate,
    this.country,
    this.description,
    required this.terms,
    required this.newsletter,
    required this.notifications,
  });

  factory FormFieldsRequest.fromJson(Map<String, dynamic> json) {
    return FormFieldsRequest(
      email: json['email'] as String,
      birthdate: json['birthdate'] as DateTime?,
      country: json['country'] as String?,
      description: json['description'] as String?,
      terms: json['terms'] as bool? ?? false,
      newsletter: json['newsletter'] as bool? ?? false,
      notifications: json['notifications'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'birthdate': birthdate?.toIso8601String(),
    'country': country,
    'description': description,
    'terms': terms,
    'newsletter': newsletter,
    'notifications': notifications,
  };
}

/// Response model for the form fields example
class FormFieldsResponse {
  final String message;
  final String id;

  FormFieldsResponse({
    required this.message,
    required this.id,
  });

  factory FormFieldsResponse.fromJson(Map<String, dynamic> json) {
    return FormFieldsResponse(
      message: json['message'] as String,
      id: json['id'] as String,
    );
  }
}

/// Example page demonstrating all the new Jet form fields
class FormFieldsExamplePage extends HookConsumerWidget {
  const FormFieldsExamplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use JetForm hook for form management
    final form = useJetForm<FormFieldsRequest, FormFieldsResponse>(
      ref: ref,
      decoder: (json) => FormFieldsRequest.fromJson(json),
      action: (request) async {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));
        return FormFieldsResponse(
          message: 'Form submitted successfully!',
          id: DateTime.now().millisecondsSinceEpoch.toString(),
        );
      },
      onSuccess: (response, request) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ ${response.message}'),
            backgroundColor: Colors.green,
          ),
        );
      },
      onError: (error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✗ Failed to submit form'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jet Form Fields Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => form.reset(),
            tooltip: 'Reset Form',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: JetSimpleForm(
          controller: form,
          submitButtonText: 'Submit Form',
          fieldSpacing: 24,
          children: [
            // Email Field Section
            const Text(
              'Email Field',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const JetEmailField(
              name: 'email',
              labelText: 'Email Address',
              hintText: 'Enter your email',
            ),

            // Date Field Section
            const Text(
              'Date Field',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            JetDateField(
              name: 'birthdate',
              labelText: 'Date of Birth',
              hintText: 'Select your birthdate',
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            ),

            // Dropdown Field Section
            const Text(
              'Dropdown Field',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            JetDropdownField<String>(
              name: 'country',
              labelText: 'Country',
              hintText: 'Select your country',
              items: const [
                DropdownMenuItem(value: 'us', child: Text('United States')),
                DropdownMenuItem(value: 'uk', child: Text('United Kingdom')),
                DropdownMenuItem(value: 'ca', child: Text('Canada')),
                DropdownMenuItem(value: 'au', child: Text('Australia')),
                DropdownMenuItem(value: 'de', child: Text('Germany')),
              ],
            ),

            // Textarea Field Section
            const Text(
              'Textarea Field',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const JetTextAreaField(
              name: 'description',
              labelText: 'Description',
              hintText: 'Enter a description',
              minLines: 3,
              maxLines: 6,
              maxLength: 500,
              showCharacterCounter: true,
            ),

            // Checkbox Field Section
            const Text(
              'Checkbox Field',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const JetCheckboxField(
              name: 'terms',
              title: 'I agree to the terms and conditions',
              isRequired: true,
            ),
            const JetCheckboxField(
              name: 'newsletter',
              title: 'Subscribe to newsletter',
              subtitle: 'Receive weekly updates and promotions',
              isRequired: false,
            ),

            // Switch Field Section
            const Text(
              'Switch Field',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const JetCheckboxField(
              name: 'notifications',
              title: 'Enable notifications',
              subtitle: 'Receive push notifications',
              useSwitch: true,
              isRequired: false,
            ),

            // Show success message if form was submitted
            if (form.hasValue) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.green.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        PhosphorIcons.checkCircle(),
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              form.response!.message,
                              style: TextStyle(
                                color: Colors.green.shade900,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Request ID: ${form.response!.id}',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontSize: 12,
                              ),
                            ),
                          ],
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
}
