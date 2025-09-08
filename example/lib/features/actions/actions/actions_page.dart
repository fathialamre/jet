import 'package:example/features/actions/actions/jet_action.dart';
import 'package:example/features/actions/data/models/comment_request.dart';
import 'package:example/features/actions/data/models/comment_response.dart';
import 'package:example/features/actions/notifiers/comment_form_notifier.dart';
import 'package:flutter/material.dart';
import 'package:jet/extensions/text_extensions.dart';
import 'package:jet/jet_framework.dart';

@RoutePage()
class ActionsPage extends ConsumerWidget {
  const ActionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jet Actions'),
        actions: [
          ThemeSwitcher.toggleButton(context),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Basic Actions
            _buildSection(
              context,
              title: '1. Basic Actions & Confirmations',
              description:
                  'Simple actions and different confirmation sheet types',
              children: [
                JetAction.action(
                  text: 'Simple Action',
                  icon: Icons.star,
                  onTap: () async {
                    await 2.sleep();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Simple action executed!')),
                    );
                  },
                ),
                const SizedBox(height: 12),
                JetAction.confirmation(
                  text: 'Delete Item',
                  icon: Icons.delete,
                  buttonType: JetButtonType.outlined,
                  confirmationType: ConfirmationSheetType.normal,
                  confirmationTitle: 'Delete Item',
                  confirmationMessage:
                      'Are you sure you want to delete this item? This action cannot be undone.',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Item deleted successfully!'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                JetAction.confirmation(
                  text: 'Warning Action',
                  icon: Icons.warning,
                  buttonType: JetButtonType.outlined,
                  confirmationType: ConfirmationSheetType.warning,
                  confirmationTitle: 'Proceed with caution',
                  confirmationMessage:
                      'This action may have unintended consequences. Please review before proceeding.',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Warning action completed!'),
                        backgroundColor: Colors.amber,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                JetAction.confirmation(
                  text: 'Success Action',
                  icon: Icons.check,
                  buttonType: JetButtonType.filled,
                  confirmationType: ConfirmationSheetType.success,
                  confirmationTitle: 'Complete Task',
                  confirmationMessage:
                      'Mark this task as completed? You can undo this action later.',
                  onTap: () async {
                    await 5.sleep();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Task completed successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Section 2: Legacy Form Actions
            _buildSection(
              context,
              title: '2. Legacy Form Actions',
              description:
                  'Using the original formBuilder pattern for backward compatibility',
              children: [
                JetAction.form(
                  text: 'Legacy Form',
                  icon: Icons.edit,
                  buttonType: JetButtonType.filled,
                  formTitle: 'Edit Profile',
                  formBuilder: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          hintText: 'Enter your name',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile updated!')),
                          );
                        },
                        child: const Text('Update Profile'),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Section 3: Optimized Form Actions
            _buildSection(
              context,
              title: '3. Form Actions',
              description:
                  'Using the new JetFormBuilder integration with full state management',
              children: [
                JetAction<CommentRequest, CommentResponse>.jetForm(
                  text: 'Add Comment',
                  icon: Icons.comment,
                  buttonType: JetButtonType.filled,
                  formProvider: commentFormProvider,
                  formTitle: 'Create New Comment',
                  initialFormValues: const {
                    'priority': 'medium',
                  },
                  jetFormBuilder: (context, ref, form, state) => [
                    FormBuilderTextField(
                      name: 'title',
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'Enter comment title',
                        prefixIcon: Icon(Icons.title),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(3),
                        FormBuilderValidators.maxLength(100),
                      ]),
                    ),
                  ],
                  onFormSuccess: (response, request) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Comment "${response.title}" created successfully!',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  onFormError: (error, stackTrace, invalidateFields) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $error'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                JetAction<CommentRequest, CommentResponse>.jetForm(
                  text: 'Quick Comment',
                  icon: Icons.flash_on,
                  buttonType: JetButtonType.outlined,
                  formProvider: commentFormProvider,
                  formTitle: 'Quick Comment',
                  formSubmitButtonText: 'Post Comment',
                  initialFormValues: const {
                    'priority': 'high',
                    'title': 'Quick Comment',
                  },
                  jetFormBuilder: (context, ref, form, state) => [
                    // Show loading state indicator
                    if (state.isLoading) const LinearProgressIndicator(),
                    FormBuilderTextField(
                      name: 'description',
                      decoration: const InputDecoration(
                        labelText: 'Your thoughts',
                        hintText: 'What would you like to say?',
                        prefixIcon: Icon(Icons.chat_bubble),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(5),
                      ]),
                    ),
                  ],
                  onFormSuccess: (response, request) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Quick comment posted!'),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Section 4: Advanced Features
            _buildSection(
              context,
              title: '4. Advanced Features',
              description: 'Demonstrating advanced capabilities',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: JetAction.action(
                        text: 'Expanded Action',
                        icon: Icons.expand,
                        buttonType: JetButtonType.text,
                        isExpanded: true,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Expanded action!')),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                JetAction.action(
                  text: 'Disabled Action',
                  icon: Icons.block,
                  buttonType: JetButtonType.elevated,
                  isEnabled: false,
                  onTap: () {
                    // This won't be called
                  },
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Benefits summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text(
                          'Benefits of Optimized JetAction',
                        ).titleMedium(context).bold(),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• Clear, explicit named constructors for different use cases',
                    ),
                    const Text(
                      '• Dynamic bottom sheet height based on content',
                    ),
                    const Text(
                      '• Styled confirmation sheets (info, warning, error, success)',
                    ),
                    const Text(
                      '• Type-safe form handling with Request/Response models',
                    ),
                    const Text('• Automatic loading states and error handling'),
                    const Text(
                      '• Built-in form validation and field invalidation',
                    ),
                    const Text('• Improved UX with draggable scroll sheets'),
                    const Text(
                      '• Proper keyboard handling and responsive design',
                    ),
                    const Text(
                      '• Success and error callbacks for custom handling',
                    ),
                    const Text(
                      '• Backward compatibility through JetAction.form constructor',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String description,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title).titleLarge(context).bold(),
        const SizedBox(height: 4),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}
