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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: JetFormConsumer<TodoRequest, TodoResponse>(
          provider: todoFormProvider(1),
          builder:
              (
                context,
                ref,
                notifier,
                formState,
              ) {
                return [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Todo',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          JetTextField(
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
                          JetCheckbox(
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              prefixIcon: Icon(Icons.lock),
                            ),
                            name: 'isCompleted',
                            title: const Text('Mark as complete ->>'),
                            initialValue: false,
                          ),
                          const SizedBox(height: 24),
                          JetButton.filled(
                            text: 'Create Todo',
                            onTap: notifier.submit,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (formState.hasValue) ...[
                    const SizedBox(height: 16),
                    Card(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Todo Created Successfully!',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'ID: ${formState.response!.id}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              'Title: ${formState.response!.title}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              'Created: ${formState.response!.createdAt.toString().substring(0, 19)}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (formState.hasError) ...[
                    const SizedBox(height: 16),
                    Card(
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Error: ${(formState as AsyncFormError).error}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onErrorContainer,
                              ),
                        ),
                      ),
                    ),
                  ],
                ];
              },
        ),
      ),
    );
  }
}
