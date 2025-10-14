# Login Form Example - useJetForm Hook

This example demonstrates how to use the `useJetForm` hook for building a simple login form without creating separate form notifier classes.

## Features Demonstrated

- ✅ **Zero Boilerplate** - Form logic defined inline, no separate notifier files
- ✅ **Type Safety** - Generic types for LoginRequest and LoginResponse
- ✅ **Lifecycle Callbacks** - onSuccess, onError, and onValidationError handlers
- ✅ **Built-in State Management** - Automatic loading, error, and success states
- ✅ **Form Validation** - Email and password validation with FormBuilderValidators
- ✅ **Error Handling** - Validation errors, server errors, and network errors
- ✅ **Enhanced Input Components** - JetPasswordField with visibility toggle
- ✅ **JetSimpleForm Widget** - Simplified form UI with automatic submit button

## Test Cases

The login form includes three test scenarios:

1. **Success Case**: `test@example.com` - Demonstrates successful login
2. **Validation Error**: `error@test.com` - Shows field-level validation errors
3. **Server Error**: `server@test.com` - Demonstrates server error handling

## Files

### Models
- `models/login_request.dart` - Login request data model
- `models/login_response.dart` - Login response data model

### Pages
- `login_page.dart` - Main login page with useJetForm hook

## Usage

```dart
import 'package:example/features/login/login_page.dart';
import 'package:example/core/router/app_router.gr.dart';

// Navigate to login page
context.router.push(LoginRoute());
```

## Code Highlights

### Using useJetForm Hook

```dart
final form = useJetForm<LoginRequest, LoginResponse>(
  ref: ref,
  decoder: (json) => LoginRequest.fromJson(json),
  action: (request) async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 2));
    return LoginResponse(...);
  },
  onSuccess: (response, request) {
    context.showToast('Welcome back, ${response.name}!');
  },
  onError: (error, stackTrace) {
    // Handle errors
  },
);
```

### Using JetSimpleForm Widget

```dart
JetSimpleForm<LoginRequest, LoginResponse>(
  controller: form,
  submitButtonText: 'Sign In',
  children: [
    FormBuilderTextField(
      name: 'email',
      decoration: const InputDecoration(
        labelText: 'Email Address',
        prefixIcon: Icon(Icons.email_outlined),
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.email(),
      ]),
    ),
    JetPasswordField(
      name: 'password',
      labelText: 'Password',
      isRequired: true,
    ),
  ],
)
```

### Accessing Form State

```dart
// Check form state
if (form.isLoading) {
  // Show loading indicator
}

if (form.hasValue) {
  // Show success message
  print('Token: ${form.response!.token}');
}

if (form.hasError) {
  // Show error message
}

// Reset form
form.reset();
```

## When to Use useJetForm

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

## Comparison with Traditional Approach

### Traditional Approach (JetFormNotifier)
- Requires separate notifier class file
- Requires provider definition
- Better for complex forms with business logic
- Easier to test in isolation

### useJetForm Hook Approach
- All logic inline in the widget
- No separate files needed
- Perfect for simple forms
- Quick prototyping

## Learn More

- See `/packages/jet/USE_JET_FORM.md` for comprehensive documentation
- Check `/example/lib/features/todo/simple_todo_page.dart` for another example
- Compare with `/example/lib/features/todo/todo_page.dart` for traditional approach

