import 'package:example/features/todo/forms/todo_form.dart';
import 'package:example/features/todo/models/todo_request.dart';
import 'package:example/features/todo/models/todo_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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
        child: JetFormBuilder<TodoRequest, TodoResponse>(
          provider: todoFormProvider,
          builder: (context, ref, form, formState) {
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
                      FormBuilderTextField(
                        name: 'title',
                        decoration: const InputDecoration(
                          labelText: 'Todo Title',
                          border: OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(3),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      FormBuilderTextField(
                        name: 'description',
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(10),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      FormBuilderCheckbox(
                        name: 'isCompleted',
                        title: const Text('Mark as completed'),
                        initialValue: false,
                      ),
                      const SizedBox(height: 24),
                      JetButton.filled(
                        text: 'Create Todo',
                        onTap: () => form.submit(context: context),
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onErrorContainer,
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
