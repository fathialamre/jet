# Forms Documentation

## Overview

Jet Forms provides a powerful, type-safe form management system built with **[Flutter Hooks](https://pub.dev/packages/flutter_hooks)** and **[Riverpod 3](https://pub.dev/packages/riverpod)**.

**Two approaches available:**
1. **Simple Forms** (`useJetForm`) - For 80% of use cases
2. **Advanced Forms** (`JetFormNotifier`) - For complex enterprise requirements

**Core Features:**
- ✅ Type-safe form state with `Request`/`Response` generics
- ✅ 70+ built-in validators with automatic localization
- ✅ 15+ rich form field components (text, date/time, dropdowns, chips, sliders, etc.)
- ✅ Lifecycle callbacks (onSuccess, onError, onSubmissionStart, etc.)
- ✅ Server-side validation error handling
- ✅ Form change detection and reactive state
- ✅ Performance optimizations (caching, debouncing, field-specific listeners)

---

## 🎯 Which Approach Should I Use?

### Quick Decision

**Choose Simple Forms if you're building:**
- Login forms
- Registration forms
- Settings pages
- Contact forms
- Profile edit forms
- Any standard form with 3-20 fields

**Choose Advanced Forms if you need:**
- Multi-step wizards (3+ steps)
- Conditional field visibility
- Complex cross-field validation
- Server-side validation with field-specific errors
- Form state persistence
- Custom lifecycle management

**Still unsure?** Start with Simple Forms - you can always migrate later if needed.

---

## 📚 Complete Guides

### [Simple Forms Guide](FORMS_SIMPLE.md)
**Start here if you're new to Jet Forms!**

Learn how to build forms quickly using the `useJetForm` hook. Covers:
- 5-minute quick start
- All form field types with examples
- Validation and error handling
- Common patterns (login, registration, etc.)
- When to upgrade to Advanced Forms

**Perfect for:** 80% of typical app forms

---

### [Advanced Forms Guide](FORMS_ADVANCED.md)
**For complex enterprise requirements**

Deep dive into `JetFormNotifier` and advanced features. Covers:
- When you need Advanced Forms
- JetFormNotifier API reference
- Mixins explained (validation, error handling, lifecycle)
- Multi-step wizards
- Conditional fields
- Complex validation patterns
- Form state management

**Perfect for:** Multi-step forms, complex workflows, enterprise apps

---

### [Form Fields Reference](FORM_FIELDS.md)
**Quick reference for all 15+ field types**

Complete API documentation for all form fields:
- Text inputs (TextField, PasswordField, PhoneField, PinField)
- Date & time pickers
- Dropdowns and selections
- Checkboxes and switches
- Sliders and ranges
- Chips (choice and filter)
- Parameters, validators, and examples

**Works with:** Both Simple and Advanced Forms

---

## Quick Start (5 Minutes)

### 1. Simple Form Example

The fastest way to build a form:

```dart
import 'package:flutter/material.dart';
import 'package:jet/jet.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Create form with useJetForm hook
    final form = useJetForm<LoginRequest, LoginResponse>(
      ref: ref,
      decoder: (json) => LoginRequest.fromJson(json),
      action: (request) async {
        return await apiService.login(request);
      },
      onSuccess: (response, request) {
        context.showToast('Login successful!');
        context.router.push(const HomeRoute());
      },
      onError: (error, stackTrace) {
        context.showToast('Login failed: $error');
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: JetSimpleForm(
        form: form,
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
            const SizedBox(height: 16),
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

// Models
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
    email: json['email'] as String,
    password: json['password'] as String,
  );
}

class LoginResponse {
  final String token;
  final String userId;

  LoginResponse({required this.token, required this.userId});
}
```

**That's it!** 🎉 You have a fully functional form with validation, error handling, and API integration.

📖 **Learn more:** [Simple Forms Guide](FORMS_SIMPLE.md)

---

### 2. Advanced Form Example

For complex requirements:

```dart
import 'package:flutter/material.dart';
import 'package:jet/jet.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_form.g.dart';

// 1. Define the form notifier
@riverpod
class LoginForm extends _$LoginForm with JetFormMixin<LoginRequest, LoginResponse> {
  @override
  AsyncFormValue<LoginRequest, LoginResponse> build() {
    return const AsyncFormIdle();
  }

  @override
  LoginRequest decoder(Map<String, dynamic> json) {
    return LoginRequest.fromJson(json);
  }

  @override
  Future<LoginResponse> action(LoginRequest data) async {
    return await ref.read(apiServiceProvider).login(data);
  }

  // Custom field validation
  @override
  List<String> validateField(String fieldName, dynamic value) {
    if (fieldName == 'email' && !value.toString().contains('@company.com')) {
      return ['Must use company email'];
    }
    return [];
  }
}

// 2. Use in UI
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: JetFormConsumer<LoginRequest, LoginResponse>(
          provider: loginFormProvider,
          builder: (context, ref, form, state) => [
            JetTextField(
              name: 'email',
              decoration: const InputDecoration(
                labelText: 'Company Email',
                prefixIcon: Icon(Icons.email),
              ),
              validator: JetValidators.compose([
                JetValidators.required(),
                JetValidators.email(),
              ]),
            ),
            const SizedBox(height: 16),
            JetPasswordField(
              name: 'password',
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              validator: JetValidators.required(),
            ),
          ],
          onSuccess: (response, request) {
            context.showToast('Login successful!');
            context.router.push(const HomeRoute());
          },
          onError: (error, stackTrace, invalidateFields) {
            context.showToast('Login failed: $error');
          },
        ),
      ),
    );
  }
}
```

📖 **Learn more:** [Advanced Forms Guide](FORMS_ADVANCED.md)

---

## Common Form Fields

Quick examples of the most common field types:

```dart
// Text input
JetTextField(
  name: 'email',
  validator: JetValidators.email(),
)

// Password with visibility toggle
JetPasswordField(
  name: 'password',
  validator: JetValidators.minLength(8),
)

// Dropdown selection
JetDropdown<String>(
  name: 'country',
  options: const [
    JetFormOption(value: 'us', child: Text('United States')),
    JetFormOption(value: 'uk', child: Text('United Kingdom')),
  ],
)

// Checkbox
JetCheckbox(
  name: 'terms',
  title: const Text('I agree to terms'),
  validator: JetValidators.equal(true),
)

// Date picker
JetDateTimePicker(
  name: 'birthdate',
  inputType: DateTimePickerInputType.date,
  lastDate: DateTime.now(),
)

// Slider
JetSlider(
  name: 'age',
  min: 18,
  max: 100,
)
```

📖 **See all fields:** [Form Fields Reference](FORM_FIELDS.md)

---

## Validation

Jet Forms includes 70+ built-in validators:

```dart
// Single validator
JetTextField(
  name: 'email',
  validator: JetValidators.email(),
)

// Multiple validators (all must pass)
            JetTextField(
  name: 'username',
  validator: JetValidators.compose([
    JetValidators.required(),
    JetValidators.minLength(3),
    JetValidators.maxLength(20),
    JetValidators.alphanumeric(),
  ]),
)

// Custom error messages
                  JetTextField(
  name: 'email',
  validator: JetValidators.email(
    errorText: 'Please enter a valid email address',
  ),
)
```

**Validator categories:**
- String validators (required, minLength, maxLength, email, url, etc.)
- Numeric validators (min, max, positive, negative, etc.)
- Date/time validators (dateRange, futureDate, pastDate, etc.)
- Collection validators (minLength, maxLength, contains, etc.)
- Custom validators (compose, conditional, transform, etc.)

📖 **Full validator list:** [Simple Forms Guide - Validation](FORMS_SIMPLE.md#validation)

---

## Form State Management

Both Simple and Advanced forms provide reactive state:

```dart
// Check form state
if (form.isLoading) {
  // Show loading indicator
}

if (form.hasError) {
  // Show error message
  print(form.error);
}

if (form.hasValue) {
  // Form submitted successfully
  print(form.response);
}

// Check if form has changes
if (form.hasChanges) {
  // Show "unsaved changes" warning
}
```

---

## Migration Path

Start with Simple Forms and migrate to Advanced Forms later if needed:

### Before (Simple)
```dart
final form = useJetForm<Request, Response>(...);

JetSimpleForm(
  form: form,
  children: [...],
)
```

### After (Advanced)
```dart
@riverpod
class MyForm extends _$MyForm with JetFormMixin<Request, Response> {
  // Add custom logic here
}

JetFormConsumer(
  provider: myFormProvider,
  builder: (context, ref, form, state) => [...],
  onSuccess: (response, request) { },
  onError: (error, stackTrace, invalidateFields) { },
)
```

**Migration time:** 15-30 minutes per form

📖 **Migration guide:** [Advanced Forms Guide - Migration](FORMS_ADVANCED.md#migration-from-simple-forms)

---

## Performance Optimizations

Jet Forms includes several performance optimizations:

✅ **Cached `hasChanges` computation** - O(1) instead of O(n) on every access
✅ **Smart change notifications** - Only notify when values actually change
✅ **Field-specific change listeners** - Rebuild only affected widgets
✅ **Validation debouncing** - Reduce validation calls during typing
✅ **Validation result caching** - Cache expensive validator results
✅ **Optimized dropdown comparisons** - Efficient list/set operations

**Result:** 70-90% reduction in rebuilds for medium to large forms

📖 **See:** `FORMS_PERFORMANCE_IMPROVEMENTS.md` for benchmarks

---

## Localization

Form validation messages are automatically localized:

```dart
// Supports: English, Arabic, French (extensible)
JetTextField(
  name: 'email',
  validator: JetValidators.email(), // Error message auto-localized
)
```

Add custom translations in your app's localization files.

📖 **Learn more:** [Localization Guide](LOCALIZATION.md)

---

## Best Practices

### ✅ DO

- Start with Simple Forms (`useJetForm`)
- Use `JetValidators.compose()` for multiple validators
- Provide clear field names and labels
- Handle success and error callbacks
- Use type-safe Request/Response models
- Test form validation logic

### ❌ DON'T

- Use Advanced Forms for simple use cases
- Skip validation on required fields
- Ignore error states
- Mix form management approaches in same form
- Forget to handle loading states

---

## Troubleshooting

### Form not submitting
- Check if all required fields are filled
- Verify validators are passing
- Check console for validation errors

### Validation not working
- Ensure field `name` is unique
- Check if validators are properly composed
- Verify field is registered in form

### Performance issues
- Use field-specific change listeners
- Enable validation debouncing
- Check for unnecessary rebuilds

📖 **More help:** See full guides or ask in discussions

---

## Examples

The Jet example app includes comprehensive form examples:

- **Advanced Forms:**
  - `login_page.dart` - Login form using JetFormConsumer
  - `big_form_page.dart` - Large form (25+ fields) with performance optimizations

Run the example app:
```bash
cd example
flutter run
```

---

## API Quick Reference

### Simple Forms
```dart
useJetForm<Request, Response>(...)  // Create form hook
JetSimpleForm(...)                   // Form wrapper widget
JetFormController                    // Form controller class
```

### Advanced Forms
```dart
JetFormNotifier                      // Base notifier class
JetFormMixin                         // Mixin for Riverpod notifiers
JetFormConsumer                      // Form consumer widget (primary)
```

### Shared
```dart
JetForm                              // Core form widget
JetFormState                         // Form state
JetValidators                        // Validation library
JetTextField, JetPasswordField, etc. // Form fields
```

---

## Complete Documentation

- **[Simple Forms Guide](FORMS_SIMPLE.md)** - Start here!
- **[Advanced Forms Guide](FORMS_ADVANCED.md)** - Complex requirements
- **[Form Fields Reference](FORM_FIELDS.md)** - All field types

---

## Need Help?

- Check the guides above
- Review example app code (`example/lib/features/login/` and `example/lib/features/big_form/`)
- Start with Simple Forms and migrate to Advanced Forms if needed
- Open an issue on GitHub

Happy form building! 🚀
