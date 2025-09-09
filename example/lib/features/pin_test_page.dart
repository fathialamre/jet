import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';

/// Test page for JetPinField widget
@RoutePage()
class PinTestPage extends StatelessWidget {
  const PinTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('PIN Field Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Standard PIN Field',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              JetPinField(
                name: 'standard_pin',
                length: 6,
                helperText: 'Enter your 6-digit PIN',
                onChanged: (value) => print('PIN changed: $value'),
                onCompleted: (value) => print('PIN completed: $value'),
              ),
              const SizedBox(height: 32),
              const Text(
                'Obscured PIN Field',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              JetPinField(
                name: 'secure_pin',
                length: 4,
                obscureText: true,
                helperText: 'Enter your secure 4-digit PIN',
                onChanged: (value) => print('Secure PIN changed: $value'),
                onCompleted: (value) => print('Secure PIN completed: $value'),
              ),
              const SizedBox(height: 32),
              const Text(
                'Custom Styled PIN Field',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              JetPinField(
                name: 'custom_pin',
                length: 5,
                boxWidth: 60,
                boxHeight: 60,
                spacing: 12,
                borderRadius: BorderRadius.circular(8),
                focusedBorderColor: Colors.blue,
                filledBorderColor: Colors.green,
                defaultFillColor: Colors.grey[100],
                focusedFillColor: Colors.blue[50],
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                helperText: 'Custom styled 5-digit PIN',
                onChanged: (value) => print('Custom PIN changed: $value'),
                onCompleted: (value) => print('Custom PIN completed: $value'),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.saveAndValidate() ?? false) {
                      final values = formKey.currentState!.value;
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Form Values'),
                          content: Text(values.toString()),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
