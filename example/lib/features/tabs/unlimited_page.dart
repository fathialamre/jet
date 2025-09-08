import 'package:example/core/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';

@RoutePage()
class UnlimitedPage extends StatelessWidget {
  const UnlimitedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          Center(child: Text('Unlimited Page')),
          FilledButton(
            onPressed: () {
              context.router.navigate(LimitedRoute());
            },
            child: Text('Go to Limited Page'),
          ),
        ],
      ),
    );
  }
}
