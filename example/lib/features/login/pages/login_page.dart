import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/localization/notifiers/language_switcher_notifier.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = JetLocalizations.of(context);
    final currentLocale = ref.watch(languageSwitcherProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appName),
        actions: [
          ThemeSwitcher.toggleButton(context),
          LanguageSwitcher.toggleButton(),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome text
            Text(
              'Welcome ${currentLocale.languageCode}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'Current locale: ${currentLocale.languageCode}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 48),

            // Email field
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.email),
              ),
            ),

            const SizedBox(height: 16),

            // Password field
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),
              ),
            ),

            const SizedBox(height: 24),

            // Login button
            ElevatedButton(
              onPressed: () {
                // Login logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Login attempted in ${currentLocale.languageCode}',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Login'),
            ),

            const SizedBox(height: 16),

            ThemeSwitcher.segmentedButton(context),
            TextButton(
              onPressed: () => ThemeSwitcher.show(context),
              child: const Text('Show Theme Switcher'),
            ),
            // Manual bottom sheet trigger
            OutlinedButton.icon(
              onPressed: () => LanguageSwitcher.show(context),
              icon: const Icon(Icons.language),
              label: const Text('Change Language'),
            ),
          ],
        ),
      ),
    );
  }
}
