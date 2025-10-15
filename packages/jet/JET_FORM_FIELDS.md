# Jet Form Fields

Comprehensive documentation for all Jet form field widgets built on top of `flutter_form_builder`.

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [Common Features](#common-features)
- [Available Fields](#available-fields)
  - [JetEmailField](#jetemail field)
  - [JetPasswordField](#jetpasswordfield)
  - [JetPhoneField](#jetphonefield)
  - [JetPinField](#jetpinfield)
  - [JetDateField](#jetdatefield)
  - [JetDropdownField](#jetdropdownfield)
  - [JetCheckboxField](#jetcheckboxfield)
  - [JetTextAreaField](#jettextareafield)
- [Creating Custom Fields](#creating-custom-fields)
- [Best Practices](#best-practices)

## Overview

Jet provides a comprehensive set of pre-built form field widgets that integrate seamlessly with Flutter Form Builder. Each field includes:

- ✅ Built-in validation
- 🎨 Consistent theming
- 🔧 Extensive customization options
- 📱 Platform-aware behavior
- ♿ Accessibility support

## Installation

Form fields are automatically available when you import the Jet framework:

```dart
import 'package:jet/jet_framework.dart';
```

## Common Features

All Jet form fields share these common features:

### Required Parameters
- `name` - Unique identifier for the field in the form

### Common Optional Parameters
- `initialValue` - Pre-filled value
- `validator` - Custom validation function
- `isRequired` - Whether the field is required (default: true for most fields)
- `enabled` - Whether the field is interactive
- `labelText` - Label displayed above the field
- `hintText` - Hint text shown when empty
- `helperText` - Helper text shown below the field
- `filled` - Whether the field has a filled background
- `fillColor` - Background color of the field
- Various border parameters (`border`, `enabledBorder`, `focusedBorder`, etc.)

## Available Fields

### JetEmailField

A specialized text field for email input with built-in email validation.

#### Features
- Email-specific keyboard
- Automatic email validation
- Optional lowercase conversion
- Envelope icon

#### Basic Usage

```dart
JetEmailField(
  name: 'email',
  labelText: 'Email Address',
  hintText: 'Enter your email',
)
```

#### Advanced Usage

```dart
JetEmailField(
  name: 'email',
  labelText: 'Email Address',
  hintText: 'name@example.com',
  toLowerCase: true, // Automatically convert to lowercase
  initialValue: 'user@example.com',
  validator: (value) {
    if (value != null && value.endsWith('@competitor.com')) {
      return 'Competitor emails not allowed';
    }
    return null;
  },
)
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | `String` | required | Field identifier |
| `toLowerCase` | `bool` | `true` | Auto-convert to lowercase |
| `showPrefixIcon` | `bool` | `true` | Show envelope icon |

---

### JetPasswordField

A text field for password input with visibility toggle.

#### Features
- Password visibility toggle
- Password confirmation validation
- Lock icon
- Obscured text by default

#### Basic Usage

```dart
JetPasswordField(
  name: 'password',
  labelText: 'Password',
  hintText: 'Enter your password',
)
```

#### Password Confirmation

```dart
final formKey = GlobalKey<FormBuilderState>();

FormBuilder(
  key: formKey,
  child: Column(
    children: [
      JetPasswordField(
        name: 'password',
        labelText: 'Password',
      ),
      JetPasswordField(
        name: 'confirmPassword',
        labelText: 'Confirm Password',
        formKey: formKey,
        identicalWith: 'password', // Must match 'password' field
      ),
    ],
  ),
)
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | `String` | required | Field identifier |
| `identicalWith` | `String?` | `null` | Field name to match (for confirmation) |
| `formKey` | `GlobalKey<FormBuilderState>?` | `null` | Required when using `identicalWith` |
| `showPrefixIcon` | `bool` | `true` | Show lock icon |
| `obscureText` | `bool` | `true` | Initially obscure text |

---

### JetPhoneField

A text field for phone number input with international support.

#### Features
- Phone-specific keyboard
- International phone validation
- Optional country code prefix
- Configurable min/max length

#### Basic Usage

```dart
JetPhoneField(
  name: 'phone',
  labelText: 'Phone Number',
  hintText: 'Enter your phone',
)
```

#### With Country Code

```dart
JetPhoneField(
  name: 'phone',
  labelText: 'Phone Number',
  countryCode: '+1',
  minLength: 10,
  maxLength: 10,
  allowInternational: false, // Only digits
)
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | `String` | required | Field identifier |
| `countryCode` | `String?` | `null` | Country code prefix (e.g., '+1') |
| `minLength` | `int` | `10` | Minimum phone length |
| `maxLength` | `int` | `15` | Maximum phone length |
| `allowInternational` | `bool` | `true` | Allow international format |

---

### JetPinField

A specialized field for PIN/OTP input using the Pinput package.

#### Features
- Visual PIN boxes
- Customizable length
- Auto-submit on completion
- Haptic feedback (optional)
- Obscure text option

#### Basic Usage

```dart
JetPinField(
  name: 'pin',
  length: 6,
  onCompleted: (pin) {
    print('PIN entered: $pin');
  },
)
```

#### OTP Verification

```dart
JetPinField(
  name: 'otp',
  length: 6,
  obscureText: false,
  autofocus: true,
  closeKeyboardWhenCompleted: true,
  onCompleted: (otp) async {
    await verifyOTP(otp);
  },
)
```

#### Password PIN

```dart
JetPinField(
  name: 'securityPin',
  length: 4,
  obscureText: true,
  hapticFeedback: true,
  onCompleted: (pin) {
    verifySecurityPin(pin);
  },
)
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | `String` | required | Field identifier |
| `length` | `int` | `6` | Number of PIN digits |
| `obscureText` | `bool` | `false` | Hide entered digits |
| `onCompleted` | `ValueChanged<String>?` | `null` | Callback when all digits entered |
| `hapticFeedback` | `bool` | `false` | Enable haptic feedback |
| `closeKeyboardWhenCompleted` | `bool` | `false` | Auto-close keyboard |

---

### JetDateField

A date picker field with customizable format and constraints.

#### Features
- Native date picker
- Customizable date format
- Min/max date constraints
- Calendar icon

#### Basic Usage

```dart
JetDateField(
  name: 'birthdate',
  labelText: 'Date of Birth',
  hintText: 'Select your birthdate',
)
```

#### With Constraints

```dart
JetDateField(
  name: 'appointmentDate',
  labelText: 'Appointment Date',
  firstDate: DateTime.now(), // Can't select past dates
  lastDate: DateTime.now().add(Duration(days: 90)), // Max 90 days ahead
  format: DateFormat('MMM dd, yyyy'), // Custom format
)
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | `String` | required | Field identifier |
| `format` | `DateFormat?` | `DateFormat('yyyy-MM-dd')` | Date display format |
| `firstDate` | `DateTime?` | `null` | Minimum selectable date |
| `lastDate` | `DateTime?` | `null` | Maximum selectable date |
| `inputType` | `InputType` | `InputType.date` | Date, time, or both |

---

### JetDropdownField<T>

A type-safe dropdown field for single selection.

#### Features
- Generic type support
- Expanded by default
- Full-width dropdown
- Type-safe values

#### Basic Usage

```dart
JetDropdownField<String>(
  name: 'country',
  labelText: 'Country',
  hintText: 'Select your country',
  items: [
    DropdownMenuItem(value: 'us', child: Text('United States')),
    DropdownMenuItem(value: 'uk', child: Text('United Kingdom')),
    DropdownMenuItem(value: 'ca', child: Text('Canada')),
  ],
)
```

#### With Custom Objects

```dart
class Country {
  final String code;
  final String name;
  Country(this.code, this.name);
}

JetDropdownField<Country>(
  name: 'country',
  labelText: 'Country',
  items: countries.map((country) => 
    DropdownMenuItem(
      value: country,
      child: Text(country.name),
    ),
  ).toList(),
  onChanged: (country) {
    print('Selected: ${country?.name}');
  },
)
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | `String` | required | Field identifier |
| `items` | `List<DropdownMenuItem<T>>` | required | Dropdown options |
| `isExpanded` | `bool` | `true` | Expand to full width |
| `onChanged` | `ValueChanged<T?>?` | `null` | Callback on selection |

---

### JetCheckboxField

A checkbox or switch field with title and subtitle support.

#### Features
- Checkbox or switch variant
- Title and subtitle
- Custom colors
- Configurable positioning

#### Basic Usage

```dart
JetCheckboxField(
  name: 'terms',
  title: 'I agree to the terms and conditions',
  isRequired: true,
)
```

#### With Subtitle

```dart
JetCheckboxField(
  name: 'newsletter',
  title: 'Subscribe to newsletter',
  subtitle: 'Receive weekly updates and promotions',
  isRequired: false,
)
```

#### Switch Variant

```dart
JetCheckboxField(
  name: 'notifications',
  title: 'Enable notifications',
  subtitle: 'Receive push notifications',
  useSwitch: true,
  activeColor: Colors.green,
)
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | `String` | required | Field identifier |
| `title` | `String` | required | Main label text |
| `subtitle` | `String?` | `null` | Additional description |
| `useSwitch` | `bool` | `false` | Use switch instead of checkbox |
| `activeColor` | `Color?` | `null` | Color when active |
| `controlAffinity` | `ListTileControlAffinity` | `leading` | Position of control |

---

### JetTextAreaField

A multi-line text field with character counter.

#### Features
- Multi-line input
- Character counter (optional)
- Min/max lines
- Max length validation

#### Basic Usage

```dart
JetTextAreaField(
  name: 'description',
  labelText: 'Description',
  hintText: 'Enter a description',
  minLines: 3,
  maxLines: 6,
)
```

#### With Character Limit

```dart
JetTextAreaField(
  name: 'bio',
  labelText: 'Bio',
  hintText: 'Tell us about yourself',
  minLines: 3,
  maxLines: 8,
  maxLength: 500,
  showCharacterCounter: true,
)
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | `String` | required | Field identifier |
| `minLines` | `int` | `3` | Minimum visible lines |
| `maxLines` | `int?` | `6` | Maximum visible lines |
| `maxLength` | `int?` | `null` | Maximum character count |
| `showCharacterCounter` | `bool` | `false` | Display character counter |

---

## Creating Custom Fields

You can create custom form fields using the `JetFieldDecorationMixin` for consistent styling:

```dart
class JetCustomField extends HookWidget with JetFieldDecorationMixin {
  final String name;
  final String? labelText;
  final String hintText;
  
  // Add decoration mixin properties
  @override
  final bool filled;
  @override
  final Color? fillColor;
  // ... other decoration properties
  
  const JetCustomField({
    super.key,
    required this.name,
    this.labelText,
    this.hintText = '',
    this.filled = true,
    this.fillColor,
  });
  
  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      decoration: buildInputDecoration(
        context: context,
        hintText: hintText,
        prefixIcon: Icon(PhosphorIcons.user()),
      ),
    );
  }
}
```

## Best Practices

### 1. Use FormBuilder and FormBuilderState

Always wrap Jet form fields in a `FormBuilder` widget:

```dart
final formKey = GlobalKey<FormBuilderState>();

FormBuilder(
  key: formKey,
  child: Column(
    children: [
      JetEmailField(name: 'email'),
      JetPasswordField(name: 'password'),
    ],
  ),
)
```

### 2. Validate Before Submission

```dart
void handleSubmit() {
  if (formKey.currentState?.saveAndValidate() ?? false) {
    final values = formKey.currentState!.value;
    // Submit form
  } else {
    // Show error message
  }
}
```

### 3. Use Consistent Naming

```dart
// Good
JetEmailField(name: 'email')
JetPasswordField(name: 'password')

// Avoid
JetEmailField(name: 'emailAddress')
JetEmailField(name: 'userEmail')
```

### 4. Leverage Default Validators

Most fields have sensible default validators. Only provide custom validators when needed:

```dart
// Good - uses default email validator
JetEmailField(name: 'email')

// Only if you need custom validation
JetEmailField(
  name: 'email',
  validator: FormBuilderValidators.compose([
    FormBuilderValidators.required(),
    FormBuilderValidators.email(),
    (value) => value?.contains('@company.com') == true 
      ? null 
      : 'Must be a company email',
  ]),
)
```

### 5. Provide Clear Labels and Hints

```dart
JetEmailField(
  name: 'email',
  labelText: 'Email Address', // Clear label
  hintText: 'name@example.com', // Example format
  helperText: 'We will never share your email', // Additional context
)
```

### 6. Handle Errors Gracefully

```dart
JetEmailField(
  name: 'email',
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  },
)
```

### 7. Accessibility

All Jet form fields support accessibility features. Ensure you provide meaningful labels:

```dart
JetDateField(
  name: 'birthdate',
  labelText: 'Date of Birth', // Screen readers will announce this
  helperText: 'Must be at least 18 years old',
)
```

## Complete Example

```dart
class RegistrationForm extends HookConsumerWidget {
  const RegistrationForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());

    return FormBuilder(
      key: formKey,
      child: Column(
        children: [
          // Email
          const JetEmailField(
            name: 'email',
            labelText: 'Email Address',
            hintText: 'name@example.com',
          ),
          const SizedBox(height: 16),
          
          // Password
          JetPasswordField(
            name: 'password',
            labelText: 'Password',
            formKey: formKey,
          ),
          const SizedBox(height: 16),
          
          // Confirm Password
          JetPasswordField(
            name: 'confirmPassword',
            labelText: 'Confirm Password',
            formKey: formKey,
            identicalWith: 'password',
          ),
          const SizedBox(height: 16),
          
          // Phone
          const JetPhoneField(
            name: 'phone',
            labelText: 'Phone Number',
            countryCode: '+1',
          ),
          const SizedBox(height: 16),
          
          // Date of Birth
          JetDateField(
            name: 'birthdate',
            labelText: 'Date of Birth',
            lastDate: DateTime.now(),
          ),
          const SizedBox(height: 16),
          
          // Country
          JetDropdownField<String>(
            name: 'country',
            labelText: 'Country',
            items: const [
              DropdownMenuItem(value: 'us', child: Text('United States')),
              DropdownMenuItem(value: 'uk', child: Text('United Kingdom')),
            ],
          ),
          const SizedBox(height: 16),
          
          // Terms
          const JetCheckboxField(
            name: 'terms',
            title: 'I agree to the terms and conditions',
            isRequired: true,
          ),
          const SizedBox(height: 24),
          
          // Submit Button
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.saveAndValidate() ?? false) {
                final values = formKey.currentState!.value;
                // Handle registration
              }
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
```

## Troubleshooting

### Field not validating
Ensure you call `saveAndValidate()` on the form key:
```dart
formKey.currentState?.saveAndValidate()
```

### Password confirmation not working
Make sure you provide the `formKey` parameter:
```dart
JetPasswordField(
  name: 'confirmPassword',
  formKey: formKey, // Required!
  identicalWith: 'password',
)
```

### Custom validation not firing
Compose validators correctly:
```dart
validator: FormBuilderValidators.compose([
  FormBuilderValidators.required(),
  (value) => customValidation(value),
])
```

## Support

For issues, feature requests, or contributions, please visit the [Jet Framework repository](https://github.com/your-repo/jet).

