import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';

/// Example page demonstrating all the new Jet form fields
class FormFieldsExamplePage extends HookConsumerWidget {
  const FormFieldsExamplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jet Form Fields Example'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              const SizedBox(height: 24),
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
              const SizedBox(height: 24),
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
              const SizedBox(height: 24),
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
              const SizedBox(height: 24),
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
              const SizedBox(height: 16),
              const JetCheckboxField(
                name: 'newsletter',
                title: 'Subscribe to newsletter',
                subtitle: 'Receive weekly updates and promotions',
                isRequired: false,
              ),
              const SizedBox(height: 24),
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
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState?.saveAndValidate() ?? false) {
                    final values = formKey.currentState?.value;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Form is valid: $values'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fix the errors in the form'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  formKey.currentState?.reset();
                },
                child: const Text('Reset Form'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
