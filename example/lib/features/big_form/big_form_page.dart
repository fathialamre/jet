import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/jet_framework.dart';

/// Demonstrates a large form with 25+ fields using JetFormMixin
/// Shows performance optimizations with field-specific listeners
@RoutePage()
class BigFormPage extends ConsumerWidget {
  const BigFormPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Big Form Example'),
            Text(
              '25+ fields with optimizations',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Performance info card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.speed, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Performance Optimized',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Field-specific listeners (only rebuild when needed)\n'
                      '• Validation caching for complex values\n'
                      '• Circular update protection\n'
                      '• Smart change notifications',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // The actual form
            JetFormConsumer<UserProfileRequest, UserProfileResponse>(
              provider: userProfileFormProvider,
              onSuccess: (response, request) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Profile saved successfully! User ID: ${response.userId}',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              onError: (error, stackTrace, invalidateFields) {
                final jetError = error is JetError
                    ? error
                    : JetError.unknown(message: error.toString());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${jetError.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              builder: (context, ref, form, formState) => [
                // Personal Information Section
                const SectionHeader(title: 'Personal Information'),
                JetTextField(
                  name: 'firstName',
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: JetValidators.compose([
                    JetValidators.required(),
                    JetValidators.minLength(2),
                  ]),
                ),
                const SizedBox(height: 16),

                JetTextField(
                  name: 'lastName',
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: JetValidators.compose([
                    JetValidators.required(),
                    JetValidators.minLength(2),
                  ]),
                ),
                const SizedBox(height: 16),

                JetTextField(
                  name: 'middleName',
                  decoration: const InputDecoration(
                    labelText: 'Middle Name (Optional)',
                    prefixIcon: Icon(Icons.person_pin),
                  ),
                ),
                const SizedBox(height: 16),

                JetDateTimePicker(
                  name: 'dateOfBirth',
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: JetValidators.required(),
                  firstDate: DateTime(1920),
                  lastDate: DateTime.now(),
                ),
                const SizedBox(height: 16),

                JetDropdown<String>(
                  name: 'gender',
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(Icons.wc),
                  ),
                  options: const [
                    JetFormOption(value: 'male', child: Text('Male')),
                    JetFormOption(value: 'female', child: Text('Female')),
                    JetFormOption(value: 'other', child: Text('Other')),
                    JetFormOption(
                      value: 'prefer_not_to_say',
                      child: Text('Prefer not to say'),
                    ),
                  ],
                  validator: JetValidators.required(),
                ),
                const SizedBox(height: 24),

                // Contact Information Section
                const SectionHeader(title: 'Contact Information'),
                JetTextField(
                  name: 'email',
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: JetValidators.compose([
                    JetValidators.required(),
                    JetValidators.email(),
                  ]),
                ),
                const SizedBox(height: 16),

                JetPhoneField(
                  name: 'phone',
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  isRequired: true,
                ),
                const SizedBox(height: 16),

                JetPhoneField(
                  name: 'alternatePhone',
                  decoration: const InputDecoration(
                    labelText: 'Alternate Phone (Optional)',
                    prefixIcon: Icon(Icons.phone_android),
                  ),
                  isRequired: false,
                ),
                const SizedBox(height: 24),

                // Address Section
                const SectionHeader(title: 'Address'),
                JetTextField(
                  name: 'street',
                  decoration: const InputDecoration(
                    labelText: 'Street Address',
                    prefixIcon: Icon(Icons.home),
                  ),
                  validator: JetValidators.required(),
                ),
                const SizedBox(height: 16),

                JetTextField(
                  name: 'apartment',
                  decoration: const InputDecoration(
                    labelText: 'Apartment/Suite (Optional)',
                    prefixIcon: Icon(Icons.apartment),
                  ),
                ),
                const SizedBox(height: 16),

                JetTextField(
                  name: 'city',
                  decoration: const InputDecoration(
                    labelText: 'City',
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  validator: JetValidators.required(),
                ),
                const SizedBox(height: 16),

                JetTextField(
                  name: 'state',
                  decoration: const InputDecoration(
                    labelText: 'State/Province',
                    prefixIcon: Icon(Icons.map),
                  ),
                  validator: JetValidators.required(),
                ),
                const SizedBox(height: 16),

                JetTextField(
                  name: 'zipCode',
                  decoration: const InputDecoration(
                    labelText: 'ZIP/Postal Code',
                    prefixIcon: Icon(Icons.pin_drop),
                  ),
                  validator: JetValidators.compose([
                    JetValidators.required(),
                    JetValidators.minLength(5),
                  ]),
                ),
                const SizedBox(height: 16),

                JetDropdown<String>(
                  name: 'country',
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    prefixIcon: Icon(Icons.public),
                  ),
                  options: const [
                    JetFormOption(value: 'US', child: Text('United States')),
                    JetFormOption(value: 'CA', child: Text('Canada')),
                    JetFormOption(value: 'UK', child: Text('United Kingdom')),
                    JetFormOption(value: 'AU', child: Text('Australia')),
                    JetFormOption(value: 'DE', child: Text('Germany')),
                    JetFormOption(value: 'FR', child: Text('France')),
                    JetFormOption(value: 'JP', child: Text('Japan')),
                  ],
                  validator: JetValidators.required(),
                ),
                const SizedBox(height: 24),

                // Professional Information Section
                const SectionHeader(title: 'Professional Information'),
                JetTextField(
                  name: 'company',
                  decoration: const InputDecoration(
                    labelText: 'Company Name',
                    prefixIcon: Icon(Icons.business),
                  ),
                ),
                const SizedBox(height: 16),

                JetTextField(
                  name: 'jobTitle',
                  decoration: const InputDecoration(
                    labelText: 'Job Title',
                    prefixIcon: Icon(Icons.work),
                  ),
                ),
                const SizedBox(height: 16),

                JetDropdown<String>(
                  name: 'industry',
                  decoration: const InputDecoration(
                    labelText: 'Industry',
                    prefixIcon: Icon(Icons.category),
                  ),
                  options: const [
                    JetFormOption(value: 'tech', child: Text('Technology')),
                    JetFormOption(value: 'finance', child: Text('Finance')),
                    JetFormOption(
                      value: 'healthcare',
                      child: Text('Healthcare'),
                    ),
                    JetFormOption(value: 'education', child: Text('Education')),
                    JetFormOption(value: 'retail', child: Text('Retail')),
                    JetFormOption(
                      value: 'manufacturing',
                      child: Text('Manufacturing'),
                    ),
                    JetFormOption(value: 'other', child: Text('Other')),
                  ],
                ),
                const SizedBox(height: 16),

                JetTextField(
                  name: 'linkedinUrl',
                  decoration: const InputDecoration(
                    labelText: 'LinkedIn URL (Optional)',
                    prefixIcon: Icon(Icons.link),
                  ),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 24),

                // Preferences Section
                const SectionHeader(title: 'Preferences'),
                JetCheckboxGroup(
                  name: 'interests',
                  decoration: const InputDecoration(
                    labelText: 'Interests (Select multiple)',
                  ),
                  options: const [
                    JetFormOption(value: 'sports', child: Text('Sports')),
                    JetFormOption(value: 'music', child: Text('Music')),
                    JetFormOption(
                      value: 'technology',
                      child: Text('Technology'),
                    ),
                    JetFormOption(value: 'travel', child: Text('Travel')),
                    JetFormOption(value: 'reading', child: Text('Reading')),
                    JetFormOption(value: 'cooking', child: Text('Cooking')),
                  ],
                ),
                const SizedBox(height: 16),

                JetSwitch(
                  name: 'newsletter',
                  title: const Text('Subscribe to Newsletter'),
                  initialValue: true,
                ),
                const SizedBox(height: 16),

                JetSwitch(
                  name: 'notifications',
                  title: const Text('Enable Push Notifications'),
                  initialValue: false,
                ),
                const SizedBox(height: 16),

                JetTextField(
                  name: 'bio',
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    prefixIcon: Icon(Icons.description),
                    hintText: 'Tell us about yourself...',
                  ),
                  maxLines: 4,
                  validator: JetValidators.maxLength(500),
                ),
                const SizedBox(height: 24),

                // Field-specific listeners demo
                const SectionHeader(title: 'Form State (Live Updates)'),

                // Listener only for firstName and lastName
                JetFormChangeListener(
                  form: ref.read(userProfileFormProvider.notifier),
                  listenToFields: const ['firstName', 'lastName'],
                  builder: (context) {
                    final formState = ref
                        .read(userProfileFormProvider.notifier)
                        .formKey
                        .currentState;
                    final firstName =
                        formState?.instantValue['firstName'] ?? '';
                    final lastName = formState?.instantValue['lastName'] ?? '';

                    return Card(
                      color: Colors.green.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Full Name Preview (Updates only on firstName/lastName change)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              firstName.isEmpty && lastName.isEmpty
                                  ? 'Type your name above...'
                                  : '$firstName $lastName',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Listener for email only
                JetFormChangeListener(
                  form: ref.read(userProfileFormProvider.notifier),
                  listenToFields: const ['email'],
                  builder: (context) {
                    final formState = ref
                        .read(userProfileFormProvider.notifier)
                        .formKey
                        .currentState;
                    final email = formState?.instantValue['email'] ?? '';
                    final isValid = email.contains('@') && email.contains('.');

                    return Card(
                      color: isValid
                          ? Colors.green.shade50
                          : Colors.orange.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(
                              isValid ? Icons.check_circle : Icons.warning,
                              color: isValid ? Colors.green : Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                isValid
                                    ? 'Email format looks good!'
                                    : email.isEmpty
                                    ? 'Enter your email...'
                                    : 'Email format needs attention',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isValid
                                      ? Colors.green.shade700
                                      : Colors.orange.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
              submitButtonText: 'Save Profile',
            ),
          ],
        ),
      ),
    );
  }
}

/// Section header widget for organizing form sections
class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

// Models
class UserProfileRequest {
  final String firstName;
  final String lastName;
  final String? middleName;
  final DateTime? dateOfBirth;
  final String? gender;
  final String email;
  final String phone;
  final String? alternatePhone;
  final String street;
  final String? apartment;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String? company;
  final String? jobTitle;
  final String? industry;
  final String? linkedinUrl;
  final List<String>? interests;
  final bool newsletter;
  final bool notifications;
  final String? bio;

  UserProfileRequest({
    required this.firstName,
    required this.lastName,
    this.middleName,
    this.dateOfBirth,
    this.gender,
    required this.email,
    required this.phone,
    this.alternatePhone,
    required this.street,
    this.apartment,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.company,
    this.jobTitle,
    this.industry,
    this.linkedinUrl,
    this.interests,
    required this.newsletter,
    required this.notifications,
    this.bio,
  });

  factory UserProfileRequest.fromJson(Map<String, dynamic> json) {
    return UserProfileRequest(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      middleName: json['middleName'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      gender: json['gender'] as String?,
      email: json['email'] as String,
      phone: json['phone'] as String,
      alternatePhone: json['alternatePhone'] as String?,
      street: json['street'] as String,
      apartment: json['apartment'] as String?,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
      country: json['country'] as String,
      company: json['company'] as String?,
      jobTitle: json['jobTitle'] as String?,
      industry: json['industry'] as String?,
      linkedinUrl: json['linkedinUrl'] as String?,
      interests: (json['interests'] as List<dynamic>?)?.cast<String>(),
      newsletter: json['newsletter'] as bool? ?? false,
      notifications: json['notifications'] as bool? ?? false,
      bio: json['bio'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      if (middleName != null) 'middleName': middleName,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth!.toIso8601String(),
      if (gender != null) 'gender': gender,
      'email': email,
      'phone': phone,
      if (alternatePhone != null) 'alternatePhone': alternatePhone,
      'street': street,
      if (apartment != null) 'apartment': apartment,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      if (company != null) 'company': company,
      if (jobTitle != null) 'jobTitle': jobTitle,
      if (industry != null) 'industry': industry,
      if (linkedinUrl != null) 'linkedinUrl': linkedinUrl,
      if (interests != null) 'interests': interests,
      'newsletter': newsletter,
      'notifications': notifications,
      if (bio != null) 'bio': bio,
    };
  }
}

class UserProfileResponse {
  final String userId;
  final String message;

  UserProfileResponse({
    required this.userId,
    required this.message,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      userId: json['userId'] as String,
      message: json['message'] as String,
    );
  }
}

// Form Notifier using JetFormMixin
final userProfileFormProvider =
    NotifierProvider<
      UserProfileFormNotifier,
      AsyncFormValue<UserProfileRequest, UserProfileResponse>
    >(
      UserProfileFormNotifier.new,
    );

class UserProfileFormNotifier
    extends JetFormNotifier<UserProfileRequest, UserProfileResponse> {
  @override
  AsyncFormValue<UserProfileRequest, UserProfileResponse> build() {
    return const AsyncFormValue.idle();
  }

  @override
  UserProfileRequest decoder(Map<String, dynamic> json) {
    return UserProfileRequest.fromJson(json);
  }

  @override
  Future<UserProfileResponse> action(UserProfileRequest data) async {
    // Simulate API call with delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate successful response
    return UserProfileResponse(
      userId: 'USR-${DateTime.now().millisecondsSinceEpoch}',
      message: 'Profile updated successfully!',
    );

    // Uncomment to simulate error:
    // throw JetError.server(message: 'Failed to update profile');
  }
}
