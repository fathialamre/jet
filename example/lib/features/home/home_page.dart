import 'package:example/core/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jet Framework Examples'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Jet Framework Examples',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explore interactive examples showcasing Jet framework features and patterns.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Examples Section
          Text(
            'Interactive Examples',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),

          // Form Examples
          _buildExampleCard(
            context,
            icon: Icons.input,
            title: 'Form Inputs',
            description:
                'Explore various form input components and validation patterns',
            onTap: () => context.router.push(InputsExampleRoute()),
          ),

          // Form Patterns Example
          _buildExampleCard(
            context,
            icon: Icons.assignment,
            title: 'Advanced Form Patterns',
            description:
                'Complex forms with validation, error handling, and lifecycle callbacks',
            onTap: () => _showComingSoon(context),
            badge: 'COMING SOON',
            badgeColor: Colors.orange,
          ),

          // State Management Example
          _buildExampleCard(
            context,
            icon: Icons.storage,
            title: 'State Management',
            description:
                'Riverpod integration patterns and reactive state updates',
            onTap: () => _showComingSoon(context),
            badge: 'COMING SOON',
            badgeColor: Colors.orange,
          ),

          // Navigation Example
          _buildExampleCard(
            context,
            icon: Icons.navigation,
            title: 'Navigation & Routing',
            description: 'AutoRoute integration and navigation patterns',
            onTap: () => _showComingSoon(context),
            badge: 'COMING SOON',
            badgeColor: Colors.orange,
          ),

          // API Integration Example
          _buildExampleCard(
            context,
            icon: Icons.api,
            title: 'API Integration',
            description:
                'HTTP clients, error handling, and response management',
            onTap: () => _showComingSoon(context),
            badge: 'COMING SOON',
            badgeColor: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    String? badge,
    Color? badgeColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Row(
          children: [
            Expanded(child: Text(title)),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeColor ?? Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This example is coming soon! 🚀'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
