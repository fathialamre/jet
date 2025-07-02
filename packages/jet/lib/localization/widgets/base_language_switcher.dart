import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/bootstrap/boot.dart';
import 'package:jet/localization/models/locale_info.dart';
import 'package:jet/localization/notifiers/language_switcher_notifier.dart';

/// Abstract base class for language switcher widgets that provides common functionality.
/// 
/// This class handles the state management and data flow for language switching,
/// allowing concrete implementations to focus on UI presentation. It automatically
/// provides access to the current locale, language switcher notifier, and supported locales.
/// 
/// Example usage:
/// ```dart
/// class CustomLanguageSwitcher extends BaseLanguageSwitcher {
///   const CustomLanguageSwitcher({super.key});
/// 
///   @override
///   Widget build(
///     BuildContext context,
///     WidgetRef ref,
///     Locale state,
///     LanguageSwitcherNotifier notifier,
///     List<LocaleInfo> supportedLocales,
///   ) {
///     return ListView.builder(
///       itemCount: supportedLocales.length,
///       itemBuilder: (context, index) {
///         final localeInfo = supportedLocales[index];
///         final isSelected = state.languageCode == localeInfo.locale.languageCode;
///         
///         return ListTile(
///           title: Text(localeInfo.displayName),
///           selected: isSelected,
///           onTap: () => notifier.changeLocale(localeInfo.locale),
///         );
///       },
///     );
///   }
/// }
/// ```
abstract class BaseLanguageSwitcher extends ConsumerStatefulWidget {
  const BaseLanguageSwitcher({super.key});

  /// Build method that concrete implementations must override.
  /// 
  /// This method receives all necessary data for building language switcher UI:
  /// - [context]: The build context for accessing theme and navigation
  /// - [ref]: WidgetRef for accessing Riverpod providers
  /// - [state]: Current locale state from the language switcher provider
  /// - [notifier]: LanguageSwitcherNotifier for changing locales
  /// - [supportedLocales]: List of all supported locales from app configuration
  /// 
  /// Example implementation:
  /// ```dart
  /// @override
  /// Widget build(
  ///   BuildContext context,
  ///   WidgetRef ref,
  ///   Locale state,
  ///   LanguageSwitcherNotifier notifier,
  ///   List<LocaleInfo> supportedLocales,
  /// ) {
  ///   return Column(
  ///     children: supportedLocales.map((localeInfo) {
  ///       return RadioListTile<Locale>(
  ///         value: localeInfo.locale,
  ///         groupValue: state,
  ///         title: Text(localeInfo.displayName),
  ///         onChanged: (locale) {
  ///           if (locale != null) notifier.changeLocale(locale);
  ///         },
  ///       );
  ///     }).toList(),
  ///   );
  /// }
  /// ```
  Widget build(
    BuildContext context,
    WidgetRef ref,
    Locale state,
    LanguageSwitcherNotifier notifier,
    List<LocaleInfo> supportedLocales,
  );

  @override
  // ignore: library_private_types_in_public_api
  _BaseLanguageSwitcherState createState() => _BaseLanguageSwitcherState();
}

/// Internal state class that manages the data flow for language switcher widgets.
/// 
/// This class automatically handles:
/// - Watching the current locale state
/// - Accessing the language switcher notifier
/// - Retrieving supported locales from app configuration
/// - Delegating UI building to the concrete implementation
class _BaseLanguageSwitcherState extends ConsumerState<BaseLanguageSwitcher> {
  @override
  Widget build(BuildContext context) {
    // Watch the current locale state for automatic UI updates
    final state = ref.watch(languageSwitcherProvider);
    
    // Read the notifier for changing locales
    final notifier = ref.read(languageSwitcherProvider.notifier);
    
    // Get the Jet framework instance to access app configuration
    final jet = ref.read(jetProvider);
    
    // Retrieve the list of supported locales from app configuration
    final supportedLocales = jet.config.supportedLocales;
    
    // Delegate UI building to the concrete implementation
    return widget.build(context, ref, state, notifier, supportedLocales);
  }
}
