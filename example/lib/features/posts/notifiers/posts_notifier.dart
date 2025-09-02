import 'package:dio/dio.dart';
import 'package:example/core/networking/app_network.dart';
import 'package:example/features/posts/data/models/post_response.dart';
import 'package:jet/jet_framework.dart';

/// Posts provider with automatic error handling (simpler approach)
///
/// This example demonstrates:
/// - Letting JetBuilder handle errors automatically
/// - Clean provider code with minimal error handling
/// - Framework-provided error conversion and UI
final postsProvider = AutoDisposeFutureProvider<List<PostResponse>>(
  (ref) async {
    final posts = await ref.read(appNetworkProvider).posts();
    return posts;
  },
);




/// Post details provider with automatic error handling
///
/// This example demonstrates:
/// - Simple provider that relies on framework error handling
/// - Clean separation of concerns
/// - Automatic retry functionality through JetBuilder
final postsDetailsProvider =
    AutoDisposeFutureProvider.family<PostResponse, PostResponse>(
      (ref, params) async {
        await Future.delayed(const Duration(seconds: 1));

        return await ref.read(appNetworkProvider).singlePost(params.id);
      },
    );
