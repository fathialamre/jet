import 'package:example/features/posts/notifiers/posts_notifier.dart';
import 'package:example/features/posts/data/models/post_response.dart';
import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/resources/state.dart';

/// Posts page showcasing the new unified JetState API
///
/// This example demonstrates:
/// - Using JetState.listFamily for lists with parameters
/// - Automatic pull-to-refresh functionality
/// - Built-in error handling and loading states
/// - Clean, simple syntax
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
        // Optional: Custom loading indicator
        // loading: const Center(child: CircularProgressIndicator()),

        // Optional: Custom error handler
        // error: (error, stack) => Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       const Icon(Icons.error, color: Colors.red, size: 48),
        //       const SizedBox(height: 16),
        //       Text('Failed to load posts: ${error.toString()}'),
        //     ],
        //   ),
        // ),

        // Optional: Custom refresh handler
        // onRefresh: () async {
        //   print('Custom refresh logic here');
        //   ref.invalidate(postsProvider('1'));
        // },
      ),
    );
  }
}
