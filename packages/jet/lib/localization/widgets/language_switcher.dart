import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/localization/intl/messages.dart';
import 'package:jet/storage/local_storage.dart';

const String _localeStorageKey = 'selected_locale';

/// Provider that manages locale state with persistence using JetStorage
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _loadSavedLocale();
  }

  /// Load the saved locale from storage
  Future<void> _loadSavedLocale() async {
    final savedLocaleCode = JetStorage.read<String>(_localeStorageKey);
    if (savedLocaleCode != null) {
      final locale = Locale(savedLocaleCode);
      if (_isSupportedLocale(locale)) {
        state = locale;
      }
    }
  }

  /// Check if the locale is supported
  bool _isSupportedLocale(Locale locale) {
    return JetLocalizationsImpl.supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    );
  }

  /// Change the locale and persist it
  Future<void> changeLocale(Locale locale) async {
    if (_isSupportedLocale(locale)) {
      state = locale;
      await JetStorage.write(_localeStorageKey, locale.languageCode);
    }
  }
}

/// Model class for locale information
class LocaleInfo {
  final Locale locale;
  final String displayName;
  final String nativeName;

  const LocaleInfo({
    required this.locale,
    required this.displayName,
    required this.nativeName,
  });
}

/// Available locales with their display information
class AvailableLocales {
  static const List<LocaleInfo> locales = [
    LocaleInfo(
      locale: Locale('en'),
      displayName: 'English',
      nativeName: 'English',
    ),
    LocaleInfo(
      locale: Locale('ar'),
      displayName: 'Arabic',
      nativeName: 'العربية',
    ),
  ];

  static LocaleInfo? getLocaleInfo(Locale locale) {
    try {
      return locales.firstWhere(
        (info) => info.locale.languageCode == locale.languageCode,
      );
    } catch (e) {
      return null;
    }
  }
}

/// Widget that shows a locale selection bottom sheet
class LanguageSwitcher extends ConsumerWidget {
  const LanguageSwitcher({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const LanguageSwitcher(),
    );
  }

  /// Returns a toggle button widget that triggers the language switcher
  static Widget toggleButton() {
    return const LanguageSwitcherButton();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    JetLocalizationsImpl.of(context);

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.language,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  context.jetI10n.changeLanguage,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                ),
              ],
            ),
          ),

          // Locale options
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: AvailableLocales.locales.length,
            itemBuilder: (context, index) {
              final localeInfo = AvailableLocales.locales[index];
              final isSelected =
                  currentLocale.languageCode == localeInfo.locale.languageCode;

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  child: Center(
                    child: Text(
                      localeInfo.locale.languageCode.toUpperCase(),
                      style: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  localeInfo.displayName,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  localeInfo.nativeName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () async {
                  if (!isSelected) {
                    HapticFeedback.lightImpact();
                    await ref
                        .read(localeProvider.notifier)
                        .changeLocale(localeInfo.locale);
                  }
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              );
            },
          ),

          // Bottom padding
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

/// Simple button widget to trigger the locale selector
class LanguageSwitcherButton extends ConsumerWidget {
  const LanguageSwitcherButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final localeInfo = AvailableLocales.getLocaleInfo(currentLocale);

    return IconButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        LanguageSwitcher.show(context);
      },
      icon: Stack(
        children: [
          const Icon(Icons.language),
          if (localeInfo != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  localeInfo.locale.languageCode.toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      tooltip: 'Change Language',
    );
  }
}
