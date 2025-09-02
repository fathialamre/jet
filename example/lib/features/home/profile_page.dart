import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Center(
        child: Text(''),
      ),
    );
  }
}
