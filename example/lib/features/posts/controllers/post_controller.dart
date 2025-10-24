import 'package:example/features/posts/models/post.dart';
import 'package:example/features/posts/services/posts_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_controller.g.dart';

@riverpod
class PostController extends _$PostController {
  @override
  FutureOr<List<Post>> build() {
    return fetchPosts();
  }

  Future<List<Post>> fetchPosts() async {
    final service = ref.read(postsServiceProvider.notifier);
    return await service.fetchPosts();
  }
}
