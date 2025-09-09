import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';

@RoutePage()
class InputsExamplePage extends StatelessWidget {
  const InputsExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Inputs Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter PIN',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              JetPinField(
                name: 'pin',
                length: 6,
                helperText: 'Enter your 6-digit PIN',
                onCompleted: (value) => print('PIN completed: $value'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState?.saveAndValidate() ?? false) {
                    final values = formKey.currentState!.value;
                    final pin = values['pin'] as String?;

                    // Show result dialog
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('PIN Submitted'),
                        content: Text('PIN entered: ${pin ?? "None"}'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Show validation error
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please complete the PIN field'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Submit PIN',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
