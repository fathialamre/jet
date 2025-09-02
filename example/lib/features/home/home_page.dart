import 'package:example/core/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/widgets/widgets/navigation/jet_navigation_hub.dart';

@RoutePage()
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return JetNavigationHub(
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home),
          label: 'Profile',
        ),
        NavigationDestination(
          icon: Icon(Icons.list),
          label: 'Posts',
        ),
      ],
      routes: [
        ProfileRoute(),
        PostsRoute(),
      ],
    );
  }
}
