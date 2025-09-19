import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/resources/theme/notifiers/theme_switcher_notifier.dart';

abstract class BaseThemeSwitcher extends ConsumerStatefulWidget {
  const BaseThemeSwitcher({super.key});

  Widget build(
    BuildContext context,
    WidgetRef ref,
    ThemeSwitcherNotifier notifier,
    ThemeMode state,
  );

  @override
  // ignore: library_private_types_in_public_api
  _BaseThemeSwitcherState createState() => _BaseThemeSwitcherState();
}

class _BaseThemeSwitcherState extends ConsumerState<BaseThemeSwitcher> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(themeSwitcherProvider);
    final notifier = ref.read(themeSwitcherProvider.notifier);
    return widget.build(context, ref, notifier, state);
  }
}
