import 'dart:io';

import 'package:example/core/utilities/environments/prod.dart';
import 'package:example/features/posts/data/models/post_response.dart';
import 'package:jet/jet_framework.dart';

/// Enhanced network service with comprehensive error handling
///
/// This example demonstrates:
/// - Integration with Jet framework
/// - Simple error handling with standard exceptions
/// - Graceful error recovery
class AppNetwork extends JetApiService {
  @override
  String get baseUrl => isDebugMode ? ProdEnv.baseUrl : ProdEnv.baseUrl;

  /// Fetch posts with automatic error handling
  ///
  /// The framework will handle errors automatically when used with JetBuilder
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

  /// Create a new post
  Future<Map<String, dynamic>> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    final response = await network(
      request: () async {
        final response = await post<Map<String, dynamic>>(
          '/posts',
          data: {
            'title': title,
            'body': body,
            'userId': userId,
          },
          decoder: (data) => data as Map<String, dynamic>,
        );
        return response;
      },
    );
    return response;
  }
}

final appNetworkProvider = AutoDisposeProvider<AppNetwork>(
  (ref) => AppNetwork(),
);
