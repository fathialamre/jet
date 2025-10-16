# Form Fields Reference

Complete reference for all Jet form field components. All fields work with both Simple and Advanced Forms.

---

## Table of Contents

1. [Text Input Fields](#text-input-fields)
2. [Date & Time Pickers](#date--time-pickers)
3. [Selection Fields](#selection-fields)
4. [Boolean Fields](#boolean-fields)
5. [Slider Fields](#slider-fields)
6. [Chip Fields](#chip-fields)
7. [Common Parameters](#common-parameters)
8. [Validators Reference](#validators-reference)

---

## Text Input Fields

### JetTextField

General-purpose text input field.

**Example:**
```dart
JetTextField(
  name: 'username',
  decoration: const InputDecoration(
    labelText: 'Username',
    hintText: 'Enter your username',
    prefixIcon: Icon(Icons.person),
  ),
  validator: JetValidators.compose([
    JetValidators.required(),
    JetValidators.minLength(3),
  ]),
)
```

**Key Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `name` | `String` | Unique field identifier (required) |
| `decoration` | `InputDecoration?` | Input decoration |
| `validator` | `Validator?` | Validation function |
| `initialValue` | `String?` | Initial value |
| `maxLength` | `int?` | Maximum character count |
| `maxLines` | `int?` | Number of lines (1=single, >1=multiline) |
| `keyboardType` | `TextInputType?` | Keyboard type |
| `textCapitalization` | `TextCapitalization?` | Capitalization mode |
| `enabled` | `bool?` | Whether field is enabled |
| `readOnly` | `bool?` | Whether field is read-only |
| `onChanged` | `ValueChanged<String?>?` | Value change callback |

---

### JetPasswordField

Password input with visibility toggle.

**Example:**
```dart
JetPasswordField(
  name: 'password',
  decoration: const InputDecoration(
    labelText: 'Password',
    prefixIcon: Icon(Icons.lock),
  ),
  validator: JetValidators.compose([
    JetValidators.required(),
    JetValidators.minLength(8),
  ]),
)
```

**With Confirmation:**
```dart
final formKey = GlobalKey<JetFormState>();

JetPasswordField.withConfirmation(
  name: 'password',
  formKey: formKey,
  decoration: const InputDecoration(labelText: 'Password'),
  confirmationDecoration: const InputDecoration(
    labelText: 'Confirm Password',
  ),
  isRequired: true,
  spacing: 16,
)
```

**Additional Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `visibilityIcon` | `Widget?` | Icon when password is visible |
| `visibilityOffIcon` | `Widget?` | Icon when password is hidden |
| `isRequired` | `bool?` | Auto-add required validator |

---

### JetPhoneField

Phone number input (numeric only).

**Example:**
```dart
JetPhoneField(
  name: 'phone',
  decoration: const InputDecoration(
    labelText: 'Phone Number',
    hintText: '+1 (555) 123-4567',
    prefixIcon: Icon(Icons.phone),
  ),
  validator: JetValidators.phoneNumber(),
)
```

---

### JetPinField

OTP/PIN input using Pinput package.

**Example:**
```dart
JetPinField(
  name: 'otp',
  length: 6,
  decoration: const InputDecoration(
    labelText: 'Verification Code',
  ),
  onCompleted: (pin) {
    print('OTP: $pin');
  },
  validator: JetValidators.equalLength(6),
)
```

**Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `length` | `int?` | Number of PIN digits (default: 4) |
| `onCompleted` | `ValueChanged<String?>?` | Called when all digits entered |
| `obscureText` | `bool?` | Hide PIN characters |

---

## Date & Time Pickers

### JetDateTimePicker

Date, time, or datetime picker.

**Date Only:**
```dart
JetDateTimePicker(
  name: 'birthdate',
  decoration: const InputDecoration(
    labelText: 'Date of Birth',
    prefixIcon: Icon(Icons.cake),
  ),
  inputType: DateTimePickerInputType.date,
  firstDate: DateTime(1900),
  lastDate: DateTime.now(),
)
```

**Time Only:**
```dart
JetDateTimePicker(
  name: 'appointment_time',
  inputType: DateTimePickerInputType.time,
)
```

**Date and Time:**
```dart
JetDateTimePicker(
  name: 'meeting_datetime',
  inputType: DateTimePickerInputType.both,
)
```

**Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `inputType` | `DateTimePickerInputType` | date, time, or both (required) |
| `firstDate` | `DateTime?` | Earliest selectable date |
| `lastDate` | `DateTime?` | Latest selectable date |
| `hintText` | `String?` | Placeholder text |
| `format` | `DateFormat?` | Custom date format |

---

### JetDateRangePicker

Date range picker.

**Example:**
```dart
JetDateRangePicker(
  name: 'vacation_dates',
  decoration: const InputDecoration(
    labelText: 'Vacation Dates',
    prefixIcon: Icon(Icons.flight_takeoff),
  ),
  firstDate: DateTime.now(),
  lastDate: DateTime.now().add(const Duration(days: 365)),
)
```

---

## Selection Fields

### JetDropdown

Dropdown selection field.

**Example:**
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
  ],
  validator: JetValidators.required(),
)
```

**Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `options` | `List<JetFormOption<T>>` | List of options (required) |
| `hint` | `Widget?` | Placeholder widget |
| `isExpanded` | `bool?` | Whether dropdown is expanded |

---

### JetRadioGroup

Radio button group for single selection.

**Example:**
```dart
JetRadioGroup<String>(
  name: 'gender',
  decoration: const InputDecoration(labelText: 'Gender'),
  options: const [
    JetFormOption(value: 'male', child: Text('Male')),
    JetFormOption(value: 'female', child: Text('Female')),
    JetFormOption(value: 'other', child: Text('Other')),
  ],
  direction: Axis.horizontal,
)
```

**Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `direction` | `Axis?` | Layout direction (horizontal/vertical) |
| `spacing` | `double?` | Space between options |

---

### JetCheckboxGroup

Checkbox group for multiple selections.

**Example:**
```dart
JetCheckboxGroup<String>(
  name: 'interests',
  decoration: const InputDecoration(labelText: 'Interests'),
  options: const [
    JetFormOption(value: 'sports', child: Text('⚽ Sports')),
    JetFormOption(value: 'music', child: Text('🎵 Music')),
    JetFormOption(value: 'reading', child: Text('📚 Reading')),
  ],
)
```

---

## Boolean Fields

### JetCheckbox

Single checkbox field.

**Example:**
```dart
JetCheckbox(
  name: 'terms',
  title: const Text('I agree to the Terms and Conditions'),
  subtitle: const Text('You must accept to continue'),
  validator: JetValidators.equal(
    true,
    errorText: 'You must accept the terms',
  ),
)
```

**Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `title` | `Widget?` | Checkbox title |
| `subtitle` | `Widget?` | Checkbox subtitle |
| `activeColor` | `Color?` | Color when checked |

---

### JetSwitch

Toggle switch field.

**Example:**
```dart
JetSwitch(
  name: 'notifications',
  title: const Text('Enable push notifications'),
  subtitle: const Text('Get notified about important updates'),
)
```

---

## Slider Fields

### JetSlider

Single value slider.

**Example:**
```dart
JetSlider(
  name: 'age',
  decoration: const InputDecoration(labelText: 'Age'),
  min: 18,
  max: 100,
  divisions: 82,
  initialValue: 25,
  displayValues: SliderDisplayValues.all,
)
```

**Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `min` | `double` | Minimum value (required) |
| `max` | `double` | Maximum value (required) |
| `divisions` | `int?` | Number of discrete intervals |
| `displayValues` | `SliderDisplayValues?` | Which values to display |

---

### JetRangeSlider

Range slider for min/max selection.

**Example:**
```dart
JetRangeSlider(
  name: 'price_range',
  decoration: const InputDecoration(labelText: 'Price Range'),
  min: 0,
  max: 1000,
  divisions: 20,
  initialValue: const RangeValues(100, 500),
)
```

---

## Chip Fields

### JetChoiceChips

Single selection chip group.

**Example:**
```dart
JetChoiceChips<String>(
  name: 'account_type',
  decoration: const InputDecoration(labelText: 'Account Type'),
  options: const [
    JetFormOption(value: 'personal', child: Text('Personal')),
    JetFormOption(value: 'business', child: Text('Business')),
  ],
)
```

---

### JetFilterChips

Multiple selection chip group.

**Example:**
```dart
JetFilterChips<String>(
  name: 'skills',
  decoration: const InputDecoration(labelText: 'Skills'),
  options: const [
    JetFormOption(value: 'flutter', child: Text('Flutter')),
    JetFormOption(value: 'dart', child: Text('Dart')),
    JetFormOption(value: 'react', child: Text('React')),
  ],
)
```

---

## Common Parameters

All form fields support these common parameters:

| Parameter | Type | Description |
|-----------|------|-------------|
| `name` | `String` | Unique field identifier (required) |
| `decoration` | `InputDecoration?` | Input decoration |
| `validator` | `Validator?` | Validation function |
| `initialValue` | `T?` | Initial value |
| `enabled` | `bool?` | Whether field is enabled |
| `onChanged` | `ValueChanged<T?>?` | Value change callback |
| `focusNode` | `FocusNode?` | Focus node for the field |
| `autovalidateMode` | `AutovalidateMode?` | When to auto-validate |

---

## Validators Reference

### String Validators

```dart
JetValidators.required()              // Not empty
JetValidators.minLength(3)           // Min 3 characters
JetValidators.maxLength(20)          // Max 20 characters
JetValidators.equalLength(6)         // Exactly 6 characters
JetValidators.email()                // Valid email
JetValidators.url()                  // Valid URL
JetValidators.alphanumeric()         // Letters and numbers only
JetValidators.alpha()                // Letters only
JetValidators.contains('text')       // Contains substring
JetValidators.startsWith('text')     // Starts with text
JetValidators.endsWith('text')       // Ends with text
JetValidators.regex(r'^pattern$')    // Custom regex
```

### Numeric Validators

```dart
JetValidators.numeric()              // Is a number
JetValidators.integer()              // Is an integer
JetValidators.min(18)                // Minimum value
JetValidators.max(100)               // Maximum value
JetValidators.range(18, 100)         // Value in range
JetValidators.positive()             // Greater than 0
JetValidators.negative()             // Less than 0
JetValidators.even()                 // Even number
JetValidators.odd()                  // Odd number
```

### Boolean Validators

```dart
JetValidators.equal(true)            // Must equal value
JetValidators.notEqual(false)        // Must not equal value
JetValidators.isTrue()               // Must be true
JetValidators.isFalse()              // Must be false
```

### Collection Validators

```dart
JetValidators.minLength(2)           // Min 2 items
JetValidators.maxLength(10)          // Max 10 items
JetValidators.containsElement(value) // Contains item
JetValidators.unique()               // No duplicates
```

### Date Validators

```dart
JetValidators.dateFuture()           // Date in future
JetValidators.datePast()             // Date in past
JetValidators.dateRange(start, end)  // Date in range
JetValidators.date()                 // Valid date
JetValidators.time()                 // Valid time
```

### Composite Validators

```dart
// Multiple validators (all must pass)
JetValidators.compose([
  JetValidators.required(),
  JetValidators.email(),
])

// Either validator can pass
JetValidators.or([
  JetValidators.email(),
  JetValidators.phoneNumber(),
])

// Conditional validation
JetValidators.conditional(
  condition: (value) => value != null,
  validator: JetValidators.minLength(3),
)

// Skip validation when
JetValidators.skipWhen(
  condition: (value) => value == null,
  validator: JetValidators.email(),
)
```

### Custom Validators

```dart
// Create custom validator
String? customValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Field is required';
  }
  if (!value.contains('@company.com')) {
    return 'Must use company email';
  }
  return null; // Valid
}

// Use custom validator
JetTextField(
  name: 'email',
  validator: customValidator,
)
```

### Field Matching

```dart
// Password confirmation
final formKey = GlobalKey<JetFormState>();

JetTextField(
  name: 'password',
  validator: JetValidators.required(),
)

JetTextField(
  name: 'password_confirmation',
  validator: JetValidators.compose([
    JetValidators.required(),
    JetValidators.matchField<String>(
      formKey,
      'password',
      errorText: 'Passwords do not match',
    ),
  ]),
)
```

---

## Custom Error Messages

All validators support custom error messages:

```dart
JetValidators.required(
  errorText: 'This field cannot be empty',
)

JetValidators.email(
  errorText: 'Please enter a valid email address',
)

JetValidators.minLength(
  8,
  errorText: 'Password must be at least 8 characters',
)
```

---

## Localization

Validator messages are automatically localized. Supported languages:
- English (default)
- Arabic
- French

Add custom translations in your app's localization files.

---

## Examples

### Complete Registration Form

```dart
JetSimpleForm(
  form: form,
  children: [
    // Name
    JetTextField(
      name: 'name',
      decoration: const InputDecoration(labelText: 'Full Name'),
      validator: JetValidators.compose([
        JetValidators.required(),
        JetValidators.minLength(2),
      ]),
    ),
    
    // Email
    JetTextField(
      name: 'email',
      decoration: const InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      validator: JetValidators.compose([
        JetValidators.required(),
        JetValidators.email(),
      ]),
    ),
    
    // Password
    JetPasswordField(
      name: 'password',
      decoration: const InputDecoration(labelText: 'Password'),
      validator: JetValidators.compose([
        JetValidators.required(),
        JetValidators.minLength(8),
      ]),
    ),
    
    // Birthdate
    JetDateTimePicker(
      name: 'birthdate',
      decoration: const InputDecoration(labelText: 'Date of Birth'),
      inputType: DateTimePickerInputType.date,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ),
    
    // Country
    JetDropdown<String>(
      name: 'country',
      decoration: const InputDecoration(labelText: 'Country'),
      options: const [
        JetFormOption(value: 'us', child: Text('United States')),
        JetFormOption(value: 'uk', child: Text('United Kingdom')),
      ],
      validator: JetValidators.required(),
    ),
    
    // Terms
    JetCheckbox(
      name: 'terms',
      title: const Text('I agree to Terms and Conditions'),
      validator: JetValidators.equal(true),
    ),
  ],
)
```

---

## Best Practices

### ✅ DO

- Use descriptive field names
- Provide clear labels and hints
- Add appropriate validators
- Use correct keyboard types
- Show helper text when needed

### ❌ DON'T

- Use duplicate field names
- Skip validation on required fields
- Use generic error messages
- Forget to handle null values

---

## Related Documentation

- [Simple Forms Guide](FORMS_SIMPLE.md) - Learn useJetForm
- [Advanced Forms Guide](FORMS_ADVANCED.md) - Learn JetFormNotifier
- [Main Forms Documentation](FORMS.md) - Overview

---

Happy form building! 🚀

