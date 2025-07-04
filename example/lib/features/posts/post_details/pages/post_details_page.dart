import 'package:example/features/posts/data/models/post_response.dart';
import 'package:example/features/posts/notifiers/posts_notifier.dart';
import 'package:flutter/material.dart';
import 'package:jet/resources/state/jet_state_helpers.dart';

class PostDetailsPage extends StatelessWidget {
  const PostDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
      ),

      body: JetStateHelpers.refreshableItemFamily<PostResponse, int>(
        provider: postsDetailsProvider.call,
        param: 2,
        itemBuilder: (post, widgetRef) => Card(
          child: ListTile(
            title: Text(post.title),
            subtitle: Text(post.body),
          ),
        ),
      ),
    );
  }
}
