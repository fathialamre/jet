import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guardo/guardo.dart';
import 'package:jet/forms/localization/jet_form_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/helpers/jet_logger.dart';
import 'package:jet/security/app_locker/app_locker_notifier.dart';
import 'package:jet/jet.dart';
import 'package:jet/localization/intl/messages.dart';
import 'package:jet/localization/notifiers/language_switcher_notifier.dart';
import 'package:jet/resources/theme/notifiers/theme_switcher_notifier.dart';

class JetApp extends ConsumerWidget {
  const JetApp({super.key, required this.jet});

  final Jet jet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch all reactive state
    final router = ref.watch(jet.routerProvider);
    final locale = ref.watch(languageSwitcherProvider);
    final themeMode = ref.watch(currentThemeModeProvider);
    final lockState = ref.watch(appLockProvider);
    final config = jet.config;
    dump(locale, tag: 'locale');

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return Guardo(
          enabled: lockState,
          child: MaterialApp.router(
            routerConfig: router.config(
              navigatorObservers: config.navigatorObservers,
            ),
            title: config.title,
            onGenerateTitle: config.onGenerateTitle,
            color: config.color,
            debugShowCheckedModeBanner: config.debugShowCheckedModeBanner,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              JetLocalizationsDelegate(),
              JetFormLocalizations.delegate,
              ...config.localizationsDelegates,
            ],
            supportedLocales: config.supportedLocales
                .map((e) => e.locale)
                .toList(),
            locale: locale,
            theme: config.getTheme(),
            darkTheme: config.getDarkTheme(),
            themeMode: themeMode,
            highContrastTheme: config.highContrastTheme,
            highContrastDarkTheme: config.highContrastDarkTheme,
            themeAnimationDuration: config.themeAnimationDuration,
            themeAnimationCurve: config.themeAnimationCurve,
            restorationScopeId: config.restorationScopeId,
            scrollBehavior: config.scrollBehavior,
            shortcuts: config.shortcuts,
            actions: config.actions,
            builder: config.builder,
            showPerformanceOverlay: config.showPerformanceOverlay,
            showSemanticsDebugger: config.showSemanticsDebugger,
            checkerboardRasterCacheImages: config.checkerboardRasterCacheImages,
            checkerboardOffscreenLayers: config.checkerboardOffscreenLayers,
          ),
        );
      },
    );
  }
}
