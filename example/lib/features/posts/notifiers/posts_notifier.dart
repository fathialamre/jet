import 'package:dio/dio.dart';
import 'package:example/core/networking/app_network.dart';
import 'package:example/features/posts/data/models/post_response.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/exceptions/exceptions.dart';

/// Posts provider with comprehensive error handling using JetResult
///
/// This example demonstrates:
/// - Using JetResult for explicit error handling
/// - Proper exception handling with JetException types
/// - Graceful error recovery with meaningful error messages
final postsResultProvider =
    AutoDisposeFutureProvider.family<JetResult<List<PostResponse>>, String>(
      (ref, params) async {
        try {
          await Future.delayed(const Duration(seconds: 1));

          // Simulate potential network failure for demonstration
          // Uncomment the next line to test error handling:
          // if (params == 'error') throw Exception('Network error occurred');

          final posts = await ref.read(appNetworkProvider).posts();
          return JetResult.success(posts);
        } catch (error, stackTrace) {
          // Convert common errors to specific JetExceptions
          // The JetErrorHandler will be used by JetBuilder when displaying errors
          JetException jetException;

          if (error is DioException) {
            switch (error.type) {
              case DioExceptionType.connectionTimeout:
              case DioExceptionType.receiveTimeout:
              case DioExceptionType.sendTimeout:
                jetException = JetNetworkException.timeout(
                  message: 'Request timed out. Please try again.',
                  stackTrace: stackTrace,
                  originalError: error,
                );
                break;
              case DioExceptionType.connectionError:
                jetException = JetNetworkException.noConnection(
                  message: 'No internet connection. Please check your network.',
                  stackTrace: stackTrace,
                  originalError: error,
                );
                break;
              default:
                jetException = JetNetworkException.serverError(
                  statusCode: error.response?.statusCode ?? 0,
                  message: 'Failed to load posts. Please try again.',
                  stackTrace: stackTrace,
                  originalError: error,
                );
            }
          } else {
            jetException = JetAppException.unknown(
              message: 'An unexpected error occurred.',
              stackTrace: stackTrace,
              originalError: error,
            );
          }

          return JetResult.failure(jetException);
        }
      },
    );

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

        // The JetBuilder will automatically convert any thrown exception
        // to a JetException using the configured error handler
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
