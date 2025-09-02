import 'package:example/core/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:jet/helpers/jet_logger.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/session/auth_provider.dart';
import 'package:jet/session/session.dart';

@RoutePage()
class LoginPage extends ConsumerWidget {
  final Function(bool)? onResult;

  const LoginPage({super.key, this.onResult});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        actions: [
          ThemeSwitcher.toggleButton(context),
          LanguageSwitcher.toggleButton(),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          JetButton.textButton(
            text: 'Login',
            onTap: () async {
              await ref.read(authProvider.notifier).loginAsGuest();
              if (context.mounted) {
                context.router.replaceAll([HomeRoute()]);
              }
            },
          ),
          JetButton.textButton(
            text: 'Login As Admin',
            onTap: () async {
              await ref
                  .read(authProvider.notifier)
                  .login(
                    Session(token: 'admin', isGuest: false, name: 'Admin'),
                  );
              if (context.mounted) {
                if (onResult != null) {
                  onResult?.call(true);
                } else {
                  context.router.replaceAll([HomeRoute()]);
                }
              }
            },
          ),
          JetButton.textButton(
            text: 'Logout',
            onTap: () async {
              await ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
    );
  }
}
