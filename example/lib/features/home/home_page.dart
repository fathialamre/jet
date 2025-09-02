import 'package:example/core/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/session/auth_provider.dart';

@RoutePage()
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jet Vertical Slider Demo'),
      ),
      body: Column(
        children: [
          JetButton.outlined(
            text: 'Login',
            onTap: () async {
              await ref.read(authProvider.notifier).loginAsGuest();
            },
          ),
          Text("aaa"),
          JetButton.outlined(
            text: 'Profile',
            onTap: () async {
              context.router.push(ProfileRoute());
            },
          ),
          Text("aaa"),
        ],
      ),
    );
  }
}
