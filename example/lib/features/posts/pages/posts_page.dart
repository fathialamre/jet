import 'package:example/core/router/app_router.dart';
import 'package:example/features/posts/controllers/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';

@RoutePage()
class PostsPage extends ConsumerWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: JetBuilder.list(
        context: context,
        provider: postControllerProvider,
        loadingStyle: LoadingStyle.skeleton,

        skeletonConfig: SkeletonConfig.shimmer(
          duration: Duration(milliseconds: 1500),
        ),
        skeletonBuilder: () => ListView.builder(
          itemCount: 8,
          itemBuilder: (context, index) => Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('Loading post title here...'),
              subtitle: Text('Post subtitle will appear here'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
        ),
        itemBuilder: (post, index) => Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            onTap: () => context.router.push(PostDetailsRoute(id: post.id)),
            title: Text(post.title),
            subtitle: Text(
              post.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }
}
