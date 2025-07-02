import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/jet.dart';
import 'package:jet/localization/intl/messages.dart';
import 'package:jet/localization/widgets/language_switcher.dart';
import 'package:jet/resources/theme/theme_switcher.dart';

class JetMain extends ConsumerWidget {
  const JetMain({
    super.key,
    required this.jet,
  });
  final Jet jet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(jet.routerProvider);
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(currentThemeModeProvider);

    return MaterialApp.router(
      routerConfig: router.config(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        JetLocalizationsDelegate(),
        ...jet.config.localizationsDelegates,
      ],
      supportedLocales: jet.config.supportedLocales,
      locale: locale,
      theme: jet.config.theme,
      darkTheme: jet.config.darkTheme,
      themeMode: themeMode,
    );
  }
}
