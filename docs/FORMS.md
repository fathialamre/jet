# Forms Documentation

## Overview

Jet Forms provides a powerful, type-safe form management system built with **[Flutter Hook](https://pub.dev/packages/flutter_hooks)** and **[Riverpod 3](https://pub.dev/packages/riverpod)** code generation support.

Start with basic `JetForm` and `JetFormState` for manual form management, then explore advanced approaches with hooks and notifiers for more complex scenarios.

**Core Features:**
- Type-safe form state with `Request`/`Response` generics
- 70+ built-in validators with automatic localization
- Rich form field components (text, date/time, dropdowns, chips, sliders, etc.)
- Manual and automated form management approaches
- Lifecycle callbacks (onSuccess, onError, onSubmissionStart, etc.)
- Server-side validation error handling
- Form change detection and reactive state

---

## Table of Contents

1. [Getting Started with JetForm](#1-getting-started-with-jetform)
2. [Validations](#2-validations)
3. [Fields](#3-fields)
4. [Advanced Forms](#4-advanced-forms)
   - [4.1 Form Hook (useJetForm)](#41-form-hook-usejetform)
   - [4.2 Form Notifier (JetFormMixin)](#42-form-notifier-jetformmixin)
5. [Form Change Listener](#5-form-change-listener)
6. [Localization](#6-localization)
7. [Custom Fields](#7-custom-fields)

---

## 1. Getting Started with JetForm

### Overview

`JetForm` is the foundation of Jet's form system. It wraps Flutter's `Form` widget and provides access to `JetFormState` for managing form fields, validation, and submission.

### Basic Usage

At its core, you can use `JetForm` with manual state management:

```dart
import 'package:flutter/material.dart';
import 'package:jet/forms/forms.dart';

class BasicFormExample extends StatefulWidget {
  const BasicFormExample({super.key});

  @override
  State<BasicFormExample> createState() => _BasicFormExampleState();
}

class _BasicFormExampleState extends State<BasicFormExample> {
  // Create a form key to access form state
  final formKey = GlobalKey<JetFormState>();

  void _submitForm() {
    // Validate all fields
    if (formKey.currentState?.saveAndValidate() ?? false) {
      // Get form values
      final values = formKey.currentState!.value;
      
      print('Form submitted with values: $values');
      // Handle form submission (e.g., API call)
    } else {
      print('Form validation failed');
    }
  }

  void _resetForm() {
    formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Form')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: JetForm(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Submit'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _resetForm,
                      child: const Text('Reset'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### JetFormState API

The `GlobalKey<JetFormState>` gives you access to:

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `value` | `Map<String, dynamic>` | Current form values as key-value pairs |
| `fields` | `Map<String, JetFormFieldState>` | All registered form fields |
| `hasChanges` | `bool` | Whether any field differs from initial value |

#### Methods

| Method | Return Type | Description |
|--------|-------------|-------------|
| `saveAndValidate()` | `bool` | Validate all fields and save values |
| `save()` | `void` | Save all field values without validation |
| `validate()` | `bool` | Validate all fields without saving |
| `reset()` | `void` | Reset form to initial state |
| `patchValue(Map<String, dynamic>)` | `void` | Set values for specific fields |

### Accessing Form Values

```dart
// Get all form values
final values = formKey.currentState?.value;
print('Email: ${values?['email']}');
print('Password: ${values?['password']}');

// Get a specific field value
final email = formKey.currentState?.fields['email']?.value;
```

### Setting Form Values Programmatically

```dart
// Set initial values
formKey.currentState?.patchValue({
  'email': 'user@example.com',
  'password': '',
});

// Set a single field value
formKey.currentState?.fields['email']?.didChange('new@example.com');
```

### Setting Initial Values

There are two ways to set initial values in Jet Forms:

#### Option 1: Using `initialValue` on JetForm

Set initial values for all fields at once on the `JetForm` widget:

```dart
final formKey = GlobalKey<JetFormState>();

return JetForm(
  key: formKey,
  initialValue: {
    'email': 'user@example.com',
    'username': 'john_doe',
    'bio': 'Flutter developer',
    'terms': true,
  },
  child: Column(
    children: [
      JetTextField(name: 'email'),
      JetTextField(name: 'username'),
      JetTextField(name: 'bio', maxLines: 3),
      JetCheckbox(name: 'terms', title: const Text('Accept terms')),
    ],
  ),
);
```

**Best for:**
- Loading data from a single source (e.g., API response)
- Setting multiple field values at once
- Dynamic forms where fields might change

#### Option 2: Using `initialValue` on Individual Fields

Set initial values directly on each field:

```dart
final formKey = GlobalKey<JetFormState>();

return JetForm(
  key: formKey,
  child: Column(
    children: [
      JetTextField(
        name: 'email',
        initialValue: 'user@example.com',
      ),
      JetTextField(
        name: 'username',
        initialValue: 'john_doe',
      ),
      JetTextField(
        name: 'bio',
        initialValue: 'Flutter developer',
        maxLines: 3,
      ),
      JetCheckbox(
        name: 'terms',
        initialValue: true,
        title: const Text('Accept terms'),
      ),
    ],
  ),
);
```

**Best for:**
- Static default values
- Field-specific initialization logic
- When each field has a different data source

#### Example: Loading User Data

```dart
class EditProfilePage extends StatelessWidget {
  final User user;
  
  const EditProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<JetFormState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: JetForm(
          key: formKey,
          // Option 1: Set all initial values at form level
          initialValue: {
            'name': user.name,
            'email': user.email,
            'phone': user.phone,
            'bio': user.bio,
            'notifications': user.notificationsEnabled,
          },
          child: Column(
            children: [
              JetTextField(name: 'name'),
              JetTextField(name: 'email'),
              JetTextField(name: 'phone'),
              JetTextField(name: 'bio', maxLines: 3),
              JetSwitch(
                name: 'notifications',
                title: const Text('Enable notifications'),
              ),
              
              const SizedBox(height: 24),
              
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState?.saveAndValidate() ?? false) {
                    final values = formKey.currentState!.value;
                    // Save updated values
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Or with field-level initial values:**

```dart
JetForm(
  key: formKey,
  child: Column(
    children: [
      JetTextField(
        name: 'name',
        initialValue: user.name,
      ),
      JetTextField(
        name: 'email',
        initialValue: user.email,
      ),
      JetTextField(
        name: 'phone',
        initialValue: user.phone,
      ),
      JetTextField(
        name: 'bio',
        initialValue: user.bio,
        maxLines: 3,
      ),
      JetSwitch(
        name: 'notifications',
        initialValue: user.notificationsEnabled,
        title: const Text('Enable notifications'),
      ),
    ],
  ),
)
```

**Important Notes:**
- Don't mix both approaches for the same field - choose one method
- `initialValue` on the field takes precedence over form-level `initialValue`
- Initial values are set only once when the form is created
- To update values after creation, use `patchValue()` or `didChange()`

### Manual Validation

```dart
// Validate without saving
final isValid = formKey.currentState?.validate() ?? false;

// Validate and save
final isValid = formKey.currentState?.saveAndValidate() ?? false;

// Validate a specific field
formKey.currentState?.fields['email']?.validate();

// Set custom error on a field
formKey.currentState?.fields['email']?.invalidate('This email is already registered');
```

### Checking for Changes

```dart
// Check if form has unsaved changes
if (formKey.currentState?.hasChanges ?? false) {
  // Show warning before navigation
  showDialog(...);
}
```

### When to Use Basic JetForm

Use manual `JetForm` management when:
- Building simple forms with straightforward logic
- Learning the form system
- You need complete control over form state
- Forms don't require API integration
- No need for type-safe request/response handling

For more advanced scenarios with API integration and type-safe state management, see [Advanced Forms](#4-advanced-forms).

---

## 2. Validations

### Overview

Jet Forms includes 70+ built-in validators accessible through the `JetValidators` facade. All validators support automatic localization and custom error messages.

### Quick Start

```dart
JetTextField(
  name: 'email',
  validator: JetValidators.compose([
    JetValidators.required(),
    JetValidators.email(),
  ]),
)
```

### Available Validators by Category

#### Core Validators

| Validator | Description | Example |
|-----------|-------------|---------|
| `required()` | Field must have a value | `JetValidators.required()` |
| `equal(value)` | Must equal specific value | `JetValidators.equal(true)` |
| `notEqual(value)` | Must not equal value | `JetValidators.notEqual(0)` |
| `matchField(formKey, field)` | Must match another field | `JetValidators.matchField(formKey, 'password')` |

#### String Validators

| Validator | Description | Example |
|-----------|-------------|---------|
| `minLength(length)` | Minimum string length | `JetValidators.minLength(8)` |
| `maxLength(length)` | Maximum string length | `JetValidators.maxLength(100)` |
| `equalLength(length)` | Exact string length | `JetValidators.equalLength(6)` |
| `match(regex)` | Match regular expression | `JetValidators.match(RegExp(r'^[A-Z]'))` |
| `matchNot(regex)` | Must not match regex | `JetValidators.matchNot(RegExp(r'\d'))` |

#### Network Validators

| Validator | Description | Example |
|-----------|-------------|---------|
| `email()` | Valid email address | `JetValidators.email()` |
| `url()` | Valid URL | `JetValidators.url()` |
| `phoneNumber()` | Valid phone number | `JetValidators.phoneNumber()` |
| `ip()` | Valid IP address | `JetValidators.ip(version: 4)` |

#### Numeric Validators

| Validator | Description | Example |
|-----------|-------------|---------|
| `numeric()` | Must be numeric | `JetValidators.numeric()` |
| `integer()` | Must be integer | `JetValidators.integer()` |
| `min(value)` | Minimum numeric value | `JetValidators.min(0)` |
| `max(value)` | Maximum numeric value | `JetValidators.max(100)` |
| `between(min, max)` | Value in range | `JetValidators.between(18, 65)` |

#### DateTime Validators

| Validator | Description | Example |
|-----------|-------------|---------|
| `dateFuture()` | Date must be in future | `JetValidators.dateFuture()` |
| `datePast()` | Date must be in past | `JetValidators.datePast()` |
| `dateRange(min, max)` | Date in range | `JetValidators.dateRange(minDate: DateTime(2020))` |

#### Boolean Validators

| Validator | Description | Example |
|-----------|-------------|---------|
| `isTrue()` | Must be true | `JetValidators.isTrue()` |
| `isFalse()` | Must be false | `JetValidators.isFalse()` |

#### Identity & Security Validators

| Validator | Description | Example |
|-----------|-------------|---------|
| `password()` | Password strength | `JetValidators.password(minLength: 8)` |

#### Finance Validators

| Validator | Description | Example |
|-----------|-------------|---------|
| `creditCard()` | Valid credit card | `JetValidators.creditCard()` |
| `creditCardCvc()` | Valid CVC code | `JetValidators.creditCardCvc()` |

### Validator Composition

#### Using `compose`

Combine multiple validators (first error is returned):

```dart
JetTextField(
  name: 'username',
  validator: JetValidators.compose([
    JetValidators.required(),
    JetValidators.minLength(3),
    JetValidators.maxLength(20),
    JetValidators.match(
      RegExp(r'^[a-zA-Z0-9_]+$'),
      errorText: 'Username can only contain letters, numbers, and underscores',
    ),
  ]),
)
```

#### Using `or`

Require at least one validator to pass:

```dart
JetTextField(
  name: 'contact',
  decoration: const InputDecoration(
    labelText: 'Email or Phone',
    helperText: 'Enter either email or phone number',
  ),
  validator: JetValidators.or([
    JetValidators.email(),
    JetValidators.phoneNumber(),
  ], errorText: 'Please enter a valid email or phone number'),
)
```

#### Using `conditional`

Apply validator only when condition is met:

```dart
JetTextField(
  name: 'company_name',
  validator: JetValidators.conditional(
    (value) {
      // Only require company name if account type is business
      final accountType = formKey.currentState?.value['account_type'];
      return accountType == 'business';
    },
    JetValidators.required(errorText: 'Company name is required for business accounts'),
  ),
)
```

### Custom Validators

#### Approach 1: Inline Functions

For one-off validators:

```dart
JetTextField(
  name: 'promo_code',
  validator: (value) {
    if (value == null || value.isEmpty) return null;
    
    if (!value.startsWith('PROMO')) {
      return 'Promo code must start with "PROMO"';
    }
    
    return null;
  },
)
```

#### Approach 2: Standalone Reusable Functions

For validators used across multiple forms:

```dart
// lib/shared/validators/app_validators.dart

String? validatePromoCode(String? value) {
  if (value == null || value.isEmpty) return null;
  
  if (!value.startsWith('PROMO')) {
    return 'Promo code must start with "PROMO"';
  }
  
  if (value.length != 10) {
    return 'Promo code must be exactly 10 characters';
  }
  
  return null;
}

String? validateUsername(String? value) {
  if (value == null || value.isEmpty) {
    return 'Username is required';
  }
  
  if (value.length < 3) {
    return 'Username must be at least 3 characters';
  }
  
  if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
    return 'Username can only contain letters, numbers, and underscores';
  }
  
  return null;
}

// Usage:
JetTextField(
  name: 'username',
  validator: validateUsername,
)
```

#### Approach 3: Static Helper Class

For framework-wide validators:

```dart
// lib/shared/validators/app_validators.dart

class AppValidators {
  AppValidators._();

  static FormFieldValidator<String> promoCode({String? errorText}) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      
      if (!value.startsWith('PROMO')) {
        return errorText ?? 'Promo code must start with "PROMO"';
      }
      
      if (value.length != 10) {
        return errorText ?? 'Promo code must be exactly 10 characters';
      }
      
      return null;
    };
  }

  static FormFieldValidator<String> username({String? errorText}) {
    return (value) {
      if (value == null || value.isEmpty) {
        return 'Username is required';
      }
      
      if (value.length < 3) {
        return 'Username must be at least 3 characters';
      }
      
      if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
        return errorText ?? 
            'Username can only contain letters, numbers, and underscores';
      }
      
      return null;
    };
  }

  static FormFieldValidator<String> passwordConfirmation(
    GlobalKey<JetFormState> formKey,
    String passwordFieldName,
  ) {
    return (value) {
      final password = formKey.currentState?.value[passwordFieldName];
      if (value != password) {
        return 'Passwords do not match';
      }
      return null;
    };
  }
}

// Usage:
JetTextField(
  name: 'username',
  validator: AppValidators.username(),
)

JetTextField(
  name: 'promo_code',
  validator: AppValidators.promoCode(
    errorText: 'Invalid promo code format',
  ),
)
```

### Password Confirmation Pattern

```dart
final formKey = GlobalKey<JetFormState>();

return JetForm(
  key: formKey,
  child: Column(
    children: [
      JetPasswordField(
        name: 'password',
        decoration: const InputDecoration(labelText: 'Password'),
        validator: JetValidators.compose([
          JetValidators.required(),
          JetValidators.minLength(8),
        ]),
      ),
      
      const SizedBox(height: 16),
      
      JetPasswordField(
        name: 'password_confirmation',
        decoration: const InputDecoration(labelText: 'Confirm Password'),
        validator: JetValidators.compose([
          JetValidators.required(),
          JetValidators.matchField<String>(
            formKey,
            'password',
            errorText: 'Passwords do not match',
          ),
        ]),
      ),
    ],
  ),
);
```

### Simplified Password Confirmation

Use the built-in helper:

```dart
final formKey = GlobalKey<JetFormState>();

return JetForm(
  key: formKey,
  child: Column(
    children: [
      JetPasswordField.withConfirmation(
        name: 'password',
        formKey: formKey,
        decoration: const InputDecoration(labelText: 'Password'),
        confirmationDecoration: const InputDecoration(
          labelText: 'Confirm Password',
        ),
        validator: JetValidators.minLength(8),
        isRequired: true,
        spacing: 16,
      ),
    ],
  ),
);
```

### Custom Error Messages

Override default error messages:

```dart
JetTextField(
  name: 'email',
  validator: JetValidators.compose([
    JetValidators.required(errorText: 'Please enter your email'),
    JetValidators.email(errorText: 'That doesn\'t look like a valid email'),
  ]),
)
```

---

## 3. Fields

### Overview

Jet Forms provides a comprehensive set of pre-built, customizable form field components that follow Material Design guidelines and integrate seamlessly with the validation system.

### Text Input Fields

#### JetTextField

General-purpose text input field.

```dart
JetTextField(
  name: 'username',
  decoration: const InputDecoration(
    labelText: 'Username',
    hintText: 'Enter your username',
    prefixIcon: Icon(Icons.person),
    helperText: 'Must be at least 3 characters',
  ),
  validator: JetValidators.compose([
    JetValidators.required(),
    JetValidators.minLength(3),
  ]),
  maxLength: 20,
  textCapitalization: TextCapitalization.none,
)
```

**Key Parameters:**
- `name` - Unique field identifier (required)
- `decoration` - Input decoration
- `validator` - Validation function
- `maxLength` - Maximum character count
- `maxLines` - Number of lines (1 for single, >1 for multiline)
- `keyboardType` - Keyboard type
- `textCapitalization` - Capitalization mode
- `onChanged` - Value change callback
- `enabled` - Whether field is enabled
- `initialValue` - Initial value
- `controller` - External TextEditingController

#### JetPasswordField

Password input with visibility toggle.

```dart
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
    JetValidators.password(
      requireUppercase: true,
      requireLowercase: true,
      requireNumbers: true,
      requireSpecialChars: true,
    ),
  ]),
  visibilityIcon: const Icon(Icons.visibility),
  visibilityOffIcon: const Icon(Icons.visibility_off),
)
```

**With Confirmation:**

```dart
final formKey = GlobalKey<JetFormState>();

JetPasswordField.withConfirmation(
  name: 'password',
  formKey: formKey,
  decoration: const InputDecoration(
    labelText: 'Password',
    prefixIcon: Icon(Icons.lock),
  ),
  confirmationDecoration: const InputDecoration(
    labelText: 'Confirm Password',
    prefixIcon: Icon(Icons.lock_outline),
  ),
  validator: JetValidators.minLength(8),
  isRequired: true,
  spacing: 16,
)
```

**Key Parameters:**
- Same as JetTextField, plus:
- `visibilityIcon` - Icon when password is visible
- `visibilityOffIcon` - Icon when password is hidden
- `isRequired` - Auto-add required validator

#### JetPhoneField

Phone number input (numeric only).

```dart
JetPhoneField(
  name: 'phone',
  decoration: const InputDecoration(
    labelText: 'Phone Number',
    hintText: '+1 (555) 123-4567',
    prefixIcon: Icon(Icons.phone),
  ),
  validator: JetValidators.compose([
    JetValidators.required(),
    JetValidators.phoneNumber(),
  ]),
)
```

#### JetPinField

OTP/PIN input using **[Pinput](https://pub.dev/packages/pinput)** package.

```dart
JetPinField(
  name: 'otp',
  length: 6,
  decoration: const InputDecoration(
    labelText: 'Verification Code',
    helperText: 'Enter the 6-digit code sent to your email',
  ),
  onCompleted: (pin) {
    print('OTP entered: $pin');
    // Auto-submit when complete
  },
  validator: JetValidators.compose([
    JetValidators.required(),
    JetValidators.equalLength(6),
  ]),
)
```

**Key Parameters:**
- `length` - Number of PIN digits (default: 4)
- `onCompleted` - Called when all digits entered
- `obscureText` - Hide PIN characters

### Date & Time Pickers

#### JetDateTimePicker

Date, time, or datetime picker.

```dart
// Date only
JetDateTimePicker(
  name: 'birthdate',
  decoration: const InputDecoration(
    labelText: 'Date of Birth',
    prefixIcon: Icon(Icons.cake),
  ),
  inputType: DateTimePickerInputType.date,
  firstDate: DateTime(1900),
  lastDate: DateTime.now(),
  hintText: 'Select your birthdate',
  validator: JetValidators.required(),
)

// Time only
JetDateTimePicker(
  name: 'appointment_time',
  decoration: const InputDecoration(
    labelText: 'Appointment Time',
    prefixIcon: Icon(Icons.access_time),
  ),
  inputType: DateTimePickerInputType.time,
  hintText: 'Select time',
)

// Date and Time
JetDateTimePicker(
  name: 'meeting_datetime',
  decoration: const InputDecoration(
    labelText: 'Meeting Date & Time',
    prefixIcon: Icon(Icons.event),
  ),
  inputType: DateTimePickerInputType.both,
  firstDate: DateTime.now(),
  lastDate: DateTime.now().add(const Duration(days: 365)),
  hintText: 'Select date and time',
)
```

**Key Parameters:**
- `inputType` - `DateTimePickerInputType.date`, `.time`, or `.both`
- `firstDate` - Earliest selectable date
- `lastDate` - Latest selectable date
- `hintText` - Placeholder text
- `initialValue` - Initial DateTime value

#### JetDateRangePicker

Select a date range.

```dart
JetDateRangePicker(
  name: 'vacation_dates',
  decoration: const InputDecoration(
    labelText: 'Vacation Dates',
    prefixIcon: Icon(Icons.flight_takeoff),
    helperText: 'Select start and end dates',
  ),
  firstDate: DateTime.now(),
  lastDate: DateTime.now().add(const Duration(days: 365)),
  hintText: 'Select date range',
  validator: JetValidators.required(),
)
```

### Dropdowns & Selection

#### JetDropdown

Type-safe dropdown select.

```dart
JetDropdown<String>(
  name: 'country',
  decoration: const InputDecoration(
    labelText: 'Country',
    prefixIcon: Icon(Icons.flag),
  ),
  hint: const Text('Select your country'),
  options: const [
    JetFormOption(value: 'us', child: Text('🇺🇸 United States')),
    JetFormOption(value: 'uk', child: Text('🇬🇧 United Kingdom')),
    JetFormOption(value: 'ca', child: Text('🇨🇦 Canada')),
    JetFormOption(value: 'au', child: Text('🇦🇺 Australia')),
  ],
  validator: JetValidators.required(),
  onChanged: (value) {
    print('Selected country: $value');
  },
)
```

**With Custom Type:**

```dart
JetDropdown<Country>(
  name: 'country',
  decoration: const InputDecoration(labelText: 'Country'),
  hint: const Text('Select country'),
  options: [
    JetFormOption(
      value: Country(code: 'us', name: 'United States'),
      child: const Text('🇺🇸 United States'),
    ),
    JetFormOption(
      value: Country(code: 'uk', name: 'United Kingdom'),
      child: const Text('🇬🇧 United Kingdom'),
    ),
  ],
  validator: JetValidators.required(),
)
```

#### JetRadioGroup

Radio button group.

```dart
JetRadioGroup<String>(
  name: 'gender',
  decoration: const InputDecoration(
    labelText: 'Gender',
  ),
  options: const [
    JetFormOption(value: 'male', child: Text('Male')),
    JetFormOption(value: 'female', child: Text('Female')),
    JetFormOption(value: 'other', child: Text('Other')),
    JetFormOption(value: 'prefer_not_to_say', child: Text('Prefer not to say')),
  ],
  direction: Axis.horizontal,  // or Axis.vertical
  validator: JetValidators.required(),
)
```

**Key Parameters:**
- `direction` - `Axis.horizontal` or `Axis.vertical`
- `spacing` - Space between options
- `initialValue` - Initially selected value

### Checkboxes & Switches

#### JetCheckbox

Single checkbox field.

```dart
JetCheckbox(
  name: 'terms',
  title: const Text('I agree to the Terms and Conditions'),
  subtitle: const Text('You must accept to continue'),
  validator: JetValidators.isTrue(
    errorText: 'You must accept the terms to continue',
  ),
)

JetCheckbox(
  name: 'newsletter',
  title: const Text('Subscribe to newsletter'),
  subtitle: const Text('Receive weekly updates and promotions'),
  initialValue: true,
)
```

**Key Parameters:**
- `title` - Main checkbox label
- `subtitle` - Optional subtitle
- `initialValue` - Initial checked state

#### JetCheckboxGroup

Multiple selection with checkboxes.

```dart
JetCheckboxGroup<String>(
  name: 'interests',
  decoration: const InputDecoration(
    labelText: 'Interests',
    helperText: 'Select all that apply',
  ),
  options: const [
    JetFormOption(value: 'sports', child: Text('⚽ Sports')),
    JetFormOption(value: 'music', child: Text('🎵 Music')),
    JetFormOption(value: 'reading', child: Text('📚 Reading')),
    JetFormOption(value: 'gaming', child: Text('🎮 Gaming')),
    JetFormOption(value: 'cooking', child: Text('🍳 Cooking')),
  ],
  initialValue: const ['sports', 'reading'],
  direction: Axis.vertical,
  spacing: 8,
)
```

#### JetSwitch

Switch toggle field.

```dart
JetSwitch(
  name: 'notifications',
  title: const Text('Enable push notifications'),
  subtitle: const Text('Get notified about important updates'),
  initialValue: true,
)

JetSwitch(
  name: 'dark_mode',
  title: const Text('Dark mode'),
  subtitle: const Text('Use dark theme'),
)
```

### Chips

#### JetChoiceChips

Single selection chips.

```dart
JetChoiceChips<String>(
  name: 'account_type',
  decoration: const InputDecoration(
    labelText: 'Account Type',
  ),
  options: const [
    JetFormOption(value: 'personal', child: Text('Personal')),
    JetFormOption(value: 'business', child: Text('Business')),
    JetFormOption(value: 'enterprise', child: Text('Enterprise')),
  ],
  validator: JetValidators.required(),
)
```

#### JetFilterChips

Multiple selection chips.

```dart
JetFilterChips<String>(
  name: 'skills',
  decoration: const InputDecoration(
    labelText: 'Skills',
    helperText: 'Select your technical skills',
  ),
  options: const [
    JetFormOption(value: 'flutter', child: Text('Flutter')),
    JetFormOption(value: 'dart', child: Text('Dart')),
    JetFormOption(value: 'react', child: Text('React')),
    JetFormOption(value: 'node', child: Text('Node.js')),
    JetFormOption(value: 'python', child: Text('Python')),
  ],
  initialValue: const ['flutter', 'dart'],
)
```

### Sliders

#### JetSlider

Single value slider.

```dart
JetSlider(
  name: 'age',
  decoration: const InputDecoration(
    labelText: 'Age',
  ),
  min: 18,
  max: 100,
  divisions: 82,
  initialValue: 25,
  displayValues: SliderDisplayValues.all,  // Show current, min, max
  validator: JetValidators.min(18),
)

JetSlider(
  name: 'volume',
  decoration: const InputDecoration(
    labelText: 'Volume',
  ),
  min: 0,
  max: 100,
  divisions: 20,
  initialValue: 50,
  displayValues: SliderDisplayValues.current,  // Only show current value
)
```

**Display Values Options:**
- `SliderDisplayValues.all` - Show current, min, and max
- `SliderDisplayValues.current` - Show only current value
- `SliderDisplayValues.minMax` - Show only min and max
- `SliderDisplayValues.none` - Hide all values

#### JetRangeSlider

Range selection slider.

```dart
JetRangeSlider(
  name: 'price_range',
  decoration: const InputDecoration(
    labelText: 'Price Range',
    helperText: 'Select your budget range',
  ),
  min: 0,
  max: 1000,
  divisions: 20,
  initialValue: const RangeValues(100, 500),
  displayValues: SliderDisplayValues.all,
)
```

---

## 4. Advanced Forms

### Overview

For complex forms with API integration, business logic, and type-safe state management, Jet provides two advanced approaches:

1. **Form Hook (`useJetForm`)** - Simple approach for single-use forms with hooks
2. **Form Notifier (`JetFormMixin`)** - Complex approach for reusable forms with Riverpod

Both approaches provide:
- Type-safe form state with `Request`/`Response` generics
- Automatic API integration
- Lifecycle callbacks
- Server-side validation error handling
- Loading and error states

---

### 4.1 Form Hook (useJetForm)

#### Overview

The `useJetForm` hook provides a simple, declarative way to create forms directly in your widgets without separate notifier classes. Perfect for simple forms and rapid prototyping.

#### When to Use

Use `useJetForm` when you have:

- **Simple Forms** - Login, contact forms, search filters
- **Single-Use** - Form logic used only in one widget
- **Prototyping** - Quick form implementation during development
- **Co-located Logic** - Form logic that belongs with the UI

#### Basic Example

```dart
@RoutePage()
class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiService = ref.watch(authApiServiceProvider);

    // Create form controller with useJetForm hook
    final form = useJetForm<LoginRequest, LoginResponse>(
      ref: ref,
      decoder: (json) => LoginRequest.fromJson(json),
      action: (request) => apiService.login(request),
      onSuccess: (response, request) {
        context.showToast('Welcome back!');
        context.router.replaceAll([HomeRoute()]);
      },
      onError: (error, stackTrace) {
        context.showToast('Login failed. Please try again.');
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: JetSimpleForm(
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
    );
  }
}
```

#### useJetForm Parameters

```dart
final form = useJetForm<Request, Response>(
  ref: ref,                              // Required: WidgetRef for provider access
  decoder: (json) => Request.fromJson(json),  // Required: Convert form data to request
  action: (request) => api.submit(request),   // Required: Submit action
  
  // Optional lifecycle callbacks
  onSuccess: (response, request) { },    // Called on successful submission
  onError: (error, stackTrace) { },      // Called on any error
  onSubmissionStart: () { },             // Called when submission starts
  onSubmissionError: (error, stackTrace) { },  // Called on submission error only
  onValidationError: (error, stackTrace) { },  // Called on validation error only
);
```

#### Controller API Reference

The `useJetForm` hook returns a `JetFormController` with the following API:

**State Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `formKey` | `GlobalKey<JetFormState>` | Form key for field access |
| `state` | `AsyncFormValue<Request, Response>` | Current form state |
| `isLoading` | `bool` | Whether form is submitting |
| `hasError` | `bool` | Whether form has error |
| `hasValue` | `bool` | Whether form has successful response |
| `isIdle` | `bool` | Whether form is in initial state |
| `request` | `Request?` | Last submitted request data |
| `response` | `Response?` | Last successful response |
| `error` | `Object?` | Last error object |
| `values` | `Map<String, dynamic>?` | Current form values |
| `hasChanges` | `bool` | Whether form has unsaved changes |

**Methods:**

| Method | Return Type | Description |
|--------|-------------|-------------|
| `submit()` | `void` | Validate and submit form |
| `reset()` | `void` | Reset form to initial state |
| `validateForm()` | `bool` | Validate all fields without submitting |
| `validateField(String)` | `void` | Validate specific field |
| `invalidateFields(Map)` | `void` | Set validation errors on fields |
| `save()` | `bool` | Save form state (calls saveAndValidate) |

#### Using JetSimpleForm Widget

`JetSimpleForm` provides automatic layout and submit button:

```dart
JetSimpleForm<Request, Response>(
  form: form,
  submitButtonText: 'Submit',
  fieldSpacing: 16.0,
  children: [
    JetTextField(name: 'field1', ...),
    JetTextField(name: 'field2', ...),
  ],
)
```

#### Manual Form Layout

For more control, use `JetForm` directly:

```dart
return JetForm(
  key: form.formKey,
  child: Column(
    children: [
      JetTextField(
        name: 'email',
        decoration: const InputDecoration(labelText: 'Email'),
        validator: JetValidators.email(),
      ),
      
      const SizedBox(height: 16),
      
      // Custom submit button with loading state
      if (form.isLoading)
        const CircularProgressIndicator()
      else
        ElevatedButton(
          onPressed: form.submit,
          child: const Text('Submit'),
        ),
      
      // Display error message
      if (form.hasError)
        Text(
          form.error.toString(),
          style: const TextStyle(color: Colors.red),
        ),
    ],
  ),
);
```

---

### 4.2 Form Notifier (JetFormMixin)

#### Overview

`JetFormNotifier` and `JetFormMixin` provide a powerful, reusable approach for managing complex forms with business logic, cross-component state sharing, and Riverpod 3 code generation support.

#### When to Use

Use `JetFormNotifier` or `JetFormMixin` when you need:

- **Complex Forms** - Multiple screens, multi-step wizards, or forms with complex business logic
- **Reusability** - Form logic used across multiple widgets or screens
- **Business Logic** - Custom validation, conditional fields, or advanced state management
- **Testability** - Form logic that needs to be unit tested independently
- **Code Generation** - Riverpod 3's `@riverpod` annotation for auto-generated providers

#### Understanding AsyncFormValue

`AsyncFormValue` is a type-safe state container that represents the entire lifecycle of a form submission. It has four states:

**State Types:**

| State | Description | When Used |
|-------|-------------|-----------|
| `AsyncFormValue.idle()` | Initial state, no submission attempted | Form just created or reset |
| `AsyncFormValue.loading()` | Form is being submitted | During API call |
| `AsyncFormValue.data()` | Submission successful | After successful response |
| `AsyncFormValue.error()` | Submission failed | After error occurs |

**State Properties:**

```dart
final formState = ref.watch(loginFormProvider);

// Check state type
formState.isIdle      // true if no submission yet
formState.isLoading   // true during submission
formState.hasValue    // true if submission succeeded
formState.hasError    // true if submission failed

// Access data
formState.request     // The submitted request data (if available)
formState.response    // The response data (if successful)
formState.error       // The error object (if failed)
```

**Example Usage:**

```dart
@RoutePage()
class LoginPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(loginFormProvider);
    final formNotifier = ref.read(loginFormProvider.notifier);

    return Scaffold(
      body: Column(
        children: [
          // Form fields...
          
          // Show different UI based on state
          if (formState.isLoading)
            const CircularProgressIndicator()
          else if (formState.hasError)
            Text(
              'Error: ${formState.error}',
              style: const TextStyle(color: Colors.red),
            )
          else if (formState.hasValue)
            Text('Success! Welcome ${formState.response?.name}')
          else
            ElevatedButton(
              onPressed: formNotifier.submit,
              child: const Text('Login'),
            ),
        ],
      ),
    );
  }
}
```

**State Transitions:**

```
idle → loading → data (success)
                ↓
              error (failure)
```

After an error, you can retry submission which transitions back to `loading`, then either `data` or `error`.

#### JetFormMixin with Riverpod Code Generation

The recommended approach is using `JetFormMixin` with Riverpod's `@riverpod` annotation:

```dart
import 'package:jet/jet.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_form.g.dart';

@riverpod
class LoginForm extends _$LoginForm with JetFormMixin<LoginRequest, LoginResponse> {
  @override
  AsyncFormValue<LoginRequest, LoginResponse> build() {
    // Set lifecycle callbacks
    setLifecycleCallbacks(
      FormLifecycleCallbacks(
        onSuccess: (response, request) {
          // Navigate to home screen
          ref.read(appRouterProvider).push(HomeRoute());
        },
        onSubmissionError: (error, stackTrace) {
          // Show error toast
          dump('Login failed: $error');
        },
      ),
    );

    return const AsyncFormValue.idle();
  }

  @override
  LoginRequest decoder(Map<String, dynamic> json) {
    return LoginRequest.fromJson(json);
  }

  @override
  Future<LoginResponse> action(LoginRequest data) async {
    // Call your API service
    final apiService = ref.read(authApiServiceProvider);
    return await apiService.login(data);
  }
}
```

#### Using the Form Notifier in a Widget

```dart
@RoutePage()
class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the form state
    final formState = ref.watch(loginFormProvider);
    final formNotifier = ref.read(loginFormProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: JetForm(
        key: formNotifier.formKey,
        child: Column(
          children: [
            JetTextField(
              name: 'email',
              decoration: const InputDecoration(labelText: 'Email'),
              validator: JetValidators.compose([
                JetValidators.required(),
                JetValidators.email(),
              ]),
            ),
            JetPasswordField(
              name: 'password',
              decoration: const InputDecoration(labelText: 'Password'),
              validator: JetValidators.required(),
            ),
            
            // Show loading state
            if (formState.isLoading)
              const CircularProgressIndicator()
            else
              JetButton.filled(
                text: 'Login',
                onTap: () => formNotifier.submit(),
              ),
          ],
        ),
      ),
    );
  }
}
```

#### Traditional JetFormNotifier (Without Code Generation)

If you're not using Riverpod code generation, you can extend `JetFormNotifier` directly:

```dart
class LoginFormNotifier extends JetFormNotifier<LoginRequest, LoginResponse> {
  LoginFormNotifier(this.ref);

  final Ref ref;

  @override
  AsyncFormValue<LoginRequest, LoginResponse> build() {
    setLifecycleCallbacks(
      FormLifecycleCallbacks(
        onSuccess: (response, request) {
          ref.read(appRouterProvider).push(HomeRoute());
        },
      ),
    );

    return const AsyncFormValue.idle();
  }

  @override
  LoginRequest decoder(Map<String, dynamic> json) {
    return LoginRequest.fromJson(json);
  }

  @override
  Future<LoginResponse> action(LoginRequest data) async {
    final apiService = ref.read(authApiServiceProvider);
    return await apiService.login(data);
  }
}

// Provider definition
final loginFormProvider = NotifierProvider<LoginFormNotifier, AsyncFormValue<LoginRequest, LoginResponse>>(
  (ref) => LoginFormNotifier(ref),
);
```

#### Form Notifier API Reference

**State Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `state` | `AsyncFormValue<Request, Response>` | Current form state (idle, loading, data, error) |
| `formKey` | `GlobalKey<JetFormState>` | Form key for accessing form fields |
| `isLoading` | `bool` | Whether form is submitting |
| `hasError` | `bool` | Whether form has submission error |
| `hasValue` | `bool` | Whether form has successful response |
| `hasChanges` | `bool` | Whether any field value differs from initial |

**Methods:**

| Method | Description |
|--------|-------------|
| `submit()` | Validate and submit the form |
| `reset()` | Reset form to initial state |
| `validateForm()` | Validate all fields without submitting |
| `validateSingleField(String)` | Validate a specific field |
| `invalidateFormFields(Map)` | Set server-side validation errors |
| `setValue(String, dynamic)` | Programmatically set field value |
| `setValues(Map<String, dynamic>)` | Set multiple field values |

**Required Implementations:**

| Method | Return Type | Description |
|--------|-------------|-------------|
| `decoder(Map<String, dynamic>)` | `Request` | Convert form values to request model |
| `action(Request)` | `Future<Response>` | Submit action (API call) |

**Lifecycle Callbacks:**

```dart
FormLifecycleCallbacks<Request, Response>(
  onSubmissionStart: () {
    // Called when form submission starts
    dump('Form submission started');
  },
  onSuccess: (response, request) {
    // Called on successful submission
    context.showToast('Success!');
  },
  onSubmissionError: (error, stackTrace) {
    // Called on submission error
    dump('Submission error: $error');
  },
  onValidationError: (error, stackTrace) {
    // Called on validation error
    dump('Validation failed');
  },
)
```

#### Advanced Example: Multi-Step Registration

```dart
@riverpod
class RegistrationForm extends _$RegistrationForm 
    with JetFormMixin<RegistrationRequest, RegistrationResponse> {
  
  @override
  AsyncFormValue<RegistrationRequest, RegistrationResponse> build() {
    setLifecycleCallbacks(
      FormLifecycleCallbacks(
        onSuccess: (response, request) {
          // Auto-login after registration
          ref.read(sessionManagerProvider.notifier)
              .authenticateAsUser(session: response.session);
          ref.read(appRouterProvider).replaceAll([HomeRoute()]);
        },
        onSubmissionError: (error, stackTrace) {
          if (error is JetError && error.isValidation) {
            // Handle server-side validation errors
            invalidateFormFields(error.validationErrors);
          }
        },
      ),
    );

    return const AsyncFormValue.idle();
  }

  @override
  RegistrationRequest decoder(Map<String, dynamic> json) {
    return RegistrationRequest.fromJson(json);
  }

  @override
  Future<RegistrationResponse> action(RegistrationRequest data) async {
    final apiService = ref.read(authApiServiceProvider);
    return await apiService.register(data);
  }

  // Custom business logic
  void checkUsernameAvailability(String username) async {
    final apiService = ref.read(authApiServiceProvider);
    final isAvailable = await apiService.checkUsername(username);
    
    if (!isAvailable) {
      invalidateFormFields({
        'username': ['This username is already taken'],
      });
    }
  }

  // Custom field validation
  @override
  List<String> validateField(String fieldName, dynamic value) {
    if (fieldName == 'age') {
      final age = int.tryParse(value?.toString() ?? '');
      if (age != null && age < 18) {
        return ['You must be at least 18 years old'];
      }
    }
    return [];
  }
}
```

#### Server-Side Validation Errors

Handle validation errors from your API:

```dart
@override
Future<RegistrationResponse> action(RegistrationRequest data) async {
  try {
    return await apiService.register(data);
  } catch (error) {
    if (error is DioException && error.response?.statusCode == 422) {
      // Server returned validation errors
      final errors = error.response?.data['errors'] as Map<String, dynamic>?;
      if (errors != null) {
        final fieldErrors = errors.map(
          (key, value) => MapEntry(key, (value as List).cast<String>()),
        );
        invalidateFormFields(fieldErrors);
      }
    }
    rethrow;
  }
}
```

---

## 5. Form Change Listener

### Overview

`JetFormChangeListener` is a widget that rebuilds whenever any form field value changes. This is useful for implementing reactive UIs that respond to form state changes, such as enabling/disabling buttons or showing/hiding conditional fields.

### Use Cases

1. **Form-level changes** - Enable submit button only when form has changes
2. **Field-level changes** - Show/hide fields based on other field values
3. **Real-time validation** - Update UI based on form validity
4. **Unsaved changes warning** - Prompt user before navigation

### Basic Example: Save Button State

```dart
@RoutePage()
class ProfileEditPage extends HookConsumerWidget {
  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formNotifier = ref.read(profileFormProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          // Rebuild when form changes to enable/disable save button
          JetFormChangeListener(
            form: formNotifier,
            builder: (context) {
              return TextButton(
                onPressed: formNotifier.hasChanges
                    ? () => formNotifier.submit()
                    : null,  // Disabled when no changes
                child: const Text('Save'),
              );
            },
          ),
        ],
      ),
      body: JetForm(
        key: formNotifier.formKey,
        child: Column(
          children: [
            JetTextField(
              name: 'name',
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            JetTextField(
              name: 'bio',
              decoration: const InputDecoration(labelText: 'Bio'),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
```

### Conditional Fields Example

```dart
@RoutePage()
class ShippingPage extends HookConsumerWidget {
  const ShippingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formNotifier = ref.read(shippingFormProvider.notifier);

    return JetForm(
      key: formNotifier.formKey,
      child: Column(
        children: [
          JetCheckbox(
            name: 'same_as_billing',
            title: const Text('Shipping address same as billing'),
          ),
          
          // Show/hide shipping fields based on checkbox
          JetFormChangeListener(
            form: formNotifier,
            builder: (context) {
              final formState = formNotifier.formKey.currentState;
              final sameAsBilling = formState?.value['same_as_billing'] == true;
              
              // Hide shipping fields if same as billing
              if (sameAsBilling) {
                return const SizedBox.shrink();
              }
              
              return Column(
                children: [
                  JetTextField(
                    name: 'shipping_address',
                    decoration: const InputDecoration(labelText: 'Shipping Address'),
                    validator: JetValidators.required(),
                  ),
                  JetTextField(
                    name: 'shipping_city',
                    decoration: const InputDecoration(labelText: 'City'),
                    validator: JetValidators.required(),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
```

### Real-time Validation Display

```dart
JetFormChangeListener(
  form: formNotifier,
  builder: (context) {
    final isValid = formNotifier.validateForm();
    
    return Column(
      children: [
        // ... form fields ...
        
        // Show validation status
        Container(
          padding: const EdgeInsets.all(16),
          color: isValid ? Colors.green.shade50 : Colors.red.shade50,
          child: Row(
            children: [
              Icon(
                isValid ? Icons.check_circle : Icons.error,
                color: isValid ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 8),
              Text(
                isValid ? 'Form is valid' : 'Please fix errors',
                style: TextStyle(
                  color: isValid ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  },
)
```

### With useJetForm Hook

```dart
final form = useJetForm<Request, Response>(
  ref: ref,
  decoder: (json) => Request.fromJson(json),
  action: (request) => api.submit(request),
);

// ... 

JetFormChangeListener(
  form: form,  // Pass the controller directly
  builder: (context) {
    return ElevatedButton(
      onPressed: form.hasChanges ? () => form.submit() : null,
      child: const Text('Save Changes'),
    );
  },
)
```

### Unsaved Changes Warning

```dart
@RoutePage()
class FormPage extends HookConsumerWidget {
  const FormPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formNotifier = ref.read(myFormProvider.notifier);

    return WillPopScope(
      onWillPop: () async {
        if (!formNotifier.hasChanges) {
          return true;  // Allow navigation
        }

        // Show confirmation dialog
        final shouldPop = await showAdaptiveConfirmationDialog(
          context: context,
          title: 'Unsaved Changes',
          message: 'You have unsaved changes. Are you sure you want to leave?',
          confirmText: 'Leave',
          cancelText: 'Stay',
        );

        return shouldPop ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Form'),
          actions: [
            JetFormChangeListener(
              form: formNotifier,
              builder: (context) {
                return TextButton(
                  onPressed: formNotifier.hasChanges
                      ? () => formNotifier.submit()
                      : null,
                  child: const Text('Save'),
                );
              },
            ),
          ],
        ),
        body: JetForm(
          key: formNotifier.formKey,
          child: Column(
            children: [
              // ... form fields ...
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 6. Localization

### Overview

Jet Forms includes automatic error message translation for all built-in validators. Error messages are localized based on the app's current locale using `.arb` files.

### Supported Languages

- **English** (`en`) - Default
- **Arabic** (`ar`) - RTL support
- **French** (`fr`)

### How It Works

Validators automatically use localized error messages from the intl files:

```dart
// This validator will show localized error messages
JetTextField(
  name: 'email',
  validator: JetValidators.email(),  // Uses "emailErrorText" from intl_XX.arb
)
```

**English:** "This field requires a valid email address."  
**French:** "Ce champ nécessite une adresse électronique valide."  
**Arabic:** "هذا الحقل يتطلب عنوان بريد إلكتروني صالح."

### Available Error Messages

All built-in validators have localized messages defined in `.arb` files:

| Validator | Message Key | English Default |
|-----------|-------------|-----------------|
| `required()` | `requiredErrorText` | "This field cannot be empty." |
| `email()` | `emailErrorText` | "This field requires a valid email address." |
| `url()` | `urlErrorText` | "This field requires a valid URL address." |
| `phoneNumber()` | `phoneErrorText` | "This field requires a valid phone number." |
| `numeric()` | `numericErrorText` | "Value must be numeric." |
| `integer()` | `integerErrorText` | "This field requires a valid integer." |
| `minLength(n)` | `minLengthErrorText` | "Value must have a length greater than or equal to {minLength}." |
| `maxLength(n)` | `maxLengthErrorText` | "Value must have a length less than or equal to {maxLength}." |
| `min(n)` | `minErrorText` | "Value must be greater than or equal to {min}." |
| `max(n)` | `maxErrorText` | "Value must be less than or equal to {max}." |

See `/packages/jet/lib/forms/localization/l10n/intl_en.arb` for the complete list.

### Adding New Languages

To add support for a new language:

1. **Create a new `.arb` file** in `/packages/jet/lib/forms/localization/l10n/`:

```
intl_es.arb  (Spanish)
intl_de.arb  (German)
intl_ja.arb  (Japanese)
```

2. **Copy the structure** from `intl_en.arb`:

```json
{
  "@@locale": "es",
  "requiredErrorText": "Este campo no puede estar vacío.",
  "emailErrorText": "Este campo requiere una dirección de correo electrónico válida.",
  "urlErrorText": "Este campo requiere una URL válida.",
  ...
}
```

3. **Translate all messages** keeping the same keys and placeholder syntax.

4. **Run code generation:**

```bash
cd packages/jet
flutter pub run intl_utils:generate
```

### Customizing Error Messages

You can override default localized messages with custom text:

```dart
JetTextField(
  name: 'email',
  validator: JetValidators.compose([
    JetValidators.required(errorText: 'Please enter your email'),
    JetValidators.email(errorText: 'Please enter a valid email address'),
  ]),
)
```

### Messages with Placeholders

Some messages use placeholders that are automatically filled:

```dart
JetValidators.minLength(8)
// English: "Value must have a length greater than or equal to 8."
// French: "La valeur doit avoir une longueur supérieure ou égale à 8."

JetValidators.between(18, 65)
// English: "Value must be between 18 and 65."
// French: "La valeur doit être comprise entre 18 et 65."
```

### Accessing Localized Messages Programmatically

```dart
import 'package:jet/forms/localization/intl.dart';

// In a widget:
final localizations = JetFormLocalizations.of(context);
final errorMessage = localizations.requiredErrorText;
```

### Example: Multi-Language Form

```dart
@RoutePage()
class RegistrationPage extends HookConsumerWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = useJetForm<RegistrationRequest, RegistrationResponse>(
      ref: ref,
      decoder: (json) => RegistrationRequest.fromJson(json),
      action: (request) => ref.read(authApiServiceProvider).register(request),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        actions: [
          LanguageSwitcher.toggleButton(),  // Switch language
        ],
      ),
      body: JetSimpleForm(
        form: form,
        submitButtonText: 'Register',
        children: [
          // All error messages will be shown in current app locale
          JetTextField(
            name: 'email',
            decoration: const InputDecoration(labelText: 'Email'),
            validator: JetValidators.compose([
              JetValidators.required(),  // Localized message
              JetValidators.email(),     // Localized message
            ]),
          ),
          
          JetTextField(
            name: 'username',
            decoration: const InputDecoration(labelText: 'Username'),
            validator: JetValidators.compose([
              JetValidators.required(),    // Localized message
              JetValidators.minLength(3),  // Localized message with placeholder
            ]),
          ),
          
          JetPasswordField(
            name: 'password',
            decoration: const InputDecoration(labelText: 'Password'),
            validator: JetValidators.compose([
              JetValidators.required(),    // Localized message
              JetValidators.minLength(8),  // Localized message
            ]),
          ),
        ],
      ),
    );
  }
}
```

---

## 7. Custom Fields

### Overview

You can create custom form fields in two ways:
1. **From Scratch** - Using `JetFormFieldDecoration` base class
2. **By Extension** - Customizing existing fields (e.g., `JetTextField`)

### Approach 1: Creating from Scratch

Use `JetFormFieldDecoration` to create entirely new field types:

```dart
import 'package:flutter/material.dart';
import 'package:jet/forms/core/jet_form_field_decoration.dart';

/// Custom color picker field
class JetColorPicker extends JetFormFieldDecoration<Color> {
  final List<Color> availableColors;

  JetColorPicker({
    super.key,
    required super.name,
    super.validator,
    super.decoration = const InputDecoration(),
    super.onChanged,
    super.enabled = true,
    super.initialValue,
    this.availableColors = const [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ],
  }) : super(
          builder: (FormFieldState<Color?> field) {
            final state = field as _JetColorPickerState;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display current color
                if (state.value != null)
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: state.value,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        'Selected: ${_colorName(state.value!)}',
                        style: TextStyle(
                          color: state.value!.computeLuminance() > 0.5
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 8),

                // Color options
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: availableColors.map((color) {
                    final isSelected = state.value == color;
                    return GestureDetector(
                      onTap: state.enabled
                          ? () => state.didChange(color)
                          : null,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: color,
                          border: Border.all(
                            color: isSelected ? Colors.black : Colors.grey,
                            width: isSelected ? 3 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        );

  static String _colorName(Color color) {
    if (color == Colors.red) return 'Red';
    if (color == Colors.blue) return 'Blue';
    if (color == Colors.green) return 'Green';
    if (color == Colors.yellow) return 'Yellow';
    if (color == Colors.purple) return 'Purple';
    if (color == Colors.orange) return 'Orange';
    return 'Unknown';
  }

  @override
  JetFormFieldDecorationState<JetColorPicker, Color> createState() =>
      _JetColorPickerState();
}

class _JetColorPickerState
    extends JetFormFieldDecorationState<JetColorPicker, Color> {}
```

**Usage:**

```dart
JetColorPicker(
  name: 'theme_color',
  decoration: const InputDecoration(
    labelText: 'Theme Color',
    helperText: 'Select your preferred color',
  ),
  initialValue: Colors.blue,
  validator: JetValidators.required(),
  onChanged: (color) {
    print('Selected color: $color');
  },
)
```

### Approach 2: Extending Existing Fields

Customize existing fields by wrapping them:

```dart
import 'package:flutter/material.dart';
import 'package:jet/forms/forms.dart';

/// Email field with automatic lowercase transformation
class JetEmailField extends StatelessWidget {
  final String name;
  final InputDecoration decoration;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;

  const JetEmailField({
    super.key,
    required this.name,
    this.decoration = const InputDecoration(),
    this.validator,
    this.enabled = true,
    this.initialValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return JetTextField(
      name: name,
      decoration: decoration.copyWith(
        prefixIcon: decoration.prefixIcon ?? const Icon(Icons.email),
      ),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      enableSuggestions: false,
      validator: validator ??
          JetValidators.compose([
            JetValidators.required(),
            JetValidators.email(),
          ]),
      // Transform to lowercase
      valueTransformer: (value) => value?.toString().trim().toLowerCase(),
      onChanged: onChanged,
      enabled: enabled,
      initialValue: initialValue,
    );
  }
}
```

**Usage:**

```dart
JetEmailField(
  name: 'email',
  decoration: const InputDecoration(
    labelText: 'Email Address',
    helperText: 'We\'ll never share your email',
  ),
)
```

### Advanced Custom Field: Star Rating

```dart
import 'package:flutter/material.dart';
import 'package:jet/forms/core/jet_form_field_decoration.dart';

class JetStarRating extends JetFormFieldDecoration<int> {
  final int maxStars;
  final double starSize;
  final Color activeColor;
  final Color inactiveColor;

  JetStarRating({
    super.key,
    required super.name,
    super.validator,
    super.decoration = const InputDecoration(),
    super.onChanged,
    super.enabled = true,
    super.initialValue = 0,
    this.maxStars = 5,
    this.starSize = 40,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
  }) : super(
          builder: (FormFieldState<int?> field) {
            final state = field as _JetStarRatingState;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(maxStars, (index) {
                    final starValue = index + 1;
                    final isActive = (state.value ?? 0) >= starValue;

                    return GestureDetector(
                      onTap: state.enabled
                          ? () => state.didChange(starValue)
                          : null,
                      child: Icon(
                        isActive ? Icons.star : Icons.star_border,
                        size: starSize,
                        color: isActive ? activeColor : inactiveColor,
                      ),
                    );
                  }),
                ),
                if (state.value != null && state.value! > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${state.value} out of $maxStars stars',
                      style: Theme.of(field.context).textTheme.bodySmall,
                    ),
                  ),
              ],
            );
          },
        );

  @override
  JetFormFieldDecorationState<JetStarRating, int> createState() =>
      _JetStarRatingState();
}

class _JetStarRatingState
    extends JetFormFieldDecorationState<JetStarRating, int> {}
```

**Usage:**

```dart
JetStarRating(
  name: 'rating',
  decoration: const InputDecoration(
    labelText: 'Rate this product',
  ),
  maxStars: 5,
  starSize: 36,
  activeColor: Colors.amber,
  inactiveColor: Colors.grey.shade300,
  validator: JetValidators.compose([
    JetValidators.required(),
    JetValidators.min(1),
  ]),
)
```

### Custom Field: Tags Input

```dart
import 'package:flutter/material.dart';
import 'package:jet/forms/core/jet_form_field_decoration.dart';

class JetTagsField extends JetFormFieldDecoration<List<String>> {
  final int? maxTags;
  final String? hintText;

  JetTagsField({
    super.key,
    required super.name,
    super.validator,
    super.decoration = const InputDecoration(),
    super.onChanged,
    super.enabled = true,
    super.initialValue,
    this.maxTags,
    this.hintText = 'Type and press enter',
  }) : super(
          builder: (FormFieldState<List<String>?> field) {
            final state = field as _JetTagsFieldState;
            final tags = state.value ?? [];
            final controller = TextEditingController();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tags display
                if (tags.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tags.map((tag) {
                      return Chip(
                        label: Text(tag),
                        onDeleted: state.enabled
                            ? () {
                                final newTags = List<String>.from(tags)
                                  ..remove(tag);
                                state.didChange(newTags);
                              }
                            : null,
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 8),

                // Input field
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: const OutlineInputBorder(),
                  ),
                  enabled: state.enabled &&
                      (maxTags == null || tags.length < maxTags!),
                  onSubmitted: (value) {
                    if (value.isNotEmpty &&
                        !tags.contains(value) &&
                        (maxTags == null || tags.length < maxTags!)) {
                      final newTags = List<String>.from(tags)..add(value);
                      state.didChange(newTags);
                      controller.clear();
                    }
                  },
                ),
              ],
            );
          },
        );

  @override
  JetFormFieldDecorationState<JetTagsField, List<String>> createState() =>
      _JetTagsFieldState();
}

class _JetTagsFieldState
    extends JetFormFieldDecorationState<JetTagsField, List<String>> {}
```

**Usage:**

```dart
JetTagsField(
  name: 'tags',
  decoration: const InputDecoration(
    labelText: 'Tags',
    helperText: 'Add up to 5 tags',
  ),
  maxTags: 5,
  hintText: 'Type a tag and press enter',
  initialValue: const ['flutter', 'dart'],
  validator: (tags) {
    if (tags == null || tags.isEmpty) {
      return 'Please add at least one tag';
    }
    if (tags.length > 5) {
      return 'Maximum 5 tags allowed';
    }
    return null;
  },
)
```

### Best Practices for Custom Fields

1. **Extend `JetFormFieldDecoration<T>`** - Use the base class for automatic form integration
2. **Define Clear Generic Type** - Specify the value type (e.g., `Color`, `int`, `List<String>`)
3. **Use `state.didChange(value)`** - Update form state when value changes
4. **Respect `state.enabled`** - Disable interactions when field is disabled
5. **Show Validation Errors** - Use `state.decoration` which includes error display
6. **Document Parameters** - Add clear documentation for customization options
7. **Test Thoroughly** - Ensure custom fields work with validation and form submission
8. **Make Reusable** - Design fields to be configurable and reusable

---

## See Also

- [Components](COMPONENTS.md) - Pre-built UI components
- [Networking](NETWORKING.md) - API integration for form submissions
- [Error Handling](ERROR_HANDLING.md) - Handle form submission errors
- [State Management](STATE_MANAGEMENT.md) - Riverpod integration patterns
- [Localization](LOCALIZATION.md) - Multi-language support

---

## Package Dependencies

Jet Forms is built on top of these excellent packages:

- **[flutter_hooks](https://pub.dev/packages/flutter_hooks)** - React-style hooks for Flutter
- **[riverpod](https://pub.dev/packages/riverpod)** v2.4.9 - State management
- **[riverpod_annotation](https://pub.dev/packages/riverpod_annotation)** - Code generation
- **[pinput](https://pub.dev/packages/pinput)** - Beautiful PIN/OTP fields
