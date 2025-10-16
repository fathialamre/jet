import 'package:example/features/todo/forms/todo_form.dart';
import 'package:example/features/todo/models/todo_request.dart';
import 'package:example/features/todo/models/todo_response.dart';
import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/resources/state/jet_consumer.dart';

@RoutePage()
class TodoPage extends JetConsumerWidget {
  const TodoPage({super.key});

  @override
  Widget jetBuild(BuildContext context, WidgetRef ref, Jet jet) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: JetFormConsumer<TodoRequest, TodoResponse>(
            showDefaultSubmitButton: false,
            provider: todoFormProvider(1),
            builder:
                (
                  context,
                  ref,
                  form,
                  formState,
                ) {
                  return [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          JetTextField(
                            initialValue: 'Title',
                            name: 'title',
                            decoration: const InputDecoration(
                              labelText: 'Todo Title',
                              border: OutlineInputBorder(),
                            ),
                            validator: JetValidators.compose([
                              JetValidators.required(),
                              JetValidators.minLength(3),
                            ]),
                          ),
                          const SizedBox(height: 16),
                          JetTextField(
                            name: 'description',
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                            validator: JetValidators.compose([
                              JetValidators.required(),
                              JetValidators.minLength(10),
                            ]),
                          ),
                          const SizedBox(height: 16),
                          const SizedBox(height: 24),
                          JetFormChangeListener(
                            form: form,
                            builder: (context) {
                              return JetButton.filled(
                                text: 'Create Todo',
                                isEnabled: form.hasChanges,
                                onTap: () => form.submit(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ];
                },
          ),
        ),
      ),
    );
  }
}
