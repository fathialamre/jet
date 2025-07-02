import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/localization/intl/messages.dart';
import 'package:jet/storage/local_storage.dart';

/// Storage key for persisting the selected locale preference
/// 
/// This key is used to save and retrieve the user's language preference
/// from local storage, ensuring the app remembers their choice across sessions.
const String _localeStorageKey = 'selected_locale';

/// Provider that manages locale state with persistence using JetStorage
/// 
/// This provider combines Riverpod state management with local storage persistence
/// to maintain the user's language preference across app restarts.
/// 
/// Usage example:
/// ```dart
/// // Watch the current locale
/// final currentLocale = ref.watch(languageSwitcherProvider);
/// 
/// // Change the locale
/// ref.read(languageSwitcherProvider.notifier).changeLocale(const Locale('ar'));
/// 
/// // Access in widgets
/// Text('Current language: ${currentLocale.languageCode}');
/// ```
/// 
/// The provider automatically:
/// - Loads the saved locale on initialization
/// - Validates that the locale is supported
/// - Persists changes to local storage
/// - Notifies listeners when the locale changes
final languageSwitcherProvider =
    StateNotifierProvider<LanguageSwitcherNotifier, Locale>((
      ref,
    ) {
      return LanguageSwitcherNotifier();
    });

/// State notifier that manages locale switching with persistence
/// 
/// This class handles:
/// - Loading saved locale preferences from storage
/// - Validating that locales are supported by the app
/// - Persisting locale changes to local storage
/// - Managing the current locale state
/// 
/// Example usage:
/// ```dart
/// class MyWidget extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final notifier = ref.read(languageSwitcherProvider.notifier);
///     final currentLocale = ref.watch(languageSwitcherProvider);
///     
///     return ElevatedButton(
///       onPressed: () => notifier.changeLocale(const Locale('ar')),
///       child: Text('Switch to Arabic'),
///     );
///   }
/// }
/// ```
class LanguageSwitcherNotifier extends StateNotifier<Locale> {
  /// Initialize the notifier with a default locale and load saved preferences
  /// 
  /// The constructor:
  /// - Sets English as the default locale
  /// - Immediately loads any previously saved locale from storage
  /// - Validates the loaded locale against supported locales
  /// 
  /// Example:
  /// ```dart
  /// final notifier = LanguageSwitcherNotifier();
  /// // Automatically loads saved locale if available
  /// ```
  LanguageSwitcherNotifier() : super(const Locale('en')) {
    _loadSavedLocale();
  }

  /// Load the saved locale from storage and apply it if valid
  /// 
  /// This method:
  /// - Reads the saved locale code from local storage
  /// - Creates a Locale object from the saved code
  /// - Validates that the locale is supported by the app
  /// - Updates the state if the locale is valid
  /// 
  /// If no saved locale exists or the saved locale is not supported,
  /// the default locale (English) remains active.
  /// 
  /// Example of what gets loaded:
  /// ```dart
  /// // If user previously selected Arabic
  /// // Storage contains: 'selected_locale' -> 'ar'
  /// // This method will load and apply Locale('ar')
  /// ```
  Future<void> _loadSavedLocale() async {
    final savedLocaleCode = JetStorage.read<String>(_localeStorageKey);
    if (savedLocaleCode != null) {
      final locale = Locale(savedLocaleCode);
      if (_isSupportedLocale(locale)) {
        state = locale;
      }
    }
  }

  /// Check if the given locale is supported by the application
  /// 
  /// This method validates that the locale is in the list of supported locales
  /// defined in the app configuration. It compares language codes to ensure
  /// the locale is available for the application.
  /// 
  /// Example:
  /// ```dart
  /// final isSupported = _isSupportedLocale(const Locale('ar')); // true
  /// final isSupported = _isSupportedLocale(const Locale('fr')); // false (if French not configured)
  /// ```
  /// 
  /// @param locale The locale to validate
  /// @return true if the locale is supported, false otherwise
  bool _isSupportedLocale(Locale locale) {
    return JetLocalizationsImpl.supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    );
  }

  /// Change the current locale and persist the selection
  /// 
  /// This method:
  /// - Validates that the new locale is supported
  /// - Updates the current state with the new locale
  /// - Persists the selection to local storage for future app launches
  /// - Notifies all listeners of the change
  /// 
  /// If the locale is not supported, the change is ignored and the current
  /// locale remains active.
  /// 
  /// Example usage:
  /// ```dart
  /// // Switch to Arabic
  /// await notifier.changeLocale(const Locale('ar'));
  /// 
  /// // Switch to English
  /// await notifier.changeLocale(const Locale('en'));
  /// 
  /// // Invalid locale (will be ignored)
  /// await notifier.changeLocale(const Locale('fr')); // No effect if French not supported
  /// ```
  /// 
  /// @param locale The new locale to switch to
  Future<void> changeLocale(Locale locale) async {
    if (_isSupportedLocale(locale)) {
      state = locale;
      await JetStorage.write(_localeStorageKey, locale.languageCode);
    }
  }
}
