import 'package:example/features/posts/notifiers/posts_notifier.dart';
import 'package:example/features/posts/data/models/post_response.dart';
import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/resources/state.dart';

/// Posts page showcasing the new unified JetState API with enhanced error handling
///
/// This example demonstrates:
/// - Using JetState.listFamily for lists with parameters
/// - Automatic pull-to-refresh functionality
/// - Built-in error handling with new JetErrorHandler
/// - Clean, simple syntax with improved error messages
/// - Automatic conversion of exceptions to JetExceptions
class PostsPage extends ConsumerWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            tooltip: 'Infinite Scroll Demo',
            onPressed: () => context.router.push(
              const PageRouteInfo('InfiniteScrollExampleRoute'),
            ),
          ),
        ],
      ),
      body: JetBuilder.familyList<PostResponse, String>(
        provider: postsProvider.call,
        param: '1',
        itemBuilder: (post, index) => Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            onTap: () => context.router.push(
              PageRouteInfo(
                'PostDetailsRoute',
                rawPathParams: {'id': post.id.toString()},
              ),
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text(
                '${index + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              post.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              post.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ),
      ),
    );
  }
}
