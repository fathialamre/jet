import 'package:example/core/networking/app_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/post.dart';

part 'posts_service.g.dart';

@riverpod
class PostsService extends _$PostsService {
  @override
  build() => null;

  Future<List<Post>> fetchPosts() async {
    final network = ref.read(appNetworkProvider);

    final posts = await network.get<List<Post>>(
      '/posts',
      decoder: (data) {
        if (data is List) {
          return data
              .map((json) => Post.fromJson(json as Map<String, dynamic>))
              .toList();
        }
        return [];
      },
    );

    return posts;
  }

  Future<Post?> fetchPostById(int id) async {
    final network = ref.read(appNetworkProvider);

    final post = await network.get<Post?>(
      '/posts/$id',
      decoder: (data) {
        if (data != null && data is Map<String, dynamic>) {
          return Post.fromJson(data);
        }
        return null;
      },
    );

    return post;
  }
}
