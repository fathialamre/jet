import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/config/jet_config.dart';
import 'package:jet/localization/intl/messages.dart';
import 'package:jet/widgets/main/jet_base_app.dart';

class JetApp extends BaseJetApp {
  const JetApp({super.key, required super.jet});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    RootStackRouter router,
    Locale locale,
    ThemeMode themeMode,
    JetConfig config,
  ) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp.router(
          routerConfig: router.config(
            //TODO: Add navigator observers
            navigatorObservers: () => [],
          ),

          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            JetLocalizationsDelegate(),
            ...config.localizationsDelegates,
          ],
          supportedLocales: config.supportedLocales
              .map((e) => e.locale)
              .toList(),
          locale: locale,
          theme: config.getTheme(),
          darkTheme: config.getDarkTheme(),
          themeMode: themeMode,
        );
      }
    );
  }
}
