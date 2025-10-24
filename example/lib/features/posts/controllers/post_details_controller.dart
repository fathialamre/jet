import 'package:example/features/posts/models/post.dart';
import 'package:example/features/posts/services/posts_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_details_controller.g.dart';

@riverpod
class PostDetailsController extends _$PostDetailsController {
  @override
  Future<Post?> build(int id) {
    return fetchPostById(id);
  }

  Future<Post?> fetchPostById(int id) async {
    final service = ref.watch(postsServiceProvider.notifier);
    return await service.fetchPostById(id);
  }
}
