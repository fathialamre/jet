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
final postsProvider =
    AutoDisposeFutureProvider.family<List<PostResponse>, String>(
      (ref, params) async {
        // Add artificial delay to simulate network call
        await Future.delayed(const Duration(seconds: 1));

        // Simulate potential errors for testing:
        // Uncomment one of these lines to test different error scenarios:

        // Network timeout simulation
        // if (params == 'timeout') {
        //   throw DioException.connectionTimeout(
        //     timeout: const Duration(seconds: 5),
        //     requestOptions: RequestOptions(path: '/posts'),
        //   );
        // }

        // Server error simulation
        // if (params == 'server') {
        //   throw DioException.badResponse(
        //     statusCode: 500,
        //     requestOptions: RequestOptions(path: '/posts'),
        //     response: Response(
        //       requestOptions: RequestOptions(path: '/posts'),
        //       statusCode: 500,
        //       data: {'message': 'Internal server error'},
        //     ),
        //   );
        // }

        // JetBuilder will automatically handle any thrown exceptions
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
    AutoDisposeFutureProvider.family<PostResponse, int>(
      (ref, params) async {
        await Future.delayed(const Duration(seconds: 1));

        // Simulate not found error for certain IDs
        if (params > 100) {
          throw DioException.badResponse(
            statusCode: 404,
            requestOptions: RequestOptions(path: '/posts/$params'),
            response: Response(
              requestOptions: RequestOptions(path: '/posts/$params'),
              statusCode: 404,
              data: {'message': 'Post not found'},
            ),
          );
        }

        return await ref.read(appNetworkProvider).singlePost(params);
      },
    );
