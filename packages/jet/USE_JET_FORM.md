# useJetForm Hook Documentation

## Overview

The `useJetForm` hook provides a simplified way to handle forms in the Jet framework without requiring separate notifier class files. It's perfect for simple forms, rapid prototyping, and cases where full `JetFormNotifier` setup feels like overkill.

## Key Features

- ✅ **Simplified Setup**: No need to create separate notifier classes
- ✅ **Type Safe**: Maintains full type safety with generic Request/Response types
- ✅ **Integrated Error Handling**: Automatic validation and error display
- ✅ **Lifecycle Callbacks**: onSuccess, onError, and onValidationError hooks
- ✅ **Form State Management**: Access to loading, error, and success states
- ✅ **Full Feature Parity**: Uses the same underlying infrastructure as JetFormBuilder

## When to Use

### Use `useJetForm` when:
- Building simple forms with straightforward logic
- Prototyping or experimenting with forms quickly
- Form logic is specific to a single page/widget
- You don't need to share form state across multiple components

### Use `JetFormNotifier` + `JetFormBuilder` when:
- Building complex forms with business logic
- Need to reuse form logic across multiple pages
- Require extensive custom validation
- Want to test form logic in isolation
- Need to share form state across component tree

## Basic Usage

### 1. Import Required Packages

```dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/forms/forms.dart';
```

### 2. Create a HookConsumerWidget

```dart
class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hook usage goes here
  }
}
```

### 3. Use the Hook

```dart
final form = useJetForm<LoginRequest, LoginResponse>(
  ref: ref,
  decoder: (json) => LoginRequest.fromJson(json),
  action: (request) async {
    return await apiService.login(request);
  },
  onSuccess: (response, request) {
    context.showToast('Login successful!');
    Navigator.pushReplacement(context, HomePage.route());
  },
  onError: (error, stackTrace) {
    print('Login error: $error');
  },
);
```

### 4. Build Your Form UI

```dart
return JetSimpleForm(
  controller: form,
  submitButtonText: 'Login',
  children: [
    FormBuilderTextField(
      name: 'email',
      decoration: InputDecoration(labelText: 'Email'),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.email(),
      ]),
    ),
    JetPasswordField(
      name: 'password',
      hintText: 'Password',
    ),
  ],
);
```

## API Reference

### useJetForm Hook

```dart
JetFormController<Request, Response> useJetForm<Request, Response>({
  required WidgetRef ref,
  required Request Function(Map<String, dynamic> json) decoder,
  required Future<Response> Function(Request data) action,
  Map<String, dynamic> initialValues = const {},
  void Function(Response response, Request request)? onSuccess,
  void Function(Object error, StackTrace stackTrace)? onError,
  void Function(Object error, StackTrace stackTrace)? onValidationError,
})
```

#### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `ref` | `WidgetRef` | Yes | Widget ref from HookConsumerWidget |
| `decoder` | `Function` | Yes | Converts form Map to Request object |
| `action` | `Function` | Yes | Async function that processes the request |
| `initialValues` | `Map` | No | Initial form field values |
| `onSuccess` | `Function` | No | Called when submission succeeds |
| `onError` | `Function` | No | Called when submission fails |
| `onValidationError` | `Function` | No | Called when validation fails |

#### Returns

`JetFormController<Request, Response>` - A controller with form state and actions

### JetFormController

The controller returned by `useJetForm` provides:

#### Properties

```dart
// State properties
bool isLoading        // Form is submitting
bool hasError        // Form has an error
bool hasValue        // Form submission succeeded
bool isIdle          // Form is in initial state

Request? request     // The submitted request data
Response? response   // The response data
Object? error        // The error object if any

Map<String, dynamic>? values  // Current form field values
```

#### Methods

```dart
void submit()                                    // Submit the form
void reset()                                     // Reset form to initial state
void validateField(String fieldName)             // Validate specific field
bool validateForm()                              // Validate all fields
bool save()                                      // Save form state
void invalidateFields(Map<String, List<String>>) // Set field errors
```

### JetSimpleForm Widget

```dart
JetSimpleForm<Request, Response>({
  required JetFormController<Request, Response> controller,
  required List<Widget> children,
  String? submitButtonText,
  bool showSubmitButton = true,
  double fieldSpacing = 16,
  Map<String, dynamic> initialValues = const {},
  bool Function()? onBeforeSubmit,
  bool expandSubmitButton = true,
  Widget? submitButton,
})
```

#### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `controller` | `JetFormController` | Yes | - | Form controller from useJetForm |
| `children` | `List<Widget>` | Yes | - | Form field widgets |
| `submitButtonText` | `String?` | No | "Submit" | Text for submit button |
| `showSubmitButton` | `bool` | No | `true` | Show/hide default submit button |
| `fieldSpacing` | `double` | No | `16` | Space between form fields |
| `initialValues` | `Map` | No | `{}` | Initial form values |
| `onBeforeSubmit` | `Function` | No | `null` | Callback before submit (return false to prevent) |
| `expandSubmitButton` | `bool` | No | `true` | Make button full width |
| `submitButton` | `Widget?` | No | `null` | Custom submit button widget |

