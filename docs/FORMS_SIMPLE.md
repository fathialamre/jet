# Simple Forms Guide

## Overview

Simple Forms using the `useJetForm` hook is the recommended approach for 80% of forms in your app. It provides a clean, intuitive API with minimal boilerplate.

**Perfect for:**
- Login forms
- Registration forms
- Settings pages
- Contact forms
- Profile edit forms
- Search forms
- Feedback forms
- Any standard form with 3-20 fields

**Key Benefits:**
- ✅ Zero boilerplate - define inline
- ✅ Quick to implement (5-10 minutes)
- ✅ Easy to understand and maintain
- ✅ Type-safe with Request/Response generics
- ✅ Built-in loading, success, and error states
- ✅ Works with all Jet form fields

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Core Concepts](#core-concepts)
3. [Complete Example](#complete-example)
4. [Using Form Fields](#using-form-fields)
5. [Validation](#validation)
6. [Handling Responses](#handling-responses)
7. [Form State](#form-state)
8. [Common Patterns](#common-patterns)
9. [Best Practices](#best-practices)
10. [When to Upgrade](#when-to-upgrade-to-advanced-forms)

---

## Quick Start

### Step 1: Create Request and Response Models

```dart
// lib/models/login_request.dart
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
    email: json['email'] as String,
    password: json['password'] as String,
  );
}

// lib/models/login_response.dart
class LoginResponse {
  final String token;
  final String userId;
  final String name;

  LoginResponse({
    required this.token,
    required this.userId,
    required this.name,
  });
}
```

### Step 2: Create Form with useJetForm Hook

```dart
import 'package:flutter/material.dart';
import 'package:jet/jet.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Create form using the hook
    final form = useJetForm<LoginRequest, LoginResponse>(
      ref: ref,
      decoder: (json) => LoginRequest.fromJson(json),
      action: (request) async {
        // Call your API
        return await apiService.login(request);
      },
      onSuccess: (response, request) {
        // Handle success
        context.showToast('Welcome ${response.name}!');
        context.router.push(const HomeRoute());
      },
      onError: (error, stackTrace) {
        // Handle error
        context.showToast('Login failed: $error');
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: JetSimpleForm(
          form: form,
          submitButtonText: 'Login',
          children: [
            JetTextField(
              name: 'email',
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              validator: JetValidators.compose([
                JetValidators.required(),
                JetValidators.email(),
              ]),
            ),
            JetPasswordField(
              name: 'password',
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              validator: JetValidators.required(),
            ),
          ],
        ),
      ),
    );
  }
}
```

**That's it!** You now have a fully functional form with validation, loading states, and error handling.

---

## Core Concepts

### useJetForm Hook

The `useJetForm` hook creates a form controller that manages form state, validation, and submission.

**Required Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `ref` | `WidgetRef` | Riverpod ref (from HookConsumerWidget) |
| `decoder` | `Function` | Converts form values (Map) to Request object |
| `action` | `Future Function` | Async function that submits data and returns Response |

**Optional Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `initialValues` | `Map<String, dynamic>` | Initial values for form fields |
| `onSuccess` | `Function` | Callback when submission succeeds |
| `onError` | `Function` | Callback when submission fails |
| `onValidationError` | `Function` | Callback when validation fails |

### JetSimpleForm Widget

The `JetSimpleForm` widget provides a convenient wrapper that handles form layout and submit button.

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `form` | `JetFormController` | Form controller from useJetForm |
| `children` | `List<Widget>` | List of form fields |
| `submitButtonText` | `String?` | Text for submit button (optional) |
| `fieldSpacing` | `double?` | Spacing between fields (default: 16) |
| `showSubmitButton` | `bool` | Whether to show submit button (default: true) |

---

## Complete Example

Here's a complete registration form with all features:

```dart
import 'package:flutter/material.dart';
import 'package:jet/jet.dart';

class RegistrationPage extends HookConsumerWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = useJetForm<RegistrationRequest, RegistrationResponse>(
      ref: ref,
      decoder: (json) => RegistrationRequest.fromJson(json),
      action: (request) async {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));
        return RegistrationResponse(
          userId: '123',
          email: request.email,
          name: request.name,
        );
      },
      onSuccess: (response, request) {
        context.showToast('Registration successful!');
        context.router.push(const HomeRoute());
      },
      onError: (error, stackTrace) {
        context.showToast('Registration failed: $error');
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: form.reset,
            tooltip: 'Reset Form',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: JetSimpleForm(
          form: form,
          submitButtonText: 'Create Account',
          fieldSpacing: 20,
          children: [
            // Name field
            JetTextField(
              name: 'name',
              decoration: const InputDecoration(
                labelText: 'Full Name',
                hintText: 'John Doe',
                prefixIcon: Icon(Icons.person),
              ),
              validator: JetValidators.compose([
                JetValidators.required(),
                JetValidators.minLength(2),
              ]),
            ),

            // Email field
            JetTextField(
              name: 'email',
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'john@example.com',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: JetValidators.compose([
                JetValidators.required(),
                JetValidators.email(),
              ]),
            ),

            // Password field
            JetPasswordField(
              name: 'password',
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Minimum 8 characters',
                prefixIcon: Icon(Icons.lock),
              ),
              validator: JetValidators.compose([
                JetValidators.required(),
                JetValidators.minLength(8),
              ]),
            ),

            // Phone field
            JetPhoneField(
              name: 'phone',
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: '+1 (555) 123-4567',
                prefixIcon: Icon(Icons.phone),
              ),
              validator: JetValidators.phoneNumber(),
            ),

            // Date picker
            JetDateTimePicker(
              name: 'birthdate',
              decoration: const InputDecoration(
                labelText: 'Date of Birth',
                prefixIcon: Icon(Icons.cake),
              ),
              inputType: DateTimePickerInputType.date,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            ),

            // Dropdown
            JetDropdown<String>(
              name: 'country',
              decoration: const InputDecoration(
                labelText: 'Country',
                prefixIcon: Icon(Icons.flag),
              ),
              hint: const Text('Select your country'),
              options: const [
                JetFormOption(value: 'us', child: Text('United States')),
                JetFormOption(value: 'uk', child: Text('United Kingdom')),
                JetFormOption(value: 'ca', child: Text('Canada')),
              ],
              validator: JetValidators.required(),
            ),

            // Checkbox
            JetCheckbox(
              name: 'terms',
              title: const Text('I agree to the Terms and Conditions'),
              validator: JetValidators.equal(
                true,
                errorText: 'You must accept the terms',
              ),
            ),

            // Switch
            JetSwitch(
              name: 'newsletter',
              title: const Text('Subscribe to newsletter'),
              subtitle: const Text('Receive updates and promotions'),
            ),

            // Show success state
            if (form.hasValue) ...[
              const SizedBox(height: 20),
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 48),
                      const SizedBox(height: 8),
                      Text(
                        'Account Created!',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text('User ID: ${form.response!.userId}'),
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

// Models
class RegistrationRequest {
  final String name;
  final String email;
  final String password;
  final String? phone;
  final DateTime? birthdate;
  final String? country;
  final bool terms;
  final bool newsletter;

  RegistrationRequest({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.birthdate,
    this.country,
    required this.terms,
    required this.newsletter,
  });

  factory RegistrationRequest.fromJson(Map<String, dynamic> json) {
    return RegistrationRequest(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String?,
      birthdate: json['birthdate'] as DateTime?,
      country: json['country'] as String?,
      terms: json['terms'] as bool? ?? false,
      newsletter: json['newsletter'] as bool? ?? false,
    );
  }
}

class RegistrationResponse {
  final String userId;
  final String email;
  final String name;

  RegistrationResponse({
    required this.userId,
    required this.email,
    required this.name,
  });
}
```

---

## Using Form Fields

See [Form Fields Reference](FORM_FIELDS.md) for complete documentation of all field types.

**Quick reference of most common fields:**

```dart
// Text input
JetTextField(name: 'username')

// Password with visibility toggle
JetPasswordField(name: 'password')

// Phone number (numeric only)
JetPhoneField(name: 'phone')

// PIN/OTP input
JetPinField(name: 'otp', length: 6)

// Date picker
JetDateTimePicker(
  name: 'birthdate',
  inputType: DateTimePickerInputType.date,
)

// Dropdown selection
JetDropdown<String>(
  name: 'country',
  options: [...],
)

// Checkbox
JetCheckbox(
  name: 'terms',
  title: const Text('I agree'),
)

// Switch
JetSwitch(
  name: 'notifications',
  title: const Text('Enable notifications'),
)

// Slider
JetSlider(
  name: 'age',
  min: 18,
  max: 100,
)
```

---

## Validation

Jet Forms includes 70+ built-in validators. Use `JetValidators.compose()` to combine multiple validators.

### Basic Validation

```dart
JetTextField(
  name: 'email',
  validator: JetValidators.email(),
)
```

### Multiple Validators

```dart
JetTextField(
  name: 'username',
  validator: JetValidators.compose([
    JetValidators.required(),
    JetValidators.minLength(3),
    JetValidators.maxLength(20),
    JetValidators.alphanumeric(),
  ]),
)
```

### Custom Error Messages

```dart
JetTextField(
  name: 'email',
  validator: JetValidators.email(
    errorText: 'Please enter a valid email address',
  ),
)
```

### Common Validators

**String Validators:**
- `required()` - Field must not be empty
- `minLength(int)` - Minimum character count
- `maxLength(int)` - Maximum character count
- `email()` - Valid email format
- `url()` - Valid URL format
- `alphanumeric()` - Only letters and numbers
- `regex(pattern)` - Custom regex pattern

**Numeric Validators:**
- `numeric()` - Must be a number
- `integer()` - Must be an integer
- `min(num)` - Minimum value
- `max(num)` - Maximum value
- `positive()` - Must be positive
- `negative()` - Must be negative

**Boolean Validators:**
- `equal(value)` - Must equal specific value
- `notEqual(value)` - Must not equal value

See full validator list in the [Form Fields Reference](FORM_FIELDS.md#validators).

---

## Handling Responses

### Success Callback

```dart
final form = useJetForm<Request, Response>(
  // ...
  onSuccess: (response, request) {
    // Handle successful submission
    print('Success! Response: $response');
    
    // Show toast
    context.showToast('Form submitted successfully!');
    
    // Navigate to another page
    context.router.push(const SuccessRoute());
    
    // Update app state
    ref.read(userProvider.notifier).setUser(response.user);
  },
);
```

### Error Callback

```dart
final form = useJetForm<Request, Response>(
  // ...
  onError: (error, stackTrace) {
    // Handle submission error
    print('Error: $error');
    
    // Show error message
    context.showToast('Failed: $error');
    
    // Log error
    logger.error('Form submission failed', error, stackTrace);
  },
);
```

### Validation Error Callback

```dart
final form = useJetForm<Request, Response>(
  // ...
  onValidationError: (error, stackTrace) {
    // Handle validation errors
    context.showToast('Please fix form errors');
  },
);
```

---

## Form State

The form controller provides reactive state properties:

### State Properties

```dart
// Check if form is submitting
if (form.isLoading) {
  return CircularProgressIndicator();
}

// Check if submission was successful
if (form.hasValue) {
  print('Response: ${form.response}');
}

// Check if there's an error
if (form.hasError) {
  print('Error: ${form.error}');
}

// Check if form is idle (initial state)
if (form.isIdle) {
  // Form hasn't been submitted yet
}

// Check if form has unsaved changes
if (form.hasChanges) {
  // Show "unsaved changes" warning
}
```

### State Methods

```dart
// Submit the form
form.submit();

// Reset form to initial state
form.reset();

// Validate without submitting
form.validateForm();

// Validate specific field
form.validateField('email');

// Get current form values
final values = form.values;

// Access request/response
final request = form.request;
final response = form.response;
```

### Conditional UI Based on State

```dart
JetSimpleForm(
  form: form,
  children: [
    // ... fields ...
    
    // Show loading indicator
    if (form.isLoading)
      const Center(child: CircularProgressIndicator()),
    
    // Show success message
    if (form.hasValue)
      Card(
        color: Colors.green.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Success! ${form.response}'),
        ),
      ),
    
    // Show error message
    if (form.hasError)
      Card(
        color: Colors.red.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Error: ${form.error}'),
        ),
      ),
  ],
)
```

---

## Common Patterns

### Login Form

```dart
final form = useJetForm<LoginRequest, LoginResponse>(
  ref: ref,
  decoder: (json) => LoginRequest.fromJson(json),
  action: (request) => api.login(request),
  onSuccess: (response, request) {
    ref.read(authProvider.notifier).setToken(response.token);
    context.router.replace(const HomeRoute());
  },
);

return JetSimpleForm(
  form: form,
  children: [
    JetTextField(
      name: 'email',
      validator: JetValidators.compose([
        JetValidators.required(),
        JetValidators.email(),
      ]),
    ),
    JetPasswordField(
      name: 'password',
      validator: JetValidators.required(),
    ),
  ],
);
```

### Contact Form

```dart
final form = useJetForm<ContactRequest, ContactResponse>(
  ref: ref,
  decoder: (json) => ContactRequest.fromJson(json),
  action: (request) => api.sendContact(request),
  onSuccess: (response, request) {
    context.showToast('Message sent! We\'ll get back to you soon.');
    form.reset();
  },
);

return JetSimpleForm(
  form: form,
  submitButtonText: 'Send Message',
  children: [
    JetTextField(
      name: 'name',
      decoration: const InputDecoration(labelText: 'Your Name'),
      validator: JetValidators.required(),
    ),
    JetTextField(
      name: 'email',
      decoration: const InputDecoration(labelText: 'Email'),
      validator: JetValidators.compose([
        JetValidators.required(),
        JetValidators.email(),
      ]),
    ),
    JetTextField(
      name: 'message',
      decoration: const InputDecoration(labelText: 'Message'),
      maxLines: 5,
      validator: JetValidators.compose([
        JetValidators.required(),
        JetValidators.minLength(10),
      ]),
    ),
  ],
);
```

### Settings Form

```dart
final form = useJetForm<SettingsRequest, SettingsResponse>(
  ref: ref,
  decoder: (json) => SettingsRequest.fromJson(json),
  action: (request) => api.updateSettings(request),
  initialValues: {
    'notifications': true,
    'darkMode': false,
    'language': 'en',
  },
  onSuccess: (response, request) {
    context.showToast('Settings updated');
  },
);

return JetSimpleForm(
  form: form,
  submitButtonText: 'Save Settings',
  children: [
    JetSwitch(
      name: 'notifications',
      title: const Text('Enable notifications'),
    ),
    JetSwitch(
      name: 'darkMode',
      title: const Text('Dark mode'),
    ),
    JetDropdown<String>(
      name: 'language',
      decoration: const InputDecoration(labelText: 'Language'),
      options: const [
        JetFormOption(value: 'en', child: Text('English')),
        JetFormOption(value: 'ar', child: Text('Arabic')),
        JetFormOption(value: 'fr', child: Text('French')),
      ],
    ),
  ],
);
```

---

## Best Practices

### ✅ DO

1. **Use type-safe models**
   ```dart
   useJetForm<LoginRequest, LoginResponse>(...) // Good
   ```

2. **Handle all states**
   ```dart
   onSuccess: (response, request) { },
   onError: (error, stackTrace) { },
   ```

3. **Validate required fields**
   ```dart
   validator: JetValidators.required()
   ```

4. **Provide clear field labels**
   ```dart
   decoration: const InputDecoration(
     labelText: 'Email Address',
     hintText: 'your@email.com',
   )
   ```

5. **Show loading indicators**
   ```dart
   if (form.isLoading) CircularProgressIndicator()
   ```

### ❌ DON'T

1. **Don't skip error handling**
   ```dart
   // Bad: No onError
   useJetForm<Request, Response>(
     decoder: ...,
     action: ...,
   )
   ```

2. **Don't ignore validation**
   ```dart
   // Bad: No validator on required field
   JetTextField(name: 'email')
   ```

3. **Don't use generic types**
   ```dart
   // Bad: Not type-safe
   useJetForm<Map, Map>(...)
   ```

4. **Don't forget to reset after success**
   ```dart
   onSuccess: (response, request) {
     context.showToast('Success!');
     form.reset(); // Reset for new submission
   }
   ```

---

## When to Upgrade to Advanced Forms

Consider upgrading to Advanced Forms when you need:

❌ Simple Forms can't handle:
- Multi-step wizards with navigation
- Conditional field visibility based on other fields
- Complex cross-field validation
- Form state persistence across screens
- Custom lifecycle hooks
- Reusable form logic across multiple screens

✅ Simple Forms work great for:
- Standard forms (login, registration, contact)
- Forms with independent fields
- Basic validation
- Simple success/error handling
- Forms that don't persist state

### Migration Path

See [Advanced Forms Guide - Migration](FORMS_ADVANCED.md#migration-from-simple-forms) for step-by-step instructions.

**Migration time:** 15-30 minutes per form

---

## Troubleshooting

### Form not submitting

**Problem:** Submit button does nothing

**Solutions:**
- Check if validation is passing (form.hasError)
- Verify all required fields are filled
- Check console for validation errors
- Ensure `action` function is async and returns Response

### Validation not working

**Problem:** Validators not showing errors

**Solutions:**
- Verify field names are unique
- Check validator syntax
- Ensure validators are inside `JetValidators.compose([])`
- Try adding `autovalidateMode: AutovalidateMode.always` to JetForm

### State not updating

**Problem:** UI not reflecting form state changes

**Solutions:**
- Ensure you're using `HookConsumerWidget`
- Check that `ref` is passed to `useJetForm`
- Verify you're reading `form.isLoading`, not a local variable

### Type errors

**Problem:** Type mismatch errors

**Solutions:**
- Ensure Request model has `fromJson` factory
- Check field names match model properties
- Verify Response type matches action return type

---

## Next Steps

- ✅ Review [Form Fields Reference](FORM_FIELDS.md) for all field types
- ✅ Check out example app for real-world implementations
- ✅ Learn [Advanced Forms](FORMS_ADVANCED.md) for complex requirements

Happy form building! 🚀

