import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/helpers/jet_logger.dart';
import 'package:jet/localization/models/locale_info.dart';
import 'package:jet/localization/notifiers/language_switcher_notifier.dart';
import 'package:jet/localization/widgets/base_language_switcher.dart';

/// Widget that shows a locale selection bottom sheet
class LanguageSwitcher extends BaseLanguageSwitcher {
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
  Widget build(
    BuildContext context,
    WidgetRef ref,
    Locale state,
    LanguageSwitcherNotifier notifier,
    List<LocaleInfo> supportedLocales,
  ) {
    final currentLocale = state;

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
            itemCount: supportedLocales.length,
            itemBuilder: (context, index) {
              final localeInfo = supportedLocales[index];
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

                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () async {
                  if (!isSelected) {
                    HapticFeedback.lightImpact();
                    await notifier.changeLocale(localeInfo.locale, ref);
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
class LanguageSwitcherButton extends BaseLanguageSwitcher {
  const LanguageSwitcherButton({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    Locale state,
    LanguageSwitcherNotifier notifier,
    List<LocaleInfo> supportedLocales,
  ) {
    final localeInfo = supportedLocales.firstWhere(
      (info) => info.locale.languageCode == state.languageCode,
    );

    return IconButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        LanguageSwitcher.show(context);
      },
      icon: Stack(
        children: [
          const Icon(Icons.language),
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
      tooltip: context.jetI10n.changeLanguage,
    );
  }
}
