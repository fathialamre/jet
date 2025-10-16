import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';
import '../../core/router/app_router.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jet Framework Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Login Example
          Card(
            child: ListTile(
              leading: Icon(
                Icons.login,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Login Form'),
              subtitle: const Text('Advanced Forms with JetFormNotifier'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                context.router.push(const LoginRoute());
              },
            ),
          ),
          const SizedBox(height: 8),

          // Big Form Example
          Card(
            color: Colors.green.shade50,
            child: ListTile(
              leading: Icon(
                Icons.speed,
                color: Colors.green.shade700,
              ),
              title: const Text('Big Form (25+ Fields)'),
              subtitle: const Text(
                'Performance optimized with field-specific listeners',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                context.router.push(const BigFormRoute());
              },
            ),
          ),
        ],
      ),
    );
  }
}
