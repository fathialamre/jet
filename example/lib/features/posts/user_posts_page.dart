import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';
import 'models/post.dart';
import 'posts_service.dart';

/// Provider family for fetching posts by user ID
final userPostsProvider = FutureProvider.autoDispose.family<List<Post>, int>((
  ref,
  userId,
) async {
  final postsService = ref.watch(postsServiceProvider.notifier);
  final allPosts = await postsService.fetchPosts();

  // Filter posts by user ID
  return allPosts.where((post) => post.userId == userId).toList();
});

/// Example page showing JetBuilder with family provider
@RoutePage()
class UserPostsPage extends StatelessWidget {
  const UserPostsPage({
    super.key,
    @PathParam('userId') required this.userId,
  });

  final int userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts by User $userId'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: JetBuilder.familyList<Post, int>(
        context: context,
        provider: userPostsProvider,
        param: userId,
        itemBuilder: _buildPostCard,
        emptyTitle: 'This user has no posts',
        padding: const EdgeInsets.all(16),
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }

  Widget _buildPostCard(Post post, int index) {
    return Builder(
      builder: (context) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          title: Text(
            post.title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              post.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}
