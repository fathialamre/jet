import 'package:example/features/todo/models/todo_request.dart';
import 'package:example/features/todo/models/todo_response.dart';
import 'package:flutter/material.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/forms/forms.dart';
import 'package:jet/helpers/jet_logger.dart';
import 'package:jet/jet_framework.dart';

/// Example page demonstrating the useJetForm hook for simple form handling.
///
/// This example shows how to use the useJetForm hook without creating
/// a separate form notifier class. This is ideal for simple forms and
/// rapid prototyping.
///
/// Compare this with [TodoPage] which uses the traditional JetFormBuilder
/// approach with a separate JetFormNotifier class.
@RoutePage()
class SimpleTodoPage extends HookConsumerWidget {
  const SimpleTodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the useJetForm hook to create a form controller inline
    // without needing a separate notifier class
    final form = useJetForm<TodoRequest, TodoResponse>(
      ref: ref,
      decoder: (json) => TodoRequest.fromJson(json),
      action: (request) async {
        dump('Creating todo with hook: $request');

        // Simulate API call
        await 2.sleep();

        // Return mock response
        return TodoResponse(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: request.title,
          description: request.description,
          isCompleted: request.isCompleted,
          createdAt: DateTime.now(),
        );
      },
      onSuccess: (response, request) {
        // Show success message
        context.showToast('Todo created successfully!');
        dump('Todo created: $response');
      },
      onError: (error, stackTrace) {
        // Handle error
        dump('Error creating todo: $error');
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Todo (with useJetForm Hook)'),
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
                          Icons.info_outline,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Using useJetForm Hook',
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
                      'This form uses the useJetForm hook for simplified form handling. '
                      'No separate notifier class needed!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Form card
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

                    // Use JetSimpleForm with the controller from the hook
                    JetSimpleForm<TodoRequest, TodoResponse>(
                      form: form,
                      submitButtonText: 'Create Todo',
                      fieldSpacing: 16,
                      children: [
                        JetTextField(
                          name: 'title',
                          decoration: const InputDecoration(
                            labelText: 'Todo Title',
                            border: OutlineInputBorder(),
                            hintText: 'Enter a title for your todo',
                          ),
                          validator: JetValidators.compose([
                            JetValidators.required(),
                            JetValidators.minLength(3),
                          ]),
                        ),
                        JetTextField(
                          name: 'description',
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                            hintText: 'Describe your todo',
                          ),
                          maxLines: 3,
                          validator: JetValidators.compose([
                            JetValidators.required(),
                            JetValidators.minLength(10),
                          ]),
                        ),
                        JetCheckbox(
                          name: 'isCompleted',
                          title: const Text('Mark as completed'),
                          initialValue: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Show success state
            if (form.hasValue) ...[
              const SizedBox(height: 16),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '✓ Todo Created Successfully!',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        label: 'ID',
                        value: form.response!.id,
                        context: context,
                      ),
                      _InfoRow(
                        label: 'Title',
                        value: form.response!.title,
                        context: context,
                      ),
                      _InfoRow(
                        label: 'Description',
                        value: form.response!.description,
                        context: context,
                      ),
                      _InfoRow(
                        label: 'Status',
                        value: form.response!.isCompleted
                            ? 'Completed'
                            : 'Pending',
                        context: context,
                      ),
                      _InfoRow(
                        label: 'Created',
                        value: form.response!.createdAt.toString().substring(
                          0,
                          19,
                        ),
                        context: context,
                      ),
                      const SizedBox(height: 12),
                      JetButton.outlined(
                        text: 'Create Another',
                        onTap: form.reset,
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Show error state
            if (form.hasError) ...[
              const SizedBox(height: 16),
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Error',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onErrorContainer,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        form.error.toString(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final BuildContext context;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.context,
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
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
