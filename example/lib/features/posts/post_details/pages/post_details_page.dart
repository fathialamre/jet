import 'package:example/core/router/app_router.gr.dart'
    show PostsRoute, ProfileRoute;
import 'package:example/features/posts/data/models/post_response.dart';
import 'package:example/features/posts/notifiers/posts_notifier.dart';
import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/resources/state.dart';

/// Post details page showcasing the new unified JetState API for single items
///
/// This example demonstrates:
/// - Using JetState.itemFamily for single items with parameters
/// - Automatic pull-to-refresh functionality (swipe down to refresh)
/// - Built-in error handling and loading states
/// - Clean, simple syntax
/// - Beautiful card-based UI layout

@RoutePage()
class PostDetailsPage extends StatelessWidget {
  const PostDetailsPage({super.key, required this.post});

  final PostResponse post;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        backgroundColor: Colors.indigo[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => context.router.navigate(ProfileRoute()),
            icon: Icon(Icons.home),
          ),
        ],
      ),
      body: JetBuilder.familyItem<PostResponse, int>(
        provider: postDetailsProvider.call,
        param: post.id,
        builder: (post, ref) {
          return Text(post.body);
        },

        // Optional: Custom loading indicator
        // loading: const Center(
        //   child: CircularProgressIndicator(),
        // ),

        // Optional: Custom error handler
        // error: (error, stack) => Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       const Icon(Icons.error, color: Colors.red, size: 48),
        //       const SizedBox(height: 16),
        //       Text('Failed to load post: ${error.toString()}'),
        //       const SizedBox(height: 16),
        //       ElevatedButton(
        //         onPressed: () => ref.invalidate(postsDetailsProvider(2)),
        //         child: const Text('Retry'),
        //       ),
        //     ],
        //   ),
        // ),

        // Optional: Custom refresh handler
        // onRefresh: () async {
        //   print('Custom refresh logic here');
        //   ref.invalidate(postsDetailsProvider(2));
        // },
      ),
    );
  }
}