## Complete Examples

### Example 1: Simple Login Form

```dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/forms/forms.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = useJetForm<LoginRequest, LoginResponse>(
      ref: ref,
      decoder: (json) => LoginRequest.fromJson(json),
      action: (request) => ref.read(authServiceProvider).login(request),
      onSuccess: (response, request) {
        context.showToast('Welcome back!');
        Navigator.pushReplacement(context, HomePage.route());
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: JetSimpleForm(
          controller: form,
          submitButtonText: 'Login',
          children: [
            FormBuilderTextField(
              name: 'email',
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.email(),
              ]),
            ),
            JetPasswordField(
              name: 'password',
              hintText: 'Password',
            ),
          ],
        ),
      ),
    );
  }
}

// Models
class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
        email: json['email'] as String,
        password: json['password'] as String,
      );
}

class LoginResponse {
  final String token;
  final User user;

  const LoginResponse({required this.token, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        token: json['token'] as String,
        user: User.fromJson(json['user']),
      );
}
```

### Example 2: Contact Form with Custom Validation

```dart
class ContactPage extends HookConsumerWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = useJetForm<ContactRequest, ContactResponse>(
      ref: ref,
      decoder: (json) => ContactRequest.fromJson(json),
      action: (request) async {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));
        return ContactResponse(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message: 'Thank you for contacting us!',
        );
      },
      onSuccess: (response, request) {
        context.showToast(response.message);
        form.reset(); // Reset form after success
      },
      onValidationError: (error, stackTrace) {
        context.showToast('Please fix the errors in the form');
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            JetSimpleForm(
              controller: form,
              submitButtonText: 'Send Message',
              children: [
                FormBuilderTextField(
                  name: 'name',
                  decoration: const InputDecoration(
                    labelText: 'Your Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: FormBuilderValidators.required(),
                ),
                FormBuilderTextField(
                  name: 'email',
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ]),
                ),
                FormBuilderTextField(
                  name: 'subject',
                  decoration: const InputDecoration(
                    labelText: 'Subject',
                    prefixIcon: Icon(Icons.subject),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(5),
                  ]),
                ),
                FormBuilderTextField(
                  name: 'message',
                  decoration: const InputDecoration(
                    labelText: 'Message',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(20),
                  ]),
                ),
              ],
            ),
            
            // Show success message
            if (form.hasValue) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.green.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          form.response!.message,
                          style: const TextStyle(color: Colors.green),
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
```

### Example 3: Form with Conditional Fields

```dart
class RegisterPage extends HookConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = useJetForm<RegisterRequest, RegisterResponse>(
      ref: ref,
      decoder: (json) => RegisterRequest.fromJson(json),
      action: (request) => ref.read(authServiceProvider).register(request),
      onSuccess: (response, request) {
        context.showToast('Registration successful!');
        Navigator.pushReplacement(context, HomePage.route());
      },
    );

    // Watch form state to show/hide conditional fields
    final accountType = useState('personal');

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: JetSimpleForm(
          controller: form,
          submitButtonText: 'Create Account',
          onBeforeSubmit: () {
            // Custom validation before submit
            if (accountType.value == 'business' && 
                form.values?['companyName'] == null) {
              context.showToast('Company name is required for business accounts');
              return false;
            }
            return true;
          },
          children: [
            FormBuilderDropdown<String>(
              name: 'accountType',
              decoration: const InputDecoration(labelText: 'Account Type'),
              items: const [
                DropdownMenuItem(value: 'personal', child: Text('Personal')),
                DropdownMenuItem(value: 'business', child: Text('Business')),
              ],
              initialValue: 'personal',
              onChanged: (value) {
                accountType.value = value ?? 'personal';
              },
            ),
            
            FormBuilderTextField(
              name: 'email',
              decoration: const InputDecoration(labelText: 'Email'),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.email(),
              ]),
            ),
            
            // Conditional field for business accounts
            if (accountType.value == 'business')
              FormBuilderTextField(
                name: 'companyName',
                decoration: const InputDecoration(labelText: 'Company Name'),
                validator: FormBuilderValidators.required(),
              ),
            
            JetPasswordField(
              name: 'password',
              formKey: form.formKey,
            ),
            
            JetPasswordField(
              name: 'confirmPassword',
              hintText: 'Confirm Password',
              identicalWith: 'password',
              formKey: form.formKey,
            ),
          ],
        ),
      ),
    );
  }
}
```

## Advanced Usage

### Accessing Form State

```dart
final form = useJetForm<MyRequest, MyResponse>(
  ref: ref,
  decoder: (json) => MyRequest.fromJson(json),
  action: (request) => apiService.submit(request),
);

// Check form state
if (form.isLoading) {
  return CircularProgressIndicator();
}

if (form.hasError) {
  return Text('Error: ${form.error}');
}

if (form.hasValue) {
  return Text('Success! Response: ${form.response}');
}
```

