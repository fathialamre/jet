import 'package:example/core/networking/app_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/post.dart';

part 'posts_service.g.dart';

/// Posts service that uses Jet's networking layer
///
/// This service demonstrates:
/// - Integration with JetApiService
/// - Automatic error handling via JetErrorHandler
/// - Async state management with Riverpod
///
/// **Error Handling:**
/// All errors from network requests are automatically converted to JetError
/// by JetErrorHandler. No need to wrap calls in try-catch unless you want
/// to handle specific errors differently. Errors propagate to Riverpod's
/// AsyncValue which handles loading/error/data states automatically.
@riverpod
class PostsService extends _$PostsService {
  @override
  FutureOr<List<Post>> build() async {
    return fetchPosts();
  }

  /// Fetches all posts from JSONPlaceholder API
  ///
  /// Errors are automatically handled by JetErrorHandler and converted to JetError
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

  /// Fetches a single post by ID
  ///
  /// Errors are automatically handled by JetErrorHandler and converted to JetError
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

  /// Refreshes the posts list
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => fetchPosts());
  }
}
