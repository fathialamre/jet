import 'package:example/features/posts/controllers/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';

@RoutePage()
class PostsPage extends ConsumerWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: JetBuilder.list(
        provider: postControllerProvider,
        itemBuilder: (post, index, ) => ListTile(
          title: Text(post.title),
        ), context: context,
      ),
    );
  }
}
