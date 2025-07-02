import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/config/jet_config.dart';
import 'package:jet/jet.dart';
import 'package:jet/localization/notifiers/language_switcher_notifier.dart';
import 'package:jet/localization/widgets/language_switcher.dart';
import 'package:jet/resources/theme/theme_switcher.dart';

abstract class BaseJetApp extends ConsumerStatefulWidget {
  const BaseJetApp({super.key, required this.jet});
  final Jet jet;

  Widget build(
    BuildContext context,
    WidgetRef ref,
    RootStackRouter router,
    Locale locale,
    ThemeMode themeMode,
    JetConfig config,
  );

  @override
  ConsumerState<BaseJetApp> createState() => _BaseJetAppState();
}

class _BaseJetAppState extends ConsumerState<BaseJetApp> {
  @override
  Widget build(BuildContext context) {
    final RootStackRouter router = ref.watch(widget.jet.routerProvider);
    final Locale locale = ref.watch(languageSwitcherProvider);
    final ThemeMode themeMode = ref.watch(currentThemeModeProvider);
    final JetConfig config = widget.jet.config;

    return widget.build(context, ref, router, locale, themeMode, config);
  }
}
