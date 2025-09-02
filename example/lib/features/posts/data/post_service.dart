import 'package:example/core/networking/app_network.dart';
import 'package:example/features/posts/data/models/post_response.dart';
import 'package:jet/jet_framework.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_service.g.dart';

class PostService extends AppNetwork {
  Future<List<PostResponse>> posts() async {
    await Future.delayed(const Duration(seconds: 4));
    final response = await get<List<PostResponse>>(
      '/posts',
      decoder: (data) =>
          (data as List<dynamic>).map((e) => PostResponse.fromJson(e)).toList(),
    );
    return response.data ?? [];
  }

  /// Fetch single post with automatic error handling
  Future<PostResponse> singlePost(int id) async {
    final response = await network(
      request: () async {
        final response = await get<PostResponse>(
          '/posts/$id',
          decoder: (data) => PostResponse.fromJson(data),
        );
        return response;
      },
    );
    return response;
  }
}

@riverpod
PostService postService(Ref ref) {
  return PostService();
}
