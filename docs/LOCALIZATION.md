# Localization Documentation

Complete guide to internationalization in the Jet framework.

## Overview

Jet provides internationalization (i18n) support using Flutter's built-in **[intl](https://pub.dev/packages/intl)** package with custom language switching and RTL (Right-to-Left) support. The system allows you to easily add multiple languages to your app with persistent language preferences.

**Packages Used:**
- **intl** - [pub.dev](https://pub.dev/packages/intl) | [Documentation](https://pub.dev/documentation/intl/latest/) - Internationalization and localization
- **flutter_localizations** - (Flutter SDK) - Flutter's localization support
- **shared_preferences** - [pub.dev](https://pub.dev/packages/shared_preferences) - For language preference storage

**Key Benefits:**
- ✅ Multi-language support with easy setup
- ✅ Persistent language preference across sessions
- ✅ Built-in UI components for language switching
- ✅ RTL (Right-to-Left) support for Arabic, Hebrew, etc.
- ✅ Date and number formatting per locale
- ✅ Riverpod state management integration
- ✅ System locale detection
- ✅ Easy translation file management
- ✅ Plural and gender handling support

## Setup

Configure supported locales in your app configuration:

```dart
class AppConfig extends JetConfig {
  @override
  List<LocaleInfo> get supportedLocales => [
    LocaleInfo(
      locale: const Locale('en'),
      displayName: 'English',
      nativeName: 'English',
    ),
    LocaleInfo(
      locale: const Locale('ar'),
      displayName: 'Arabic',
      nativeName: 'العربية',
    ),
    LocaleInfo(
      locale: const Locale('fr'),
      displayName: 'French',
      nativeName: 'Français',
    ),
  ];
}
```

## Language Switcher UI

### Toggle Button

```dart
AppBar(
  actions: [
    LanguageSwitcher.toggleButton(),
  ],
)
```

### Selection Modal

```dart
LanguageSwitcher.show(context);
```

## Programmatic Control

### Using Riverpod

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(languageSwitcherProvider);
    final localeNotifier = ref.read(languageSwitcherProvider.notifier);
    
    return ElevatedButton(
      onPressed: () => localeNotifier.changeLocale(Locale('ar')),
      child: Text('Switch to Arabic'),
    );
  }
}
```

## Using Translations

Access translations through BuildContext:

```dart
final localizedText = context.jetI10n.confirm;
final cancelText = context.jetI10n.cancel;
```

## Features

- ✅ Persistent locale storage
- ✅ Built-in UI components
- ✅ RTL support
- ✅ Riverpod state management integration

## See Also

- [Configuration Documentation](CONFIGURATION.md)
- [Extensions Documentation](EXTENSIONS.md)

