import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';
import 'posts_service.dart';
import 'models/post.dart';

@RoutePage()
class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: JetBuilder.list<Post>(
        context: context,
        provider: postsServiceProvider,
        itemBuilder: _buildPostCard,
        emptyTitle: 'No posts available',
        padding: const EdgeInsets.all(8),
        separatorBuilder: (context, index) => const SizedBox(height: 8),
      ),
    );
  }

  Widget _buildPostCard(Post post, int index) {
    return Builder(
      builder: (context) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                '${post.id}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
            title: Text(
              post.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                post.body,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: Chip(
              label: Text(
                'User ${post.userId}',
                style: const TextStyle(fontSize: 10),
              ),
              visualDensity: VisualDensity.compact,
            ),
            isThreeLine: true,
            onTap: () => _showPostDetails(context, post),
          ),
        );
      },
    );
  }

  void _showPostDetails(BuildContext context, Post post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Post #${post.id}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                post.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Text(post.body),
              const SizedBox(height: 16),
              Text(
                'User ID: ${post.userId}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
