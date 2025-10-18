import 'package:flutter/material.dart';
import 'package:jet/widgets/theme/bottom_sheet_theme_switcher.dart';
import 'package:jet/widgets/theme/segmented_button_theme_switcher.dart';
import 'package:jet/widgets/theme/toggle_button_switcher.dart';

class ThemeSwitcher {
  static Widget segmentedButton(BuildContext context) {
    return SegmentedButtonThemeSwitcher();
  }

  static Widget toggleButton(BuildContext context) {
    return ToggleButtonSwitcher();
  }

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (context) => BottomSheetThemeSwitcher(),
    );
  }
}
