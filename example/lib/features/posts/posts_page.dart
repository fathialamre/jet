import 'package:example/core/router/app_router.gr.dart';
import 'package:example/features/posts/notifiers/posts_notifier.dart';
import 'package:example/features/posts/data/models/post_response.dart';
import 'package:flutter/material.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/extensions/text_extensions.dart';
import 'package:jet/helpers/jet_logger.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/resources/components/jet_empty_widget.dart';
import 'package:jet/resources/state.dart';

/// Posts page showcasing the new unified JetState API with enhanced error handling
///
/// This example demonstrates:
/// - Using JetState.listFamily for lists with parameters
/// - Automatic pull-to-refresh functionality
/// - Built-in error handling with new JetErrorHandler
/// - Clean, simple syntax with improved error messages
/// - Automatic conversion of exceptions to JetExceptions

@RoutePage()
class PostsPage extends ConsumerWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              LanguageSwitcher.show(context);
            },
          ),
        ],
      ),
      body: JetBuilder.list(
        provider: postsNotifierProvider,
        context: context,
        itemBuilder: (PostResponse post, int index) => ListTile(
          onTap: () => context.router.push(
            PostDetailsRoute(post: post),
          ),
          title: Text(
            post.title,
          ).labelLarge(context).bold().color(Colors.red),
          subtitle: Text(
            post.body,
          ).bodyLarge(context),
        ),
      ),
    );
  }
}
