import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

import '/themes/base_theme_config.dart';
import '/helpers/extensions.dart';
import 'helper.dart';

/// Helper to find correct color from the [context].
class NyColor {
  final Color? light;
  final Color? dark;

  NyColor({this.light, this.dark});

  /// Get the color based on the device mode
  Color? toColor(BuildContext context) {
    return resolveColor(context, light: light, dark: dark);
  }

  /// Get the color based on the device mode
  static Color? resolveColor(BuildContext context,
      {Color? light, Color? dark}) {
    bool isDarkModeEnabled = false;
    ThemeController themeController = ThemeProvider.controllerOf(context);

    if (themeController.currentThemeId == getEnv('DARK_THEME_ID')) {
      isDarkModeEnabled = true;
    }

    if ((themeController.theme.options as NyThemeOptions).meta is Map &&
        (themeController.theme.options as NyThemeOptions).meta['type'] ==
            NyThemeType.dark) {
      isDarkModeEnabled = true;
    }

    if (context.isDeviceInDarkMode) {
      isDarkModeEnabled = true;
    }

    if (isDarkModeEnabled) {
      return dark;
    }

    return light;
  }
}
