import 'package:example/features/posts/notifiers/posts_notifier.dart';
import 'package:example/features/posts/data/models/post_response.dart';
import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';

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
      body:
          JetAsyncRefreshableWidget.autoDisposeFutureProviderFamily<
            List<PostResponse>,
            String
          >(
            provider: postsProvider.call,
            param: '1',
            builder: (data, ref) => ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) => ListTile(
                onTap: () => context.router.push(
                  PageRouteInfo(
                    'PostDetailsRoute',
                    rawPathParams: {'id': data[index].id.toString()},
                  ),
                ),
                title: Text(data[index].title),
                subtitle: Text(data[index].body),
              ),
            ),
          ),
    );
  }
}
