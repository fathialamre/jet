import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/resources/state/jet_consumer.dart';
import 'package:jet/utils/language_switcher/notifiers/language_switcher_notifier.dart';

@RoutePage()
class SettingsPage extends JetConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget jetBuild(BuildContext context, WidgetRef ref, Jet jet) {
    final themeMode = ref.watch(themeSwitcherProvider);
    final currentLocale = ref.watch(languageSwitcherProvider);

    // Find current locale info from supported locales
    final currentLocaleInfo = jet.config.supportedLocales.firstWhere(
      (info) => info.locale.languageCode == currentLocale.languageCode,
      orElse: () => jet.config.supportedLocales.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appearance',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Theme'),
                      subtitle: Text(
                        themeMode == ThemeMode.dark
                            ? 'Dark Mode'
                            : themeMode == ThemeMode.light
                            ? 'Light Mode'
                            : 'System Mode',
                      ),
                      leading: Icon(
                        themeMode == ThemeMode.dark
                            ? Icons.dark_mode
                            : Icons.light_mode,
                      ),
                      trailing: ThemeSwitcher.toggleButton(context),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Language',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Language'),
                      subtitle: Text(
                        'Current: ${currentLocaleInfo.displayName}',
                      ),
                      leading: const Icon(Icons.language),
                      trailing: LanguageSwitcher.toggleButton(),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This is an example app demonstrating the Jet Flutter framework features including theme switching and localization.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
