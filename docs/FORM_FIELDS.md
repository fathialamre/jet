# Form Fields Documentation

Complete guide to all form field widgets in the Jet framework.

## Overview

Jet provides a comprehensive set of pre-built form field widgets that integrate seamlessly with **[Flutter Form Builder](https://pub.dev/packages/flutter_form_builder)**. These widgets provide consistent styling, built-in validation, and enhanced functionality for common input types.

**Packages Used:**
- **flutter_form_builder** - ^9.1.1 - [pub.dev](https://pub.dev/packages/flutter_form_builder) - Base form building framework
- **form_builder_validators** - ^9.1.0 - [pub.dev](https://pub.dev/packages/form_builder_validators) - 20+ built-in validators
- **pinput** - ^3.0.1 - [pub.dev](https://pub.dev/packages/pinput) | [Documentation](https://pub.dev/documentation/pinput/latest/) - PIN/OTP input for JetPinField
- **intl** - ^0.18.1 - [pub.dev](https://pub.dev/packages/intl) - Date formatting for JetDateField

**Key Benefits:**
- ✅ Consistent theming across all fields
- ✅ Built-in validation with 20+ validators
- ✅ Platform-aware behavior (Material/Cupertino)
- ✅ Accessibility support
- ✅ Value transformers for data preprocessing
- ✅ Extensive customization options
- ✅ Error handling and display
- ✅ Responsive design support

**Features:**
- ✅ Built-in validation
- ✅ Consistent theming
- ✅ Extensive customization options
- ✅ Platform-aware behavior
- ✅ Accessibility support

## Available Fields

- [JetTextField](#jettextfield) - General text input
- [JetEmailField](#jetemailfield) - Email input with validation
- [JetPasswordField](#jetpasswordfield) - Password with visibility toggle
- [JetPhoneField](#jetphonefield) - Phone number input
- [JetPinField](#jetpinfield) - PIN/OTP input
- [JetDateField](#jetdatefield) - Date picker
- [JetDropdownField](#jetdropdownfield) - Dropdown selection
- [JetCheckboxField](#jetcheckboxfield) - Checkbox or switch
- [JetTextAreaField](#jettextareafield) - Multi-line text input

## JetTextField

General text input for any text data.

```dart
JetTextField(
  name: 'username',
  labelText: 'Username',
  hintText: 'Enter your username',
  minLength: 3,
  maxLength: 20,
)
```

**Key Parameters:**
- `keyboardType` - Keyboard type (text, number, etc.)
- `textCapitalization` - Auto-capitalize behavior
- `obscureText` - Hide text (for passwords)
- `maxLength` / `minLength` - Character limits
- `trimWhitespace` - Auto-trim whitespace (default: true)
- `inputFormatters` - Input format restrictions

## JetEmailField

Email input with built-in validation.

```dart
JetEmailField(
  name: 'email',
  labelText: 'Email Address',
  hintText: 'name@example.com',
  toLowerCase: true,
)
```

**Key Parameters:**
- `toLowerCase` - Auto-convert to lowercase (default: true)
- `showPrefixIcon` - Show envelope icon (default: true)

## JetPasswordField

Password input with visibility toggle and confirmation support.

```dart
// Basic password field
JetPasswordField(
  name: 'password',
  labelText: 'Password',
  hintText: 'Enter your password',
)

// Password confirmation
JetPasswordField(
  name: 'confirm_password',
  labelText: 'Confirm Password',
  identicalWith: 'password',
  formKey: formKey,
)
```

**Key Parameters:**
- `identicalWith` - Field name to match (for confirmation)
- `formKey` - Required when using `identicalWith`
- `showPrefixIcon` - Show lock icon (default: true)
- `obscureText` - Initially obscure text (default: true)

## JetPhoneField

Phone number input with validation.

```dart
JetPhoneField(
  name: 'phone',
  labelText: 'Phone Number',
  countryCode: '+1',
  minLength: 10,
  maxLength: 10,
)
```

**Key Parameters:**
- `countryCode` - Country code prefix (e.g., '+1')
- `minLength` - Minimum phone length (default: 10)
- `maxLength` - Maximum phone length (default: 15)
- `allowInternational` - Allow international format (default: true)

## JetPinField

PIN/OTP input with visual boxes.

```dart
JetPinField(
  name: 'otp',
  length: 6,
  obscureText: false,
  autofocus: true,
  onCompleted: (pin) {
    verifyOTP(pin);
  },
)
```

**Key Parameters:**
- `length` - Number of PIN digits (default: 6)
- `obscureText` - Hide entered digits (default: false)
- `onCompleted` - Callback when all digits entered
- `hapticFeedback` - Enable haptic feedback (default: false)
- `closeKeyboardWhenCompleted` - Auto-close keyboard (default: false)

## JetDateField

Date picker with customizable format.

```dart
JetDateField(
  name: 'birthdate',
  labelText: 'Date of Birth',
  format: DateFormat('MMM dd, yyyy'),
  firstDate: DateTime(1900),
  lastDate: DateTime.now(),
)
```

**Key Parameters:**
- `format` - Date display format (default: 'yyyy-MM-dd')
- `firstDate` - Minimum selectable date
- `lastDate` - Maximum selectable date
- `inputType` - Date, time, or both

## JetDropdownField

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
)
```

**Key Parameters:**
- `items` - Dropdown options
- `isExpanded` - Expand to full width (default: true)
- `onChanged` - Callback on selection

## JetCheckboxField

Checkbox or switch with title and subtitle.

```dart
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
- `title` - Main label text
- `subtitle` - Additional description
- `useSwitch` - Use switch instead of checkbox (default: false)
- `activeColor` - Color when active

## JetTextAreaField

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
- `minLines` - Minimum visible lines (default: 3)
- `maxLines` - Maximum visible lines (default: 6)
- `maxLength` - Maximum character count
- `showCharacterCounter` - Display character counter (default: false)

## Common Features

### Value Transformers

All fields support `valueTransformer` for preprocessing data:

```dart
JetTextField(
  name: 'username',
  valueTransformer: (value) => value?.trim().toLowerCase(),
)
```

### Validation

Fields have built-in validation that can be extended:

```dart
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

### Styling

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

## Best Practices

### 1. Use FormBuilder

Always wrap fields in a `FormBuilder` widget:

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

### 4. Provide Clear Labels and Hints

```dart
JetEmailField(
  name: 'email',
  labelText: 'Email Address',        // Clear label
  hintText: 'name@example.com',      // Example format
  helperText: 'We will never share your email',  // Context
)
```

## See Also

- [Forms Documentation](FORMS.md) - Form management
- [Components Documentation](COMPONENTS.md) - UI components

