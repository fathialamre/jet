# Forms Documentation

Complete guide to form management in the Jet framework.

## Overview

Jet provides powerful form management built on **[Flutter Form Builder](https://pub.dev/packages/flutter_form_builder)** with enhanced state management through Riverpod. It offers two approaches: the simple `useJetForm` hook for quick forms and the full-featured `JetFormNotifier` for complex business logic.

**Packages Used:**
- **flutter_form_builder** - ^9.1.1 - [pub.dev](https://pub.dev/packages/flutter_form_builder) | [Documentation](https://pub.dev/documentation/flutter_form_builder/latest/) - Form widgets with built-in validation
- **form_builder_validators** - ^9.1.0 - [pub.dev](https://pub.dev/packages/form_builder_validators) - Pre-built validation rules
- **flutter_hooks** - ^0.20.5 - [pub.dev](https://pub.dev/packages/flutter_hooks) - React-style hooks for Flutter
- **hooks_riverpod** - ^2.4.9 - [pub.dev](https://pub.dev/packages/hooks_riverpod) - Riverpod with hooks support
- **riverpod_annotation** - ^2.3.3 - [pub.dev](https://pub.dev/packages/riverpod_annotation) - Code generation support

**Key Benefits:**
- ✅ Zero boilerplate with useJetForm hook
- ✅ Type-safe form state with Request/Response generics
- ✅ Automatic validation with 20+ built-in validators
- ✅ Server-side error integration with field invalidation
- ✅ Enhanced input widgets (password, phone, PIN, date, etc.)
- ✅ Built-in loading states and error handling
- ✅ Form state persistence
- ✅ Riverpod 3 code generation support
- ✅ Lifecycle callbacks (onSuccess, onError, onValidationError)

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Two Approaches](#two-approaches)
  - [useJetForm Hook](#usejetform-hook)
  - [JetFormNotifier](#jetformnotifier)
- [Form Builder Variants](#form-builder-variants)
- [Form Inputs](#form-inputs)
- [Riverpod 3 Code Generation](#riverpod-3-code-generation)
- [Complete Examples](#complete-examples)
- [API Reference](#api-reference)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Overview

Jet provides powerful form management with two approaches:

1. **useJetForm Hook** - Simplified inline forms without separate notifier classes (recommended for simple forms)
2. **JetFormNotifier + JetFormBuilder** - Full-featured forms with separate notifier classes (recommended for complex forms)

**Key Features:**
- ✅ Type-safe form state with Request/Response generics
- ✅ Automatic validation and error handling
- ✅ Server-side error integration
- ✅ Enhanced input components (password, phone, PIN/OTP)
- ✅ Built-in loading states
- ✅ Riverpod 3 integration with JetFormMixin
- ✅ Multiple JetFormBuilder variants for different use cases

## Quick Start

### Simple Form with useJetForm Hook

```dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/forms/forms.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = useJetForm<LoginRequest, LoginResponse>(
      ref: ref,
      decoder: (json) => LoginRequest.fromJson(json),
      action: (request) async {
        final authService = ref.read(authServiceProvider);
        return await authService.login(request.email, request.password);
      },
      onSuccess: (response, request) {
        context.showToast('Welcome back, ${response.user.name}!');
        context.router.pushNamed('/dashboard');
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: JetSimpleForm(
          controller: form,
          submitButtonText: 'Sign In',
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
              isRequired: true,
            ),
          ],
        ),
      ),
    );
  }
}
```

## Two Approaches

### useJetForm Hook

Perfect for simple forms, rapid prototyping, and cases where full JetFormNotifier setup feels like overkill.

**When to use:**
- Building simple forms with straightforward logic
- Prototyping or experimenting quickly
- Form logic is specific to a single page/widget
- You don't need to share form state across multiple components

**Features:**
- ✅ Zero boilerplate - no separate notifier files needed
- ✅ Type-safe with generic Request/Response types
- ✅ Built-in loading states and error handling
- ✅ Lifecycle callbacks (onSuccess, onError, onValidationError)
- ✅ Access to form state (isLoading, hasError, hasValue)

**Example:**

```dart
final form = useJetForm<LoginRequest, LoginResponse>(
  ref: ref,
  decoder: (json) => LoginRequest.fromJson(json),
  action: (request) => ref.read(authServiceProvider).login(request),
  onSuccess: (response, request) {
    context.showToast('Login successful!');
    Navigator.pushReplacement(context, HomePage.route());
  },
  onError: (error, stackTrace) {
    dump('Login error: $error');
  },
);

return JetSimpleForm(
  controller: form,
  submitButtonText: 'Login',
  children: [
    FormBuilderTextField(name: 'email'),
    JetPasswordField(name: 'password'),
  ],
);
```

### JetFormNotifier

For complex forms with business logic, extensive validation, or reusable form logic.

**When to use:**
- Building complex forms with business logic
- Need to reuse form logic across multiple pages
- Require extensive custom validation
- Want to test form logic in isolation
- Need to share form state across component tree

**Example:**

```dart
// 1. Create form notifier
class LoginFormNotifier extends JetFormNotifier<LoginRequest, User> {
  LoginFormNotifier(super.ref);

  @override
  LoginRequest decoder(Map<String, dynamic> formData) {
    return LoginRequest.fromJson(formData);
  }

  @override
  Future<User> action(LoginRequest data) async {
    final authService = ref.read(authServiceProvider);
    return await authService.login(data.email, data.password);
  }
}

// 2. Create provider
final loginFormProvider = JetFormProvider<LoginRequest, User>(
  (ref) => LoginFormNotifier(ref),
);

// 3. Build form UI
class LoginFormWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetFormBuilder<LoginRequest, User>(
      provider: loginFormProvider,
      onSuccess: (user, request) {
        context.router.pushNamed('/dashboard');
      },
      builder: (context, ref, form, state) => [
        FormBuilderTextField(name: 'email'),
        JetPasswordField(name: 'password'),
      ],
    );
  }
}
```

## Form Builder Variants

JetFormBuilder provides three constructor variants for different form complexity levels:

### 1. Default Constructor

Standard constructor with balanced defaults suitable for most forms.

```dart
JetFormBuilder<LoginRequest, User>(
  provider: loginFormProvider,
  onSuccess: (user, request) {
    context.router.pushNamed('/dashboard');
  },
  builder: (context, ref, form, state) => [
    FormBuilderTextField(name: 'email'),
    JetPasswordField(name: 'password'),
  ],
)
```

**Features:**
- Shows error snackbar on failure (`showErrorSnackBar: true`)
- Uses default error handler (`useDefaultErrorHandler: true`)
- Shows default submit button (`showDefaultSubmitButton: true`)
- Perfect for standard forms with typical behavior

### 2. .advanced Constructor

For complex forms requiring full control over error handling and submission.

```dart
JetFormBuilder.advanced(
  provider: loginFormProvider,
  builder: (context, ref, form, state) => [
    FormBuilderTextField(name: 'email'),
    FormBuilderTextField(name: 'password'),
    
    // Custom submit button with loading state
    state.isLoading
        ? CircularProgressIndicator()
        : ElevatedButton(
            onPressed: () => form.submit(),
            child: Text('Custom Submit'),
          ),
  ],
  onSuccess: (response, request) {
    showCustomSuccessDialog(response);
  },
  onError: (error, stackTrace, invalidateFields) {
    if (error is JetError && error.isValidation) {
      showValidationErrorSheet(error.errors);
    } else {
      showCustomErrorDialog(error.toString());
    }
  },
)
```

**Features:**
- No error snackbar (`showErrorSnackBar: false`)
- No default error handler (`useDefaultErrorHandler: false`)
- No default submit button (`showDefaultSubmitButton: false`)
- Full control over error handling and UI

**Use Cases:**
- Forms with custom error displays (inline errors, dialogs)
- Multi-step forms with custom navigation
- Forms requiring custom submission buttons
- Forms with custom validation feedback

### 3. .hook Constructor

For use within `HookConsumerWidget` where the builder needs to use Flutter hooks.

```dart
class LoginPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: JetFormBuilder.hook(
        provider: loginFormProvider,
        builder: (context, ref, form, state) {
          // Use hooks inside the builder
          final focusNode = useFocusNode();
          final animationController = useAnimationController(
            duration: Duration(milliseconds: 300),
          );
          
          useEffect(() {
            if (state.hasError) {
              animationController.forward();
            }
            return null;
          }, [state.hasError]);

          return [
            FormBuilderTextField(
              name: 'email',
              focusNode: focusNode,
            ),
            JetPasswordField(name: 'password'),
          ];
        },
        onSuccess: (user, request) {
          context.router.pushNamed('/dashboard');
        },
      ),
    );
  }
}
```

**Features:**
- Identical behavior to default constructor
- Allows use of Flutter hooks within builder
- Perfect for forms with animations or focus management

**Comparison Table:**

| Feature | Default | .advanced | .hook |
|---------|---------|-----------|-------|
| Error Snackbar | ✅ Yes | ❌ No | ✅ Yes |
| Default Error Handler | ✅ Yes | ❌ No | ✅ Yes |
| Default Submit Button | ✅ Yes | ❌ No | ✅ Yes |
| Hook Support | ⚠️ Not intended | ⚠️ Not intended | ✅ Yes |
| Custom Error Handling | Optional | Required | Optional |
| Use Case | Standard forms | Custom UI/logic | Hook-based forms |

## Form Inputs

Jet provides specialized input components with built-in validation:

### JetPasswordField

Password field with visibility toggle and confirmation support.

```dart
// Basic password field
JetPasswordField(
  name: 'password',
  hintText: 'Enter your password',
  isRequired: true,
  showPrefixIcon: true,
)

// Password confirmation
JetPasswordField(
  name: 'confirm_password',
  hintText: 'Confirm password',
  identicalWith: 'password',
  formKey: formKey,
  isRequired: true,
)
```

### JetPhoneField

Phone number field with validation.

```dart
JetPhoneField(
  name: 'phone',
  hintText: 'Phone number',
  isRequired: true,
  showPrefixIcon: true,
  validator: FormBuilderValidators.compose([
    FormBuilderValidators.required(),
    FormBuilderValidators.minLength(10),
    FormBuilderValidators.numeric(),
  ]),
)
```

### JetPinField

PIN/OTP field with customizable appearance.

```dart
JetPinField(
  name: 'otp',
  length: 6,
  isRequired: true,
  autofocus: true,
  spacing: 12.0,
  onCompleted: (pin) {
    formKey.currentState?.save();
  },
  onSubmitted: (pin) => verifyOTP(pin),
)
```

### Other Form Inputs

- **JetTextField** - General text input
- **JetEmailField** - Email input with validation
- **JetDateField** - Date picker
- **JetDropdownField** - Dropdown selection
- **JetCheckboxField** - Checkbox or switch
- **JetTextAreaField** - Multi-line text input

**📖 [View Complete Form Fields Documentation](FORM_FIELDS.md)**

## Riverpod 3 Code Generation

Jet Framework fully supports Riverpod 3 generators with the JetFormMixin.

### Using JetFormMixin

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_form.g.dart';

@riverpod
class UserForm extends _$UserForm with JetFormMixin<UserRequest, User> {
  @override
  AsyncFormValue<UserRequest, User> build(int userId) {
    return const AsyncFormIdle();
  }

  @override
  UserRequest decoder(Map<String, dynamic> formData) {
    return UserRequest.fromJson(formData);
  }

  @override
  Future<User> action(UserRequest data) async {
    final apiService = ref.read(userApiServiceProvider);
    return await apiService.createUser(data);
  }
}

// Use the generated provider
class UserFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetFormBuilder<UserRequest, User>(
      provider: userFormProvider(userId), // Generated provider
      builder: (context, ref, form, state) => [
        // Your form fields
      ],
    );
  }
}
```

### Migration from Legacy to Code Generation

**Before (Legacy):**
```dart
class TodoFormNotifier extends JetFormNotifier<TodoRequest, TodoResponse> {
  TodoFormNotifier(super.ref);
  
  @override
  TodoRequest decoder(Map<String, dynamic> json) => TodoRequest.fromJson(json);
  
  @override
  Future<TodoResponse> action(TodoRequest data) async {
    return await apiService.createTodo(data);
  }
}

final todoFormProvider = JetFormProvider<TodoRequest, TodoResponse>(
  (ref) => TodoFormNotifier(ref),
);
```

**After (With code generation):**
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_form.g.dart';

@riverpod
class TodoForm extends _$TodoForm with JetFormMixin<TodoRequest, TodoResponse> {
  @override
  AsyncFormValue<TodoRequest, TodoResponse> build(int id) {
    return const AsyncFormIdle();
  }
  
  @override
  TodoRequest decoder(Map<String, dynamic> json) => TodoRequest.fromJson(json);
  
  @override
  Future<TodoResponse> action(TodoRequest data) async {
    final apiService = ref.read(apiServiceProvider);
    return await apiService.createTodo(data);
  }
}

// Provider is auto-generated: todoFormProvider(id)
```

**Key Migration Steps:**
1. Add `@riverpod` annotation
2. Change `extends JetFormNotifier` to `extends _$TodoForm with JetFormMixin`
3. Add `part 'filename.g.dart';` directive
4. Remove manual provider creation
5. Run `dart run build_runner build`

## Complete Examples

### Example 1: Contact Form with Custom Validation

```dart
class ContactPage extends HookConsumerWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = useJetForm<ContactRequest, ContactResponse>(
      ref: ref,
      decoder: (json) => ContactRequest.fromJson(json),
      action: (request) async {
        await Future.delayed(const Duration(seconds: 2));
        return ContactResponse(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message: 'Thank you for contacting us!',
        );
      },
      onSuccess: (response, request) {
        context.showToast(response.message);
        form.reset();
      },
      onValidationError: (error, stackTrace) {
        context.showToast('Please fix the errors in the form');
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: JetSimpleForm(
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
      ),
    );
  }
}
```

### Example 2: Registration Form with Complex Validation

```dart
@riverpod
class RegistrationForm extends _$RegistrationForm with JetFormMixin<RegisterRequest, User> {
  @override
  AsyncFormValue<RegisterRequest, User> build() {
    return const AsyncFormIdle();
  }

  @override
  RegisterRequest decoder(Map<String, dynamic> json) {
    return RegisterRequest.fromJson(json);
  }

  @override
  Future<User> action(RegisterRequest data) async {
    // Complex validation logic
    if (data.age < 18) {
      throw JetError.validation(errors: {
        'age': ['Must be 18 or older']
      });
    }

    // Multiple API calls
    final verified = await ref.read(verificationServiceProvider).verify(data.email);
    if (!verified) {
      throw JetError.validation(errors: {
        'email': ['Email verification failed']
      });
    }

    return await ref.read(authServiceProvider).register(data);
  }
}

class RegistrationPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: JetFormBuilder<RegisterRequest, User>(
        provider: registrationFormProvider,
        onSuccess: (user, request) {
          context.showToast('Registration successful!');
          context.router.pushNamed('/dashboard');
        },
        builder: (context, ref, form, state) => [
          JetTextField(name: 'name', labelText: 'Full Name'),
          JetEmailField(name: 'email', labelText: 'Email'),
          JetPasswordField(name: 'password', formKey: form.formKey),
          JetPasswordField(
            name: 'confirmPassword',
            identicalWith: 'password',
            formKey: form.formKey,
          ),
          JetPhoneField(name: 'phone', labelText: 'Phone'),
        ],
      ),
    );
  }
}
```

## API Reference

### useJetForm

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

**Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `ref` | `WidgetRef` | Yes | Widget ref from HookConsumerWidget |
| `decoder` | `Function` | Yes | Converts form Map to Request object |
| `action` | `Function` | Yes | Async function that processes the request |
| `initialValues` | `Map` | No | Initial form field values |
| `onSuccess` | `Function` | No | Called when submission succeeds |
| `onError` | `Function` | No | Called when submission fails |
| `onValidationError` | `Function` | No | Called when validation fails |

### JetFormController

**Properties:**
```dart
bool isLoading        // Form is submitting
bool hasError        // Form has an error
bool hasValue        // Form submission succeeded
bool isIdle          // Form is in initial state

Request? request     // The submitted request data
Response? response   // The response data
Object? error        // The error object if any

Map<String, dynamic>? values  // Current form field values
```

**Methods:**
```dart
void submit()                                    // Submit the form
void reset()                                     // Reset form to initial state
void validateField(String fieldName)             // Validate specific field
bool validateForm()                              // Validate all fields
bool save()                                      // Save form state
void invalidateFields(Map<String, List<String>>) // Set field errors
```

### JetSimpleForm

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

## Best Practices

### 1. Choose the Right Approach

**Use useJetForm when:**
- Form logic is simple and straightforward
- You don't need to test form logic in isolation
- Form is only used in one place
- Rapid prototyping or experimentation
- Forms with basic validation and single API call

**Use JetFormNotifier when:**
- Form has complex business logic
- You need to test form logic separately
- Form logic is reused across multiple pages
- Multiple API calls or complex async operations
- Custom validation logic that needs to be tested

### 2. Always Specify Generic Types

```dart
// Good
useJetForm<LoginRequest, LoginResponse>(...)

// Bad (loses type safety)
useJetForm<dynamic, dynamic>(...)
```

### 3. Handle Errors Gracefully

```dart
onError: (error, stackTrace) {
  if (error is JetError) {
    context.showToast(error.message);
  } else {
    context.showToast('An unexpected error occurred');
  }
}
```

### 4. Reset Form After Success

```dart
onSuccess: (response, request) {
  context.showToast('Item created!');
  form.reset(); // Clear form for next entry
}
```

### 5. Provide Initial Values for Edit Forms

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

### 6. Use HookConsumerWidget

```dart
class MyPage extends HookConsumerWidget {
  // Not StatelessWidget or HookWidget
}
```

## Troubleshooting

### "The method 'useJetForm' isn't defined"

Make sure you:
1. Import the forms package: `import 'package:jet/forms/forms.dart';`
2. Use `HookConsumerWidget` instead of `StatelessWidget`
3. Have `flutter_hooks` and `hooks_riverpod` in your dependencies

### Form not rebuilding on state change

Ensure you're using the form controller properties correctly:
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

### Password confirmation not working

Make sure you provide the `formKey` parameter:
```dart
JetPasswordField(
  name: 'confirmPassword',
  formKey: formKey, // Required!
  identicalWith: 'password',
)
```

## See Also

- [Form Fields Documentation](FORM_FIELDS.md) - Complete guide to all form inputs
- [Error Handling Documentation](ERROR_HANDLING.md) - JetError and validation
- [State Management Documentation](STATE_MANAGEMENT.md) - Riverpod integration

