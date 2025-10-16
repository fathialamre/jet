import 'package:example/core/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/resources/state/jet_consumer.dart';

@RoutePage()
class HomePage extends JetConsumerWidget {
  const HomePage({super.key});

  @override
  Widget jetBuild(BuildContext context, WidgetRef ref, Jet jet) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jet Framework Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.router.push(SettingsRoute()),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  _ExampleCard(
                    title: 'Login Form (useJetForm)',
                    description:
                        'Simple login form using useJetForm hook - zero boilerplate',
                    icon: Icons.login,
                    onTap: () => context.router.push(LoginRoute()),
                  ),
                  const SizedBox(height: 12),
                  _ExampleCard(
                    title: 'Simple Todo (useJetForm)',
                    description:
                        'Todo form with useJetForm hook - no separate notifier',
                    icon: Icons.check_circle_outline,
                    onTap: () => context.router.push(SimpleTodoRoute()),
                  ),
                  const SizedBox(height: 12),
                  _ExampleCard(
                    title: 'Todo Form (JetFormNotifier)',
                    description:
                        'Traditional form with JetFormNotifier and Riverpod generator',
                    icon: Icons.checklist,
                    onTap: () => context.router.push(TodoRoute()),
                  ),
                  const SizedBox(height: 12),
                  _ExampleCard(
                    title: 'Settings',
                    description: 'Theme switching and localization examples',
                    icon: Icons.settings,
                    onTap: () => context.router.push(SettingsRoute()),
                  ),
                  const SizedBox(height: 12),
                  _ExampleCard(
                    title: 'Notifications',
                    description:
                        'Local notifications with JetNotifications class',
                    icon: Icons.notifications,
                    onTap: () =>
                        context.router.push(NotificationsExampleRoute()),
                  ),
                  const SizedBox(height: 12),
                  _ExampleCard(
                    title: 'Carousel (JetCarousel)',
                    description:
                        'Feature-rich carousel with auto-play, infinite scroll, and indicators',
                    icon: Icons.view_carousel,
                    onTap: () => context.router.push(CarouselExampleRoute()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _ExampleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
