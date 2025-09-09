import 'package:example/core/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';
@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Inputs'),
            onTap: () => context.router.push(InputsExampleRoute()),
          ),
        ],
      ),
    );
  }
}