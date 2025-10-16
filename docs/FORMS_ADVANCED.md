# Advanced Forms Guide

## Overview

Advanced Forms using `JetFormNotifier` provide full control over form lifecycle, validation, and state management for complex enterprise requirements.

**When to use Advanced Forms:**
- ✅ Multi-step wizards (3+ steps)
- ✅ Conditional field visibility based on other fields
- ✅ Complex cross-field validation
- ✅ Server-side validation with field-specific errors
- ✅ Form state persistence across navigation
- ✅ Custom lifecycle hooks
- ✅ Reusable form logic across multiple screens
- ✅ Validation result caching

**Key Benefits:**
- Full lifecycle control
- Custom validation per field
- Mixins for reusable functionality
- Performance optimizations (caching, debouncing)
- Easy to test complex logic
- Type-safe with Riverpod

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Core Concepts](#core-concepts)
3. [JetFormNotifier Deep Dive](#jetformnotifier-deep-dive)
4. [JetFormMixin](#jetformmixin)
5. [Mixins Explained](#mixins-explained)
6. [Custom Validation](#custom-validation)
7. [Lifecycle Callbacks](#lifecycle-callbacks)
8. [Server-Side Validation](#server-side-validation)
9. [Multi-Step Wizards](#multi-step-wizards)
10. [Conditional Fields](#conditional-fields)
11. [Form State Persistence](#form-state-persistence)
12. [Performance Optimizations](#performance-optimizations)
13. [Migration from Simple Forms](#migration-from-simple-forms)
14. [Best Practices](#best-practices)

---

## Quick Start

### Step 1: Create Form Notifier

```dart
import 'package:jet/jet.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_form.g.dart';

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
}
```

### Step 2: Use in UI

```dart
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
              decoration: const InputDecoration(labelText: 'Email'),
              validator: JetValidators.compose([
                JetValidators.required(),
                JetValidators.email(),
              ]),
            ),
            const SizedBox(height: 16),
            JetPasswordField(
              name: 'password',
              decoration: const InputDecoration(labelText: 'Password'),
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

### Step 3: Generate Code

```bash
dart run build_runner build
```

---

## Core Concepts

### AsyncFormValue

Form state management using Riverpod's AsyncValue pattern:

```dart
sealed class AsyncFormValue<Request, Response> {
  const AsyncFormValue();
  
  // Initial idle state
  const AsyncFormIdle();
  
  // Loading (submitting)
  const AsyncFormLoading();
  
  // Success with response
  const AsyncFormData(Request request, Response response);
  
  // Error
  const AsyncFormError(Object error, StackTrace stackTrace);
}
```

### State Properties

```dart
state.isIdle      // Initial state
state.isLoading   // Submitting
state.hasValue    // Success
state.hasError    // Error
state.request     // Request data
state.response    // Response data
state.error       // Error object
```

---

## JetFormNotifier Deep Dive

### Base Class

```dart
abstract class JetFormNotifier<Request, Response>
    extends Notifier<AsyncFormValue<Request, Response>>
    with JetFormMixin<Request, Response> {
  @override
  AsyncFormValue<Request, Response> build();
}
```

### Required Methods

```dart
@override
Request decoder(Map<String, dynamic> json) {
  // Convert form values Map to Request object
  return Request.fromJson(json);
}

@override
Future<Response> action(Request data) async {
  // Submit data to API
  return await apiService.submit(data);
}
```

### Optional Method Overrides

```dart
@override
List<String> validateField(String fieldName, dynamic value) {
  // Custom field validation
  if (fieldName == 'email' && !value.toString().contains('@company.com')) {
    return ['Must use company email'];
  }
  return [];
}

@override
void triggerSuccess(Response response, Request request) {
  // Custom success handling
  ref.read(userProvider.notifier).setUser(response.user);
  super.triggerSuccess(response, request);
}

@override
void triggerSubmissionError(Object error, StackTrace stackTrace) {
  // Custom error handling
  logger.error('Form submission failed', error, stackTrace);
  super.triggerSubmissionError(error, stackTrace);
}
```

---

## JetFormMixin

The core mixin that provides all form functionality:

### Properties

```dart
formKey                  // GlobalKey<JetFormState>
state                    // AsyncFormValue<Request, Response>
hasChanges              // bool - form has unsaved changes
```

### Methods

```dart
submit()                           // Submit the form
reset()                            // Reset to initial state
validateForm()                     // Validate without submitting
validateSingleField(String name)   // Validate specific field
setValue(String name, value)       // Set field value
setValues(Map<String, dynamic>)    // Set multiple values
invalidateFormFields(Map errors)   // Set field errors from server
invalidateValidationCache()        // Clear validation cache
```

---

## Mixins Explained

### FormValidationMixin

Handles field validation:

```dart
mixin FormValidationMixin {
  // Validate specific field
  List<String> validateField(String fieldName, dynamic value);
  
  // Validate all fields
  bool validateAllFields(GlobalKey<JetFormState> formKey);
  
  // Extract form errors
  Map<String, List<String>> extractFormErrors(JetFormState? formState);
}
```

**Override for custom validation:**

```dart
@override
List<String> validateField(String fieldName, dynamic value) {
  switch (fieldName) {
    case 'email':
      if (!value.toString().contains('@company.com')) {
        return ['Must use company email'];
      }
      break;
    case 'age':
      final age = int.tryParse(value.toString()) ?? 0;
      if (age < 18) {
        return ['Must be 18 or older'];
      }
      break;
  }
  return [];
}
```

### FormErrorHandlingMixin

Handles error conversion:

```dart
mixin FormErrorHandlingMixin {
  // Convert any error to JetError
  JetError convertToJetError(Object error, StackTrace stackTrace);
  
  // Create validation error
  JetError createValidationError(Map<String, List<String>> formErrors);
}
```

### FormLifecycleMixin

Manages form lifecycle callbacks:

```dart
mixin FormLifecycleMixin<Request, Response> {
  void triggerSubmissionStart();
  void triggerSuccess(Response response, Request request);
  void triggerSubmissionError(Object error, StackTrace stackTrace);
  void triggerValidationError(Object error, StackTrace stackTrace);
}
```

**Override for custom behavior:**

```dart
@override
void triggerSuccess(Response response, Request request) {
  // Update global state
  ref.read(authProvider.notifier).setToken(response.token);
  
  // Log analytics
  analytics.logEvent('form_submitted', {
    'form': 'login',
    'user_id': response.userId,
  });
  
  // Call parent
  super.triggerSuccess(response, request);
}
```

---

## Custom Validation

### Field-Level Validation

```dart
@riverpod
class RegistrationForm extends _$RegistrationForm 
    with JetFormMixin<RegistrationRequest, RegistrationResponse> {
  
  @override
  List<String> validateField(String fieldName, dynamic value) {
    final errors = <String>[];
    
    switch (fieldName) {
      case 'email':
        // Must be company email
        if (!value.toString().contains('@company.com')) {
          errors.add('Must use company email');
        }
        break;
        
      case 'password':
        // Password strength check
        if (value.toString().length < 8) {
          errors.add('Password must be at least 8 characters');
        }
        if (!RegExp(r'[A-Z]').hasMatch(value.toString())) {
          errors.add('Password must contain uppercase letter');
        }
        if (!RegExp(r'[0-9]').hasMatch(value.toString())) {
          errors.add('Password must contain number');
        }
        break;
        
      case 'age':
        final age = int.tryParse(value.toString()) ?? 0;
        if (age < 18) {
          errors.add('Must be 18 or older');
        }
        if (age > 120) {
          errors.add('Please enter valid age');
        }
        break;
    }
    
    return errors;
  }
}
```

### Cross-Field Validation

```dart
@override
List<String> validateField(String fieldName, dynamic value) {
  if (fieldName == 'password_confirmation') {
    final password = formKey.currentState?.fields['password']?.value;
    if (value != password) {
      return ['Passwords do not match'];
    }
  }
  return [];
}
```

### Async Validation

```dart
@override
List<String> validateField(String fieldName, dynamic value) {
  if (fieldName == 'username') {
    // This runs synchronously, but you can trigger async check
    _checkUsernameAvailability(value.toString());
  }
  return [];
}

Future<void> _checkUsernameAvailability(String username) async {
  final isAvailable = await api.checkUsername(username);
  if (!isAvailable) {
    formKey.currentState?.fields['username']?.invalidate(
      'Username is already taken',
    );
  }
}
```

---

## Lifecycle Callbacks

### Available Callbacks

```dart
@riverpod
class MyForm extends _$MyForm with JetFormMixin<Request, Response> {
  @override
  AsyncFormValue<Request, Response> build() {
    // Set up lifecycle callbacks
    setLifecycleCallbacks(
      FormLifecycleCallbacks<Request, Response>(
        onSubmissionStart: () {
          print('Form submission started');
        },
        onSuccess: (response, request) {
          print('Form submitted successfully');
        },
        onSubmissionError: (error, stackTrace) {
          print('Form submission failed: $error');
        },
        onValidationError: (error, stackTrace) {
          print('Form validation failed');
        },
      ),
    );
    
    return const AsyncFormIdle();
  }
}
```

### Custom Lifecycle Hooks

```dart
@override
void triggerSubmissionStart() {
  // Show full-screen loading
  ref.read(loadingProvider.notifier).show();
  super.triggerSubmissionStart();
}

@override
void triggerSuccess(Response response, Request request) {
  // Hide loading
  ref.read(loadingProvider.notifier).hide();
  
  // Update app state
  ref.read(dataProvider.notifier).refresh();
  
  // Log analytics
  analytics.logEvent('form_success');
  
  super.triggerSuccess(response, request);
}

@override
void triggerSubmissionError(Object error, StackTrace stackTrace) {
  // Hide loading
  ref.read(loadingProvider.notifier).hide();
  
  // Log to error tracking
  errorTracking.log(error, stackTrace);
  
  super.triggerSubmissionError(error, stackTrace);
}
```

---

## Server-Side Validation

Handle validation errors from API:

```dart
@override
Future<Response> action(Request data) async {
  try {
    return await api.submit(data);
  } on ValidationException catch (e) {
    // Server returned field-specific errors
    // e.g., { "email": ["Email already exists"], "username": ["Too short"] }
    invalidateFormFields(e.fieldErrors);
    rethrow;
  }
}
```

### Invalidate Specific Fields

```dart
// Invalidate single field
formKey.currentState?.fields['email']?.invalidate('Email already exists');

// Invalidate multiple fields
invalidateFormFields({
  'email': ['Email already exists'],
  'username': ['Username is taken'],
});
```

---

## Multi-Step Wizards

Create multi-step forms with navigation:

```dart
@riverpod
class RegistrationWizardForm extends _$RegistrationWizardForm
    with JetFormMixin<RegistrationRequest, RegistrationResponse> {
  
  int _currentStep = 0;
  
  int get currentStep => _currentStep;
  
  void nextStep() {
    // Validate current step
    if (_validateCurrentStep()) {
      _currentStep++;
      ref.notifyListeners();
    }
  }
  
  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      ref.notifyListeners();
    }
  }
  
  bool _validateCurrentStep() {
    final formState = formKey.currentState;
    if (formState == null) return false;
    
    // Validate only fields for current step
    final stepFields = _getStepFields(_currentStep);
    for (final fieldName in stepFields) {
      final field = formState.fields[fieldName];
      if (field != null && !field.validate()) {
        return false;
      }
    }
    return true;
  }
  
  List<String> _getStepFields(int step) {
    switch (step) {
      case 0:
        return ['name', 'email'];
      case 1:
        return ['password', 'password_confirmation'];
      case 2:
        return ['phone', 'address'];
      default:
        return [];
    }
  }
  
  @override
  AsyncFormValue<RegistrationRequest, RegistrationResponse> build() {
    return const AsyncFormIdle();
  }
  
  @override
  RegistrationRequest decoder(Map<String, dynamic> json) {
    return RegistrationRequest.fromJson(json);
  }
  
  @override
  Future<RegistrationResponse> action(RegistrationRequest data) async {
    return await ref.read(apiServiceProvider).register(data);
  }
}
```

### UI for Multi-Step Form

```dart
class RegistrationWizardPage extends ConsumerWidget {
  const RegistrationWizardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(registrationWizardFormProvider.notifier);
    final currentStep = ref.watch(
      registrationWizardFormProvider.select((state) => form.currentStep),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Registration')),
      body: Column(
        children: [
          // Step indicator
          Stepper(
            currentStep: currentStep,
            onStepContinue: form.nextStep,
            onStepCancel: form.previousStep,
            steps: [
              Step(
                title: const Text('Personal Info'),
                content: _buildStep1(),
                isActive: currentStep >= 0,
              ),
              Step(
                title: const Text('Account'),
                content: _buildStep2(),
                isActive: currentStep >= 1,
              ),
              Step(
                title: const Text('Contact'),
                content: _buildStep3(),
                isActive: currentStep >= 2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

---

## Conditional Fields

Show/hide fields based on other field values:

```dart
class DynamicFormPage extends ConsumerWidget {
  const DynamicFormPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic Form')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: JetFormConsumer<Request, Response>(
          provider: formProvider,
          builder: (context, ref, form, state) {
            // Watch account type field
            final formState = form.currentState;
            final accountType = formState?.fields['account_type']?.value;
            
            return [
              // Account type selection
              JetRadioGroup<String>(
                name: 'account_type',
                options: const [
                  JetFormOption(value: 'personal', child: Text('Personal')),
                  JetFormOption(value: 'business', child: Text('Business')),
                ],
              ),
              
              // Show business fields only for business accounts
              if (accountType == 'business') ...[
                JetTextField(
                  name: 'company_name',
                  decoration: const InputDecoration(
                    labelText: 'Company Name',
                  ),
                  validator: JetValidators.required(),
                ),
                JetTextField(
                  name: 'tax_id',
                  decoration: const InputDecoration(
                    labelText: 'Tax ID',
                  ),
                  validator: JetValidators.required(),
                ),
              ],
              
              // Show personal fields only for personal accounts
              if (accountType == 'personal') ...[
                JetDateTimePicker(
                  name: 'birthdate',
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                  ),
                  inputType: DateTimePickerInputType.date,
                ),
              ],
            ];
          },
          onSuccess: (response, request) {
            context.showToast('Form submitted successfully');
          },
          onError: (error, stackTrace, invalidateFields) {
            context.showToast('Error: $error');
          },
        ),
      ),
    );
  }
}
```

---

## Form State Persistence

Save and restore form state:

```dart
@riverpod
class PersistentForm extends _$PersistentForm
    with JetFormMixin<Request, Response> {
  
  @override
  AsyncFormValue<Request, Response> build() {
    // Restore saved state
    _restoreFormState();
    return const AsyncFormIdle();
  }
  
  Future<void> _restoreFormState() async {
    final saved = await ref.read(storageProvider).read('form_draft');
    if (saved != null) {
      // Restore field values
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setValues(saved as Map<String, dynamic>);
      });
    }
  }
  
  Future<void> saveDraft() async {
    final values = formKey.currentState?.value;
    if (values != null) {
      await ref.read(storageProvider).write('form_draft', values);
    }
  }
  
  Future<void> clearDraft() async {
    await ref.read(storageProvider).delete('form_draft');
  }
  
  @override
  void triggerSuccess(Response response, Request request) {
    // Clear draft after successful submission
    clearDraft();
    super.triggerSuccess(response, request);
  }
}
```

---

## Performance Optimizations

### Validation Result Caching

Built-in validation caching (automatic):

```dart
// Validation results are cached automatically
// Cache is invalidated when field value changes
```

### Manual Cache Management

```dart
// Clear cache for specific field
invalidateValidationCache('email');

// Clear all caches
invalidateValidationCache();
```

### Field-Specific Change Listeners

Only rebuild when specific fields change:

```dart
JetFormChangeListener(
  form: form,
  listenToFields: ['email', 'password'], // Only these fields
  builder: (context) {
    // Only rebuilds when email or password changes
    return SaveButton();
  },
)
```

### Validation Debouncing

Debounce expensive validators:

```dart
JetTextField(
  name: 'username',
  validator: JetValidators.required(),
  onChanged: (value) {
    // Validate after 500ms of no typing
    field.validateDebounced(debounceDuration: 500);
  },
)
```

---

## Migration from Simple Forms

### Before (Simple Forms)

```dart
class LoginPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = useJetForm<LoginRequest, LoginResponse>(
      ref: ref,
      decoder: (json) => LoginRequest.fromJson(json),
      action: (request) => api.login(request),
    );
    
    return JetSimpleForm(
      form: form,
      children: [...],
    );
  }
}
```

### After (Advanced Forms)

**Step 1: Create notifier**

```dart
// lib/forms/login_form.dart
@riverpod
class LoginForm extends _$LoginForm 
    with JetFormMixin<LoginRequest, LoginResponse> {
  
  @override
  AsyncFormValue<LoginRequest, LoginResponse> build() {
    return const AsyncFormIdle();
  }
  
  @override
  LoginRequest decoder(Map<String, dynamic> json) {
    return LoginRequest.fromJson(json);
  }
  
  @override
  Future<LoginResponse> action(LoginRequest data) {
    return ref.read(apiServiceProvider).login(data);
  }
}
```

**Step 2: Update UI**

```dart
class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: JetFormConsumer<LoginRequest, LoginResponse>(
          provider: loginFormProvider,
          builder: (context, ref, form, state) => [...],
          onSuccess: (response, request) {
            context.showToast('Success');
          },
          onError: (error, stackTrace, invalidateFields) {
            context.showToast('Error: $error');
          },
        ),
      ),
    );
  }
}
```

**Step 3: Generate code**

```bash
dart run build_runner build
```

**Migration time:** 15-30 minutes

---

## Best Practices

### ✅ DO

1. **Use type-safe models**
   ```dart
   JetFormMixin<LoginRequest, LoginResponse>
   ```

2. **Override lifecycle methods for custom behavior**
   ```dart
   @override
   void triggerSuccess(Response response, Request request) {
     // Custom logic
     super.triggerSuccess(response, request);
   }
   ```

3. **Cache validation results**
   - Built-in caching is automatic
   - Manual cache invalidation when needed

4. **Use mixins for reusable logic**
   ```dart
   mixin CustomValidationMixin {
     // Shared validation logic
   }
   ```

5. **Test form logic separately**
   ```dart
   test('validates email correctly', () {
     final form = LoginForm();
     final errors = form.validateField('email', 'invalid');
     expect(errors, isNotEmpty);
   });
   ```

### ❌ DON'T

1. **Don't skip error handling**
   ```dart
   // Bad: No error handling
   @override
   Future<Response> action(Request data) async {
     return await api.submit(data);
   }
   ```

2. **Don't forget to call super in overrides**
   ```dart
   @override
   void triggerSuccess(Response response, Request request) {
     // Custom logic
     super.triggerSuccess(response, request); // Don't forget!
   }
   ```

3. **Don't validate on every keystroke without debouncing**
   ```dart
   // Use validateDebounced() for expensive validators
   ```

4. **Don't hardcode field names**
   ```dart
   // Bad: Magic strings
   final value = formState.fields['email']?.value;
   
   // Good: Constants
   static const String emailField = 'email';
   final value = formState.fields[emailField]?.value;
   ```

---

## Complete Example

Full-featured registration form with all advanced features:

```dart
@riverpod
class AdvancedRegistrationForm extends _$AdvancedRegistrationForm
    with JetFormMixin<RegistrationRequest, RegistrationResponse> {
  
  @override
  AsyncFormValue<RegistrationRequest, RegistrationResponse> build() {
    setLifecycleCallbacks(
      FormLifecycleCallbacks<RegistrationRequest, RegistrationResponse>(
        onSubmissionStart: _onStart,
        onSuccess: _onSuccess,
        onSubmissionError: _onError,
      ),
    );
    return const AsyncFormIdle();
  }
  
  void _onStart() {
    print('Starting registration...');
  }
  
  void _onSuccess(RegistrationResponse response, RegistrationRequest request) {
    ref.read(authProvider.notifier).setUser(response.user);
    analytics.logEvent('registration_success');
  }
  
  void _onError(Object error, StackTrace stackTrace) {
    errorTracking.log('Registration failed', error, stackTrace);
  }
  
  @override
  List<String> validateField(String fieldName, dynamic value) {
    switch (fieldName) {
      case 'email':
        if (!value.toString().contains('@company.com')) {
          return ['Must use company email'];
        }
        break;
      case 'password':
        if (value.toString().length < 8) {
          return ['Password must be at least 8 characters'];
        }
        break;
      case 'password_confirmation':
        final password = formKey.currentState?.fields['password']?.value;
        if (value != password) {
          return ['Passwords do not match'];
        }
        break;
    }
    return [];
  }
  
  @override
  RegistrationRequest decoder(Map<String, dynamic> json) {
    return RegistrationRequest.fromJson(json);
  }
  
  @override
  Future<RegistrationResponse> action(RegistrationRequest data) async {
    try {
      return await ref.read(apiServiceProvider).register(data);
    } on ValidationException catch (e) {
      invalidateFormFields(e.fieldErrors);
      rethrow;
    }
  }
}
```

---

## Related Documentation

- [Simple Forms Guide](FORMS_SIMPLE.md) - Learn useJetForm
- [Form Fields Reference](FORM_FIELDS.md) - All field types
- [Main Forms Documentation](FORMS.md) - Overview

---

Happy advanced form building! 🚀

