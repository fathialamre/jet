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
- [Form Validation](#form-validation)
  - [Built-in Validators](#built-in-validators)
  - [Creating Custom Validators](#creating-custom-validators)
  - [Composing Validators](#composing-validators)
- [Form Fields](#form-fields)
  - [JetTextField](#jettextfield)
  - [JetEmailField](#jetemailfield)
  - [JetPasswordField](#jetpasswordfield)
  - [JetPhoneField](#jetphonefield)
  - [JetPinField](#jetpinfield)
  - [JetDateField](#jetdatefield)
  - [JetDropdownField](#jetdropdownfield)
  - [JetCheckboxField](#jetcheckboxfield)
  - [JetTextAreaField](#jettextareafield)
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
        child: JetFormBuilder.hook(
          controller: form,
          builder: (context, formKey) => [
            FormBuilderTextField(
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

return JetFormBuilder.hook(
  controller: form,
  builder: (context, formKey) => [
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
class LoginFormWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return JetFormBuilder.advanced(
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

Jet provides two form builder variants, each designed for a specific approach:

### 1. JetFormBuilder.hook - For Simple Forms (useJetForm)

Use this when building simple forms with the `useJetForm` hook inside `HookConsumerWidget`.

**When to use:**
- ✅ Simple forms with inline logic
- ✅ Using useJetForm hook
- ✅ Rapid prototyping
- ✅ No need for separate notifier class
- ✅ Need to use Flutter hooks in builder

```dart
class LoginPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = useJetForm<LoginRequest, User>(
      ref: ref,
      decoder: (json) => LoginRequest.fromJson(json),
      action: (request) async {
        return await ref.read(authServiceProvider).login(request);
      },
      onSuccess: (user, request) {
        context.router.push(DashboardRoute());
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: JetFormBuilder.hook(
        controller: form,
        builder: (context, formKey) {
          // Can use hooks here if needed
          final emailFocus = useFocusNode();
          final passwordFocus = useFocusNode();
          
          return [
            JetEmailField(
              name: 'email',
              focusNode: emailFocus,
              onFieldSubmitted: (_) => passwordFocus.requestFocus(),
            ),
            JetPasswordField(
              name: 'password',
              focusNode: passwordFocus,
            ),
          ];
        },
      ),
    );
  }
}
```

**Features:**
- ✅ Automatic loading states
- ✅ Built-in error handling
- ✅ Default submit button included
- ✅ Hook support in builder
- ✅ Pull-to-refresh support
- ✅ Minimal boilerplate

### 2. JetFormBuilder.advanced - For Complex Forms (Notifier/Mixin)

Use this when building complex forms with `JetFormNotifier` or `JetFormMixin` (Riverpod 3).

**When to use:**
- ✅ Complex business logic
- ✅ Reusable form logic across multiple pages
- ✅ Using JetFormNotifier or JetFormMixin
- ✅ Need to test form logic separately
- ✅ Multiple API calls or complex validation
- ✅ Custom error handling required

```dart
// 1. Create form with JetFormMixin (Riverpod 3)
@riverpod
class LoginForm extends _$LoginForm with JetFormMixin<LoginRequest, User> {
  @override
  AsyncFormValue<LoginRequest, User> build() {
    return const AsyncFormIdle();
  }
  
  @override
  LoginRequest decoder(Map<String, dynamic> json) {
    return LoginRequest.fromJson(json);
  }
  
  @override
  Future<User> action(LoginRequest data) async {
    // Complex validation logic
    if (data.email.isEmpty) {
      throw JetError.validation(errors: {
        'email': ['Email is required']
      });
    }
    
    // Multiple API calls
    final verified = await ref.read(verificationProvider).verify(data.email);
    if (!verified) {
      throw JetError.validation(errors: {
        'email': ['Email not verified']
      });
    }
    
    return await ref.read(authServiceProvider).login(data);
  }
}

// 2. Use in UI with .advanced
class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: JetFormBuilder.advanced(
        provider: loginFormProvider,
        builder: (context, ref, form, state) => [
          JetEmailField(name: 'email'),
          JetPasswordField(name: 'password'),
          
          // Custom submit button
          if (state.isLoading)
            CircularProgressIndicator()
          else
            ElevatedButton(
              onPressed: () => form.submit(),
              child: Text('Sign In'),
            ),
        ],
        onSuccess: (user, request) {
          context.showToast('Welcome ${user.name}!');
          context.router.push(DashboardRoute());
        },
        onError: (error, stackTrace, invalidateFields) {
          if (error is JetError && error.isValidation) {
            // Custom error handling
            invalidateFields(error.errors);
          } else {
            context.showErrorDialog(error.toString());
          }
        },
      ),
    );
  }
}
```

**Features:**
- ✅ Full control over UI and submission
- ✅ No default submit button (build your own)
- ✅ Custom error handling via onError
- ✅ Testable business logic
- ✅ Reusable across app
- ✅ Type-safe with providers

**Comparison:**

| Feature | .hook | .advanced |
|---------|-------|-----------|
| **Use With** | useJetForm | JetFormNotifier/JetFormMixin |
| **Widget Type** | HookConsumerWidget | ConsumerWidget/StatelessWidget |
| **Complexity** | Simple forms | Complex forms |
| **Default Submit Button** | ✅ Included | ❌ Build your own |
| **Error Handling** | ✅ Automatic | ⚠️ Custom required |
| **Hook Support** | ✅ Yes | ❌ No |
| **Reusability** | ⚠️ Limited to one widget | ✅ High - use anywhere |
| **Testing** | ⚠️ Component testing only | ✅ Unit testable |
| **Boilerplate** | ✅ Minimal | ⚠️ More setup |
| **Best For** | Quick forms, prototypes | Production complex forms |

## Form Validation

Jet provides **70+ built-in validators** through `JetValidators`, a type-safe wrapper around **[form_builder_validators](https://pub.dev/packages/form_builder_validators)**. All validators support custom error messages and work seamlessly with Flutter Form Builder.

### Built-in Validators

#### Common Validators

```dart
// Required field
JetValidators.required()

// Email validation
JetValidators.email()

// String length
JetValidators.minLength(3)
JetValidators.maxLength(20)

// Number range
JetValidators.min(18)
JetValidators.max(100)
JetValidators.range(18, 65)

// Equality checks
JetValidators.equal('expected value')
JetValidators.notEqual('forbidden value')
```

#### String Validators

```dart
// Character type validation
JetValidators.alphabetical()       // Only letters
JetValidators.alphanumeric()       // Letters and numbers
JetValidators.numeric()            // Only numbers
JetValidators.lowercase()          // Only lowercase
JetValidators.uppercase()          // Only uppercase

// Pattern matching
JetValidators.match(r'^[A-Z]{2}\d{4}$')  // Regex pattern
JetValidators.contains('substring')       // Contains text
JetValidators.startsWith('prefix')        // Starts with
JetValidators.endsWith('suffix')          // Ends with

// Word count
JetValidators.minWordsCount(10)    // Min words
JetValidators.maxWordsCount(500)   // Max words
JetValidators.wordsCount(10, 500)  // Word range

// Other
JetValidators.singleLine()         // No line breaks
```

#### Number Validators

```dart
// Basic checks
JetValidators.positive()           // Value > 0
JetValidators.negative()           // Value < 0
JetValidators.even()               // Even number
JetValidators.odd()                // Odd number

// Age validation
JetValidators.minAge(18)           // Minimum age
JetValidators.maxAge(65)           // Maximum age

// Type validation
JetValidators.integer()            // Whole number
```

#### Date & Time Validators

```dart
// Date/Time validation
JetValidators.dateTime()           // Valid DateTime
JetValidators.time()               // Valid time string
JetValidators.dateString()         // Valid date string

// Future/Past dates
JetValidators.futureDate()         // Date in future
JetValidators.pastDate()           // Date in past
```

#### Format Validators

```dart
// Internet formats
JetValidators.url()                // Valid URL
JetValidators.email()              // Valid email
JetValidators.ip()                 // IP address (v4 or v6)
JetValidators.phoneNumber()        // Phone number

// Financial formats
JetValidators.creditCard()         // Credit card number
JetValidators.creditCardCVC()      // CVC code
JetValidators.creditCardExpirationDate()  // Expiry date
JetValidators.iban()               // IBAN
JetValidators.bic()                // BIC/SWIFT code

// Data formats
JetValidators.uuid()               // UUID
JetValidators.json()               // Valid JSON
JetValidators.base64()             // Base64 string
JetValidators.colorCode()          // Color code (#RRGGBB)

// Location
JetValidators.latitude()           // Latitude
JetValidators.longitude()          // Longitude
JetValidators.path()               // File/folder path
```

#### Character Validators

```dart
// Character requirements
JetValidators.hasUppercaseChars(atLeast: 1)  // Min uppercase
JetValidators.hasLowercaseChars(atLeast: 1)  // Min lowercase
JetValidators.hasNumericChars(atLeast: 1)    // Min numbers
JetValidators.hasSpecialChars(atLeast: 1)    // Min special chars
```

#### Password Validators

```dart
// Composite password validators
JetValidators.strongPassword(minLength: 8)
// Requires: 8+ chars, uppercase, lowercase, number, special char

JetValidators.mediumPassword(minLength: 6)
// Requires: 6+ chars, uppercase, lowercase, number

// Individual password checks
JetValidators.hasMinLength(8)     // Alias for minLength
JetValidators.matchValue('password')  // Match another field
```

#### List Validators

```dart
// List/Array validation
JetValidators.notEmpty<T>()        // List not empty
JetValidators.minListLength<T>(3)  // Min items
JetValidators.maxListLength<T>(10) // Max items
```

#### File Validators

```dart
// File validation
JetValidators.fileSize(5 * 1024 * 1024)  // Max 5MB
JetValidators.fileExtension(['.pdf', '.doc', '.docx'])
```

#### Boolean Validators

```dart
// Boolean validation
JetValidators.mustBeTrue()         // Must be checked
JetValidators.mustBeFalse()        // Must be unchecked
```

#### Logic Validators

```dart
// Composite logic
JetValidators.compose([            // AND logic (all must pass)
  JetValidators.required(),
  JetValidators.minLength(3),
])

JetValidators.or([                 // OR logic (any must pass)
  JetValidators.email(),
  JetValidators.phoneNumber(),
])

JetValidators.conditional(         // Conditional validation
  validator: JetValidators.required(),
  condition: () => someCondition,
)
```

### Creating Custom Validators

There are three approaches to create custom validators, each suited for different scenarios.

#### Approach 1: Using JetValidators.custom() ⚡

Perfect for **quick inline validators** that are used in a single place.

```dart
JetTextField(
  name: 'promo_code',
  validator: JetValidators.custom<String>(
    (value) => value?.toUpperCase().startsWith('JET') ?? false,
    errorText: 'Promo code must start with JET',
  ),
)
```

**Pros:**
- ✅ Zero boilerplate
- ✅ Perfect for simple, one-off validations
- ✅ Easy to read inline

**Cons:**
- ❌ Not reusable
- ❌ Hard to test in isolation

#### Approach 2: Standalone Validator Function 🔄

Perfect for **reusable validators** across your app.

```dart
// Define once
FormFieldValidator<String> promoCodeValidator({
  String? errorText,
  String prefix = 'JET',
  int length = 10,
}) {
  return (String? value) {
    if (value == null || value.isEmpty) return null;
    
    if (!value.toUpperCase().startsWith(prefix)) {
      return errorText ?? 'Promo code must start with $prefix';
    }
    
    if (value.length != length) {
      return 'Promo code must be $length characters';
    }
    
    return null; // Valid
  };
}

// Use anywhere
JetTextField(
  name: 'promo_code',
  validator: promoCodeValidator(prefix: 'SUMMER', length: 12),
)
```

**Pros:**
- ✅ Reusable across app
- ✅ Easy to test
- ✅ Configurable with parameters

**Cons:**
- ❌ Requires separate file/class

#### Approach 3: Static Helper Class 🏢

Perfect for **framework-wide validators** used throughout your application.

```dart
// lib/core/validators/app_validators.dart
class AppValidators {
  /// Validates location ID format (e.g., "US-CA-12345")
  static FormFieldValidator<String> locationId({
    String? errorText,
    List<String> allowedCountries = const ['US', 'CA', 'UK'],
  }) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;
      
      // Split by hyphen
      final parts = value.split('-');
      
      if (parts.length != 3) {
        return errorText ?? 
          'Format must be COUNTRY-STATE-ID (e.g., US-CA-12345)';
      }
      
      // Validate country code
      if (!allowedCountries.contains(parts[0])) {
        return 'Country must be: ${allowedCountries.join(", ")}';
      }
      
      // Validate state code (2 letters)
      if (!RegExp(r'^[A-Z]{2}$').hasMatch(parts[1])) {
        return 'State must be 2 uppercase letters';
      }
      
      // Validate ID (5 digits)
      if (!RegExp(r'^\d{5}$').hasMatch(parts[2])) {
        return 'ID must be 5 digits';
      }
      
      return null;
    };
  }
  
  /// Validates strong password with custom rules
  static FormFieldValidator<String> customStrongPassword({
    int minLength = 10,
    bool requireSymbol = true,
    bool requireNumber = true,
  }) {
    return JetValidators.compose([
      JetValidators.required(),
      JetValidators.hasMinLength(minLength),
      JetValidators.hasUppercaseChars(),
      JetValidators.hasLowercaseChars(),
      if (requireNumber) JetValidators.hasNumericChars(),
      if (requireSymbol) JetValidators.hasSpecialChars(),
    ]);
  }
}

// Use throughout app
JetTextField(
  name: 'location',
  validator: AppValidators.locationId(
    allowedCountries: ['US', 'CA'],
  ),
)
```

**Pros:**
- ✅ Consistent across entire app
- ✅ Easy to maintain and update
- ✅ Centralized validation logic
- ✅ Easy to test

**Cons:**
- ❌ More initial setup

### Composing Validators

Combine multiple validators for complex validation rules.

#### Basic Composition (AND Logic)

All validators must pass:

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

#### OR Logic

At least one validator must pass:

```dart
JetTextField(
  name: 'contact',
  labelText: 'Email or Phone',
  validator: JetValidators.or([
    JetValidators.email(),
    JetValidators.phoneNumber(),
  ], errorText: 'Enter a valid email or phone number'),
)
```

#### Conditional Validation

Validate only when a condition is met:

```dart
final agreeToTerms = useState(false);

JetTextField(
  name: 'referral_code',
  validator: JetValidators.conditional(
    validator: JetValidators.required(),
    condition: () => agreeToTerms.value,
  ),
)
```

#### Complex Example: Username Validation

```dart
JetTextField(
  name: 'username',
  validator: JetValidators.compose([
    JetValidators.required(errorText: 'Username is required'),
    JetValidators.minLength(3, errorText: 'Too short (min 3)'),
    JetValidators.maxLength(20, errorText: 'Too long (max 20)'),
    JetValidators.match(
      r'^[a-zA-Z0-9_]+$',
      errorText: 'Only letters, numbers, and underscores',
    ),
    JetValidators.custom<String>(
      (value) => !value!.startsWith('_'),
      errorText: 'Cannot start with underscore',
    ),
    JetValidators.custom<String>(
      (value) => !['admin', 'root', 'system'].contains(value),
      errorText: 'Username not available',
    ),
  ]),
)
```

### Password Confirmation

Use `matchValue` or `identicalWith` for password confirmation:

```dart
final formKey = GlobalKey<FormBuilderState>();

FormBuilder(
  key: formKey,
  child: Column(
    children: [
      JetPasswordField(
        name: 'password',
        labelText: 'Password',
        formKey: formKey,
      ),
      JetPasswordField(
        name: 'confirm_password',
        labelText: 'Confirm Password',
        identicalWith: 'password',
        formKey: formKey,
      ),
    ],
  ),
)
```

### Validation Best Practices

#### 1. Provide Clear Error Messages

```dart
// Good
JetValidators.minLength(8, errorText: 'Password must be at least 8 characters')

// Bad
JetValidators.minLength(8)  // Generic error message
```

#### 2. Validate on Field Level, Not Form Level

```dart
// Good
JetEmailField(
  name: 'email',
  validator: JetValidators.compose([
    JetValidators.required(),
    JetValidators.email(),
  ]),
)

// Avoid - hard to show which field has error
void validateForm() {
  if (email.isEmpty || !email.contains('@')) {
    showError('Invalid form');
  }
}
```

#### 3. Use Composition for Complex Rules

```dart
// Good - clear and reusable
final passwordValidator = JetValidators.compose([
  JetValidators.hasMinLength(8),
  JetValidators.hasUppercaseChars(),
  JetValidators.hasNumericChars(),
]);

// Avoid - hard to read and maintain
final passwordValidator = (String? value) {
  if (value == null || value.length < 8) return 'Too short';
  if (!value.contains(RegExp(r'[A-Z]'))) return 'Need uppercase';
  if (!value.contains(RegExp(r'[0-9]'))) return 'Need number';
  return null;
};
```

#### 4. Return null for Valid Values

```dart
FormFieldValidator<String> customValidator() {
  return (String? value) {
    if (value == null || value.isEmpty) return null;  // Allow empty
    
    if (/* validation fails */) {
      return 'Error message';
    }
    
    return null;  // ✅ Valid - must return null
  };
}
```

## Form Fields

Jet provides specialized input components with built-in validation, consistent styling, and enhanced functionality.

### JetTextField

General text input for any text data.

```dart
JetTextField(
  name: 'username',
  labelText: 'Username',
  hintText: 'Enter your username',
  minLength: 3,
  maxLength: 20,
  validator: JetValidators.username(),
)
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `name` | String | Form field identifier (required) |
| `labelText` | String? | Label displayed above field |
| `hintText` | String? | Placeholder text |
| `keyboardType` | TextInputType | Keyboard type (text, number, etc.) |
| `textCapitalization` | TextCapitalization | Auto-capitalize behavior |
| `obscureText` | bool | Hide text (for passwords) |
| `maxLength` | int? | Maximum character count |
| `minLength` | int? | Minimum character count |
| `trimWhitespace` | bool | Auto-trim whitespace (default: true) |
| `validator` | FormFieldValidator? | Validation function |
| `valueTransformer` | Function? | Transform value before submission |

### JetEmailField

Email input with built-in validation.

```dart
JetEmailField(
  name: 'email',
  labelText: 'Email Address',
  hintText: 'name@example.com',
  toLowerCase: true,
  isRequired: true,
)
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `toLowerCase` | bool | Auto-convert to lowercase (default: true) |
| `showPrefixIcon` | bool | Show envelope icon (default: true) |
| `isRequired` | bool | Add required validation (default: false) |

### JetPasswordField

Password input with built-in show/hide toggle functionality using Flutter hooks. The field automatically manages password visibility state and provides an eye icon to toggle between visible and obscured text.

```dart
// Basic password field with auto show/hide toggle
JetPasswordField(
  name: 'password',
  decoration: const InputDecoration(
    labelText: 'Password',
    hintText: 'Enter your password',
    prefixIcon: Icon(Icons.lock),
  ),
  validator: JetValidators.compose([
    JetValidators.required(),
    JetValidators.minLength(8),
  ]),
)

// Password with custom visibility icons
JetPasswordField(
  name: 'password',
  decoration: const InputDecoration(
    labelText: 'Password',
    prefixIcon: Icon(Icons.lock),
  ),
  visibilityIcon: const Icon(Icons.visibility_outlined),
  visibilityOffIcon: const Icon(Icons.visibility_off_outlined),
  validator: JetValidators.password(),
)

// Password confirmation (use Equal validator)
JetPasswordField(
  name: 'confirm_password',
  decoration: const InputDecoration(
    labelText: 'Confirm Password',
    prefixIcon: Icon(Icons.lock),
  ),
  validator: (value) {
    if (value != formState.getValue('password')) {
      return 'Passwords do not match';
    }
    return null;
  },
)
```

**Key Features:**
- ✅ Built-in show/hide toggle with eye icon
- ✅ Uses Flutter hooks for state management
- ✅ Customizable visibility icons
- ✅ Auto-configured for password input (disabled autocorrect, suggestions)
- ✅ Supports all TextField parameters
- ✅ Autofill hints pre-configured for password managers

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `name` | String | Form field identifier (required) |
| `decoration` | InputDecoration | Field decoration (label, hint, etc.) |
| `validator` | FormFieldValidator? | Validation function |
| `visibilityIcon` | Icon? | Icon shown when password is visible |
| `visibilityOffIcon` | Icon? | Icon shown when password is hidden |
| `obscuringCharacter` | String | Character for obscuring text (default: '•') |
| `keyboardType` | TextInputType? | Keyboard type (default: visiblePassword) |
| `autocorrect` | bool | Enable autocorrect (default: false) |
| `enableSuggestions` | bool | Show suggestions (default: false) |
| `autofillHints` | Iterable? | Autofill hints (default: [AutofillHints.password]) |

**All TextField Parameters Supported:**
The JetPasswordField extends JetFormFieldDecoration and supports all standard TextField parameters including:
- `controller`, `focusNode`, `style`, `textAlign`, `maxLength`
- `inputFormatters`, `cursorColor`, `readOnly`, `enabled`
- And all other TextField properties

### JetPhoneField

Phone number input with automatic numeric-only validation and keyboard. This field restricts input to digits only and automatically uses the phone keyboard.

```dart
// Basic phone field with required validation
JetPhoneField(
  name: 'phone',
  decoration: const InputDecoration(
    labelText: 'Phone Number',
    hintText: 'Enter your phone number',
  ),
  isRequired: true,
)

// With custom length validation
JetPhoneField(
  name: 'phone',
  decoration: const InputDecoration(
    labelText: 'Phone Number',
  ),
  isRequired: true,
  minLength: 10,
  maxPhoneLength: 15,
)

// With custom validator
JetPhoneField(
  name: 'phone',
  decoration: const InputDecoration(
    labelText: 'Phone Number',
  ),
  isRequired: true,
  validator: (value) {
    if (value != null && value.startsWith('0')) {
      return 'Phone number should not start with 0';
    }
    return null;
  },
)
```

**Key Features:**
- 📱 Automatically uses numeric keyboard (`TextInputType.phone`)
- 🔢 Restricts input to digits only using `FilteringTextInputFormatter.digitsOnly`
- ✅ Built-in numeric validation
- 📏 Optional minimum/maximum length validation
- ⚡ Quick `isRequired` parameter for convenience

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `name` | String | Form field identifier (required) |
| `isRequired` | bool | Automatically adds required validator (default: false) |
| `minLength` | int? | Minimum phone number length |
| `maxPhoneLength` | int? | Maximum phone number length |
| `decoration` | InputDecoration | Field decoration (label, hint, etc.) |
| `validator` | FormFieldValidator? | Additional custom validation |
| `keyboardType` | TextInputType? | Keyboard type (default: phone) |
| `inputFormatters` | List? | Additional input formatters (digits-only is always applied first) |
| `autofillHints` | Iterable? | Autofill hints (default: [AutofillHints.telephoneNumber]) |

**All TextField Parameters Supported:**
The JetPhoneField extends JetFormFieldDecoration and supports all standard TextField parameters including:
- `controller`, `focusNode`, `style`, `textAlign`, `maxLength`
- `cursorColor`, `readOnly`, `enabled`, `onChanged`
- And all other TextField properties

### JetPinField

PIN/OTP input field using the [Pinput](https://pub.dev/packages/pinput) package. Provides a beautiful, customizable PIN/OTP input experience with individual boxes for each digit.

```dart
// Basic PIN input
JetPinField(
  name: 'otp',
  length: 6,
  decoration: const InputDecoration(
    labelText: 'Enter OTP',
    helperText: 'Check your email for the code',
  ),
  onCompleted: (pin) {
    print('PIN entered: $pin');
    verifyOTP(pin);
  },
  validator: JetValidators.compose([
    JetValidators.required(),
    JetValidators.exactLength(6),
  ]),
)

// Obscured PIN with custom styling
JetPinField(
  name: 'pin',
  length: 4,
  obscureText: true,
  hapticFeedback: true,
  closeKeyboardWhenCompleted: true,
  defaultPinTheme: PinTheme(
    width: 60,
    height: 60,
    textStyle: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300, width: 2),
    ),
  ),
  focusedPinTheme: PinTheme(
    width: 60,
    height: 60,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.blue, width: 2),
    ),
  ),
  onCompleted: (pin) {
    verifyPIN(pin);
  },
)

// With separator
JetPinField(
  name: 'code',
  length: 6,
  separatorBuilder: (index) => const SizedBox(width: 8),
  decoration: const InputDecoration(
    labelText: 'Verification Code',
  ),
)
```

**Key Features:**
- ✅ Beautiful animated PIN/OTP input boxes
- ✅ Customizable themes for each state (default, focused, submitted, error)
- ✅ Haptic feedback support
- ✅ Obscure text option for passwords
- ✅ Auto-close keyboard on completion
- ✅ Separator customization between boxes
- ✅ Full integration with Jet form validation

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `name` | String | Form field identifier (required) |
| `length` | int | Number of PIN digits (default: 6) |
| `obscureText` | bool | Hide entered digits (default: false) |
| `obscuringCharacter` | String | Character for obscuring (default: '•') |
| `onCompleted` | ValueChanged<String>? | Callback when all digits entered |
| `hapticFeedback` | bool | Enable haptic feedback (default: false) |
| `closeKeyboardWhenCompleted` | bool | Auto-close keyboard (default: false) |
| `defaultPinTheme` | PinTheme? | Default theme for PIN boxes |
| `focusedPinTheme` | PinTheme? | Theme for focused PIN box |
| `submittedPinTheme` | PinTheme? | Theme for submitted PIN box |
| `errorPinTheme` | PinTheme? | Theme for PIN box with error |
| `separatorBuilder` | Widget Function(int)? | Builder for separator between boxes |
| `showCursor` | bool | Show cursor (default: true) |
| `autofocus` | bool | Auto-focus field (default: false) |
| `decoration` | InputDecoration? | Field label and helper text |
| `customErrorBuilder` | Widget Function(String?)? | Custom error widget builder |
| `errorTextStyle` | TextStyle? | Error text style |

**Advanced Features:**
- Custom cursor widget
- Pre-filled widget support
- Keyboard appearance customization
- Input formatters
- Autofill hints
- Context menu builder support

### JetDateField

Date picker with customizable format.

```dart
JetDateField(
  name: 'birthdate',
  labelText: 'Date of Birth',
  format: DateFormat('MMM dd, yyyy'),
  firstDate: DateTime(1900),
  lastDate: DateTime.now(),
  isRequired: true,
)
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `format` | DateFormat? | Date display format |
| `firstDate` | DateTime? | Minimum selectable date |
| `lastDate` | DateTime? | Maximum selectable date |
| `inputType` | InputType | Date, time, or both |

### JetDropdownField

Type-safe dropdown selection.

```dart
JetDropdownField<String>(
  name: 'country',
  labelText: 'Country',
  items: [
    DropdownMenuItem(value: 'us', child: Text('United States')),
    DropdownMenuItem(value: 'uk', child: Text('United Kingdom')),
    DropdownMenuItem(value: 'ca', child: Text('Canada')),
  ],
  isRequired: true,
)
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `items` | List | Dropdown options |
| `isExpanded` | bool | Expand to full width (default: true) |
| `onChanged` | Function? | Callback on selection |

### JetCheckboxField

Checkbox or switch with title and subtitle.

```dart
// Checkbox
JetCheckboxField(
  name: 'terms',
  title: 'I agree to the terms and conditions',
  subtitle: 'By checking this box, you accept our terms',
  isRequired: true,
)

// Switch variant
JetCheckboxField(
  name: 'notifications',
  title: 'Enable notifications',
  useSwitch: true,
  activeColor: Colors.green,
)
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `title` | String | Main label text |
| `subtitle` | String? | Additional description |
| `useSwitch` | bool | Use switch instead of checkbox (default: false) |
| `activeColor` | Color? | Color when active |

### JetTextAreaField

Multi-line text input.

```dart
JetTextAreaField(
  name: 'description',
  labelText: 'Description',
  minLines: 3,
  maxLines: 6,
  maxLength: 500,
  showCharacterCounter: true,
)
```

**Key Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `minLines` | int | Minimum visible lines (default: 3) |
| `maxLines` | int | Maximum visible lines (default: 6) |
| `maxLength` | int? | Maximum character count |
| `showCharacterCounter` | bool | Display character counter (default: false) |

### Common Field Features

#### Value Transformers

All fields support `valueTransformer` for preprocessing data:

```dart
JetTextField(
  name: 'username',
  valueTransformer: (value) => value?.trim().toLowerCase(),
)
```

#### Custom Validation

Fields can have custom validation in addition to built-in:

```dart
JetEmailField(
  name: 'email',
  validator: JetValidators.compose([
    JetValidators.required(),
    JetValidators.email(),
    (value) => value?.contains('@company.com') == true 
      ? null 
      : 'Must be a company email',
  ]),
)
```

#### Styling

All fields support extensive styling options:

```dart
JetTextField(
  name: 'field',
  filled: true,
  fillColor: Colors.grey[100],
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.blue, width: 2),
  ),
)
```

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
        child: JetFormBuilder.hook(
          controller: form,
          builder: (context, formKey) => [
            FormBuilderTextField(
              name: 'name',
              decoration: const InputDecoration(
                labelText: 'Your Name',
                prefixIcon: Icon(Icons.person),
              ),
              validator: JetValidators.required(),
            ),
            FormBuilderTextField(
              name: 'email',
              decoration: const InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email),
              ),
              validator: JetValidators.compose([
                JetValidators.required(),
                JetValidators.email(),
              ]),
            ),
            FormBuilderTextField(
              name: 'message',
              decoration: const InputDecoration(
                labelText: 'Message',
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              validator: JetValidators.compose([
                JetValidators.required(),
                JetValidators.minLength(20),
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
      body: JetFormBuilder.advanced(
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

### JetFormBuilder.hook

```dart
JetFormBuilder.hook<Request, Response>({
  required JetFormController<Request, Response> controller,
  required List<Widget> Function(BuildContext, GlobalKey<FormBuilderState>) builder,
  String? submitButtonText,
  bool showSubmitButton = true,
  double fieldSpacing = 16,
  Map<String, dynamic> initialValues = const {},
  Widget? submitButton,
})
```

**Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `controller` | `JetFormController` | Yes | Form controller from useJetForm |
| `builder` | `Function` | Yes | Builder function that returns list of widgets |
| `submitButtonText` | `String?` | No | Text for submit button (default: 'Submit') |
| `showSubmitButton` | `bool` | No | Show default submit button (default: true) |
| `fieldSpacing` | `double` | No | Space between fields (default: 16) |
| `initialValues` | `Map` | No | Initial form field values |
| `submitButton` | `Widget?` | No | Custom submit button widget |

### JetFormBuilder.advanced

```dart
JetFormBuilder.advanced<Request, Response>({
  required AutoDisposeNotifierProvider provider,
  required List<Widget> Function(BuildContext, WidgetRef, FormNotifier, AsyncFormValue) builder,
  void Function(Response, Request)? onSuccess,
  void Function(Object, StackTrace, Function)? onError,
  Map<String, dynamic> initialValues = const {},
  bool enablePullToRefresh = false,
})
```

**Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `provider` | `Provider` | Yes | JetFormNotifier or JetFormMixin provider |
| `builder` | `Function` | Yes | Builder function with form state access |
| `onSuccess` | `Function?` | No | Called when form submission succeeds |
| `onError` | `Function?` | No | Called when form submission fails |
| `initialValues` | `Map` | No | Initial form field values |
| `enablePullToRefresh` | `bool` | No | Enable pull-to-refresh (default: false) |

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

- [Error Handling Documentation](ERROR_HANDLING.md) - JetError and validation errors
- [State Management Documentation](STATE_MANAGEMENT.md) - Riverpod integration
- [Components Documentation](COMPONENTS.md) - UI components and buttons

