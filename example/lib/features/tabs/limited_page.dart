import 'package:example/core/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';

@RoutePage()
class LimitedPage extends StatelessWidget {
  const LimitedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          Center(child: Text('Limited Page')),
          FilledButton(
            onPressed: () {
              context.router.navigate(UnlimitedRoute());
            },
            child: Text('Go to Unlimited Page'),
          ),
        ],
      ),
    );
  }
}
