import 'package:example/features/login/models/login_request.dart';
import 'package:example/features/login/models/login_response.dart';
import 'package:flutter/material.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/forms/forms.dart';
import 'package:jet/helpers/jet_logger.dart';
import 'package:jet/jet_framework.dart';

/// Comprehensive Jet Forms Showcase
///
/// This page demonstrates ALL available Jet form field types including:
/// - Text inputs (TextField)
/// - Date & time pickers
/// - Dropdowns & selections
/// - Checkboxes & switches
/// - Sliders & ranges
/// - Choice chips & filter chips
/// - Radio groups & checkbox groups
@RoutePage()
class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the useJetForm hook to create a form controller inline
    final form = useJetForm<LoginRequest, LoginResponse>(
      ref: ref,
      decoder: (json) => LoginRequest.fromJson(json),
      action: (request) async {
        dump('Form submission: ${request.email}');

        // Simulate API call
        await 2.sleep();

        // Return mock successful response
        return LoginResponse(
          token: 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
          userId: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'John Doe',
          email: request.email,
          loginAt: DateTime.now(),
        );
      },
      onSuccess: (response, request) {
        context.showToast('Form submitted successfully!');
        dump('Success: $response');
      },
      onError: (error, stackTrace) {
        dump('Error: $error');
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jet Forms Showcase'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => form.reset(),
            tooltip: 'Reset Form',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: JetSimpleForm<LoginRequest, LoginResponse>(
          form: form,
          submitButtonText: 'Submit All Fields',
          fieldSpacing: 24,
          children: [
            // Header
            _buildSectionHeader(
              context,
              'Jet Forms Showcase',
              'Comprehensive demonstration of all available form fields',
            ),

            const Divider(height: 32),

            // ====================================================================
            // TEXT INPUTS
            // ====================================================================
            _buildSectionTitle(context, '📝 Text Inputs'),
            const SizedBox(height: 12),

            JetTextField(
              name: 'email',
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email),
                helperText: 'We\'ll never share your email',
              ),
              keyboardType: TextInputType.emailAddress,
              validator: JetValidators.compose([
                JetValidators.required(),
                JetValidators.email(),
              ]),
            ),

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
            ),

            JetTextField(
              name: 'username',
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'Choose a username',
                prefixIcon: Icon(Icons.person),
              ),
              validator: JetValidators.compose([
                JetValidators.required(),
                JetValidators.minLength(3),
              ]),
            ),

            JetTextField(
              name: 'bio',
              decoration: const InputDecoration(
                labelText: 'Bio',
                hintText: 'Tell us about yourself',
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 3,
              maxLength: 200,
              validator: JetValidators.maxLength(200),
            ),

            JetPinField(
              name: 'otp',
              length: 6,
              decoration: const InputDecoration(
                labelText: 'OTP Verification',
                helperText: 'Enter the 6-digit code sent to your email',
              ),
              onCompleted: (pin) {
                dump('OTP entered: $pin');
              },
              validator: JetValidators.compose([
                JetValidators.required(),
                JetValidators.equalLength(6),
              ]),
            ),

            const Divider(height: 32),

            // ====================================================================
            // DATE & TIME PICKERS
            // ====================================================================
            _buildSectionTitle(context, '📅 Date & Time Pickers'),
            const SizedBox(height: 12),

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
            ),

            JetDateTimePicker(
              name: 'appointment_time',
              decoration: const InputDecoration(
                labelText: 'Appointment Time',
                prefixIcon: Icon(Icons.access_time),
              ),
              inputType: DateTimePickerInputType.time,
              hintText: 'Select time',
            ),

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
            ),

            JetDateRangePicker(
              name: 'vacation_dates',
              decoration: const InputDecoration(
                labelText: 'Vacation Dates',
                prefixIcon: Icon(Icons.flight_takeoff),
              ),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              hintText: 'Select date range',
            ),

            const Divider(height: 32),

            // ====================================================================
            // DROPDOWNS & SELECTIONS
            // ====================================================================
            _buildSectionTitle(context, '📋 Dropdowns & Selections'),
            const SizedBox(height: 12),

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
                JetFormOption(value: 'de', child: Text('🇩🇪 Germany')),
              ],
              validator: JetValidators.required(),
            ),

            JetRadioGroup<String>(
              name: 'gender',
              decoration: const InputDecoration(
                labelText: 'Gender',
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
              direction: Axis.horizontal,
              validator: JetValidators.required(),
            ),

            const Divider(height: 32),

            // ====================================================================
            // CHECKBOXES & SWITCHES
            // ====================================================================
            _buildSectionTitle(context, '☑️ Checkboxes & Switches'),
            const SizedBox(height: 12),

            JetCheckbox(
              name: 'terms',
              title: const Text('I agree to the Terms and Conditions'),
              subtitle: const Text('You must accept to continue'),
              validator: JetValidators.equal(
                true,
                errorText: 'You must accept the terms',
              ),
            ),

            JetCheckbox(
              name: 'newsletter',
              title: const Text('Subscribe to newsletter'),
              subtitle: const Text('Receive weekly updates and promotions'),
            ),

            JetCheckbox(
              name: 'marketing',
              title: const Text('Receive marketing emails'),
              subtitle: const Text('Special offers and new features'),
            ),

            const SizedBox(height: 16),

            JetSwitch(
              name: 'notifications',
              title: const Text('Enable push notifications'),
              subtitle: const Text('Get notified about important updates'),
            ),

            JetSwitch(
              name: 'dark_mode',
              title: const Text('Dark mode'),
              subtitle: const Text('Use dark theme'),
            ),

            JetSwitch(
              name: 'location',
              title: const Text('Enable location services'),
              subtitle: const Text('Allow app to access your location'),
            ),

            const Divider(height: 32),

            // ====================================================================
            // CHECKBOX GROUPS
            // ====================================================================
            _buildSectionTitle(context, '☑️ Checkbox Groups'),
            const SizedBox(height: 12),

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
                JetFormOption(value: 'travel', child: Text('✈️ Travel')),
              ],
            ),

            const Divider(height: 32),

            // ====================================================================
            // SLIDERS
            // ====================================================================
            _buildSectionTitle(context, '🎚️ Sliders'),
            const SizedBox(height: 12),

            JetSlider(
              name: 'age',
              decoration: const InputDecoration(
                labelText: 'Age',
              ),
              min: 18,
              max: 100,
              divisions: 82,
              initialValue: 25,
              displayValues: SliderDisplayValues.all,
            ),

            JetSlider(
              name: 'volume',
              decoration: const InputDecoration(
                labelText: 'Volume',
              ),
              min: 0,
              max: 100,
              divisions: 20,
              initialValue: 50,
              displayValues: SliderDisplayValues.all,
            ),

            JetRangeSlider(
              name: 'price_range',
              decoration: const InputDecoration(
                labelText: 'Price Range',
              ),
              min: 0,
              max: 1000,
              divisions: 20,
              initialValue: const RangeValues(100, 500),
              displayValues: SliderDisplayValues.all,
            ),

            const Divider(height: 32),

            // ====================================================================
            // CHIPS
            // ====================================================================
            _buildSectionTitle(context, '🏷️ Chips'),
            const SizedBox(height: 12),

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
            ),

            const SizedBox(height: 16),

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
                JetFormOption(value: 'java', child: Text('Java')),
              ],
            ),

            const Divider(height: 32),

            // ====================================================================
            // FORM STATE DISPLAY
            // ====================================================================
            if (form.hasValue) ...[
              _buildSectionTitle(context, '✅ Success!'),
              const SizedBox(height: 12),
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Form Submitted Successfully!',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'User ID: ${form.response!.userId}',
                        style: TextStyle(color: Colors.green.shade700),
                      ),
                      Text(
                        'Token: ${form.response!.token.substring(0, 20)}...',
                        style: TextStyle(color: Colors.green.shade700),
                      ),
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

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
