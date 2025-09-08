import 'package:example/core/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';

@RoutePage()
class MainLayoutPage extends StatelessWidget {
  const MainLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jet Framework'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
              leading: Icon(Icons.tab),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
              title: Text('Jet Tabs '),
              onTap: () {
                context.router.push(PackagesRoute());
              },
            ),
          ],
        ),
      ),
    );
  }
}