### Manual Form Control

```dart
// Manually submit the form
ElevatedButton(
  onPressed: () => form.submit(),
  child: const Text('Submit'),
)

// Reset the form
TextButton(
  onPressed: () => form.reset(),
  child: const Text('Clear Form'),
)

// Validate a specific field
form.validateField('email');

// Validate entire form
if (form.validateForm()) {
  // Form is valid
}

// Manually set field errors
form.invalidateFields({
  'email': ['This email is already taken'],
  'username': ['Username must be unique'],
});
```

### Custom Submit Button

```dart
JetSimpleForm(
  controller: form,
  showSubmitButton: false, // Hide default button
  children: [
    // ... form fields ...
    
    Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: form.submit,
            child: const Text('Save'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: form.reset,
            child: const Text('Cancel'),
          ),
        ),
      ],
    ),
  ],
)
```

## Comparison with JetFormNotifier

| Feature | useJetForm | JetFormNotifier + JetFormBuilder |
|---------|-----------|----------------------------------|
| Setup Complexity | ⭐ Low | ⭐⭐⭐ Medium |
| Code Organization | Inline | Separate files |
| Reusability | Single page | Multiple pages |
| Testability | Limited | Excellent |
| Type Safety | ✅ Yes | ✅ Yes |
| Error Handling | ✅ Automatic | ✅ Automatic |
| Custom Validation | Basic | Advanced |
| Best For | Simple forms | Complex forms |

## Best Practices

1. **Use appropriate types**: Always specify generic types for type safety
   ```dart
   // Good
   useJetForm<LoginRequest, LoginResponse>(...)
   
   // Bad (loses type safety)
   useJetForm<dynamic, dynamic>(...)
   ```

2. **Handle errors gracefully**: Provide meaningful error messages
   ```dart
   onError: (error, stackTrace) {
     if (error is JetError) {
       context.showToast(error.message);
     } else {
       context.showToast('An unexpected error occurred');
     }
   }
   ```

3. **Reset form after success**: For create/add forms
   ```dart
   onSuccess: (response, request) {
     context.showToast('Item created!');
     form.reset(); // Clear form for next entry
   }
   ```

4. **Provide initial values**: For edit forms
   ```dart
   JetSimpleForm(
     controller: form,
     initialValues: {
       'email': user.email,
       'name': user.name,
     },
     children: [...],
   )
   ```

5. **Use HookConsumerWidget**: Required for using both hooks and riverpod
   ```dart
   class MyPage extends HookConsumerWidget {
     // Not StatelessWidget or HookWidget
   }
   ```

## Migration Guide

### From JetFormNotifier to useJetForm

Before:
```dart
// todo_form.dart
@riverpod
class TodoForm extends JetFormNotifier<TodoRequest, TodoResponse> {
  @override
  AsyncFormValue<TodoRequest, TodoResponse> build() => const AsyncFormIdle();
  
  @override
  TodoRequest decoder(Map<String, dynamic> json) => TodoRequest.fromJson(json);
  
  @override
  Future<TodoResponse> action(TodoRequest data) async {
    return await apiService.createTodo(data);
  }
}

// todo_page.dart
class TodoPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return JetFormBuilder<TodoRequest, TodoResponse>(
      provider: todoFormProvider,
      builder: (context, ref, form, state) {
        return [
          FormBuilderTextField(name: 'title'),
        ];
      },
    );
  }
}
```

After:
```dart
// todo_page.dart (single file)
class TodoPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = useJetForm<TodoRequest, TodoResponse>(
      ref: ref,
      decoder: (json) => TodoRequest.fromJson(json),
      action: (request) => ref.read(apiServiceProvider).createTodo(request),
    );
    
    return JetSimpleForm(
      controller: form,
      children: [
        FormBuilderTextField(name: 'title'),
      ],
    );
  }
}
```

## Troubleshooting

### "The method 'useJetForm' isn't defined"

Make sure you:
1. Import the forms package: `import 'package:jet/forms/forms.dart';`
2. Use `HookConsumerWidget` instead of `StatelessWidget`
3. Have `flutter_hooks` and `hooks_riverpod` in your dependencies

### Form not rebuilding on state change

Ensure you're using the `form` controller properties correctly:
```dart
// Good - will rebuild
if (form.isLoading) { ... }

// Bad - won't trigger rebuild
if (form.state.isLoading) { ... }
```

### Validation not working

Check that:
1. Field names match the decoder's expected JSON keys
2. Validators are properly attached to form fields
3. You're calling `form.submit()` not bypassing validation

## See Also

- [JetFormNotifier Documentation](./FORM_NOTIFIER.md)
- [JetFormBuilder Documentation](./FORM_BUILDER.md)
- [Form Validation Guide](./FORM_VALIDATION.md)
- [Example App](../../example/lib/features/todo/simple_todo_page.dart)

