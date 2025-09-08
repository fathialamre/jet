import 'package:example/core/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/resources/components/tabs/jet_tab.dart';

@RoutePage()
class PackagesPage extends StatelessWidget {
  const PackagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Packages'),
      ),
      body: JetTab.simple(
        children: [
          Text('Limited'),
          Text('Unlimited'),
        ],
        tabs: ['Limited', 'Unlimited'],
      ),
    );
  }
}
