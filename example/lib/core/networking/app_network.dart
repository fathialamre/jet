import 'package:dio/dio.dart';
import 'package:example/features/posts/data/models/post_response.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/exceptions/exceptions.dart';

/// Enhanced network service with comprehensive error handling
///
/// This example demonstrates:
/// - Integration with Jet error handling system
/// - Proper error conversion and messaging
/// - JetResult pattern for explicit error handling
/// - Graceful error recovery
class AppNetwork extends JetApiService {
  @override
  String get baseUrl => 'https://jsonplaceholder.typicode.com';

  /// Fetch posts with automatic error handling
  ///
  /// The framework will handle errors automatically when used with JetBuilder
  Future<List<PostResponse>> posts() async {
    return await network(
      request: () async {
        final response = await get<List<PostResponse>>(
          '/posts',
          decoder: (data) => (data as List<dynamic>)
              .map((e) => PostResponse.fromJson(e))
              .toList(),
        );
        return response;
      },
    );
  }

  /// Fetch posts with JetResult pattern for explicit error handling
  ///
  /// This approach gives you full control over error handling
  Future<JetResult<List<PostResponse>>> postsWithResult() async {
    try {
      final response = await network(
        request: () async {
          final response = await get<List<PostResponse>>(
            '/posts',
            decoder: (data) => (data as List<dynamic>)
                .map((e) => PostResponse.fromJson(e))
                .toList(),
          );
          return response;
        },
      );
      return JetResult.success(response);
    } catch (error, stackTrace) {
      // Convert to appropriate JetException
      JetException jetException;

      if (error is DioException) {
        switch (error.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.receiveTimeout:
          case DioExceptionType.sendTimeout:
            jetException = JetNetworkException.timeout(
              message: 'Failed to load posts: Request timed out',
              stackTrace: stackTrace,
              originalError: error,
            );
            break;
          case DioExceptionType.connectionError:
            jetException = JetNetworkException.noConnection(
              message: 'Failed to load posts: No internet connection',
              stackTrace: stackTrace,
              originalError: error,
            );
            break;
          case DioExceptionType.badResponse:
            final statusCode = error.response?.statusCode ?? 0;
            if (statusCode >= 500) {
              jetException = JetNetworkException.serverError(
                statusCode: statusCode,
                message: 'Failed to load posts: Server error',
                stackTrace: stackTrace,
                originalError: error,
              );
            } else {
              jetException = JetNetworkException.clientError(
                statusCode: statusCode,
                message: 'Failed to load posts: Client error',
                stackTrace: stackTrace,
                originalError: error,
              );
            }
            break;
          default:
            jetException = JetAppException.unknown(
              message: 'Failed to load posts: Unknown error',
              stackTrace: stackTrace,
              originalError: error,
            );
        }
      } else {
        jetException = JetAppException.unknown(
          message: 'Failed to load posts: Unexpected error',
          stackTrace: stackTrace,
          originalError: error,
        );
      }

      return JetResult.failure(jetException);
    }
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

  /// Fetch single post with JetResult pattern
  ///
  /// Demonstrates handling specific errors like 404 not found
  Future<JetResult<PostResponse>> singlePostWithResult(int id) async {
    try {
      final response = await network(
        request: () async {
          final response = await get<PostResponse>(
            '/posts/$id',
            decoder: (data) => PostResponse.fromJson(data),
          );
          return response;
        },
      );
      return JetResult.success(response);
    } catch (error, stackTrace) {
      // Convert to appropriate JetException with context-specific messages
      JetException jetException;

      if (error is DioException) {
        switch (error.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.receiveTimeout:
          case DioExceptionType.sendTimeout:
            jetException = JetNetworkException.timeout(
              message: 'Loading post is taking too long. Please try again.',
              stackTrace: stackTrace,
              originalError: error,
            );
            break;
          case DioExceptionType.connectionError:
            jetException = JetNetworkException.noConnection(
              message:
                  'Cannot load post. Please check your internet connection.',
              stackTrace: stackTrace,
              originalError: error,
            );
            break;
          case DioExceptionType.badResponse:
            final statusCode = error.response?.statusCode ?? 0;
            if (statusCode == 404) {
              jetException = JetAppException.notFound(
                message: 'Post not found. It may have been deleted or moved.',
                stackTrace: stackTrace,
                originalError: error,
              );
            } else if (statusCode >= 500) {
              jetException = JetNetworkException.serverError(
                statusCode: statusCode,
                message:
                    'Server error while loading post. Please try again later.',
                stackTrace: stackTrace,
                originalError: error,
              );
            } else {
              jetException = JetNetworkException.clientError(
                statusCode: statusCode,
                message: 'Failed to load post. Please try again.',
                stackTrace: stackTrace,
                originalError: error,
              );
            }
            break;
          default:
            jetException = JetAppException.unknown(
              message: 'An unexpected error occurred while loading the post.',
              stackTrace: stackTrace,
              originalError: error,
            );
        }
      } else {
        jetException = JetAppException.unknown(
          message: 'Failed to load post due to an unexpected error.',
          stackTrace: stackTrace,
          originalError: error,
        );
      }

      return JetResult.failure(jetException);
    }
  }

  /// Example method demonstrating validation error handling
  ///
  /// This shows how to handle form validation errors (422 status code)
  Future<JetResult<Map<String, dynamic>>> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
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
      return JetResult.success(response);
    } catch (error, stackTrace) {
      JetException jetException;

      if (error is DioException && error.response?.statusCode == 422) {
        // Handle validation errors
        final responseData = error.response?.data as Map<String, dynamic>?;
        final errors = responseData?['errors'] as Map<String, dynamic>?;

        if (errors != null) {
          final fieldErrors = <String, List<String>>{};
          errors.forEach((key, value) {
            if (value is List) {
              fieldErrors[key] = value.cast<String>();
            }
          });

          jetException = JetValidationException.field(
            fieldErrors: fieldErrors,
            message: 'Please correct the errors below',
            stackTrace: stackTrace,
            originalError: error,
          );
        } else {
          jetException = JetValidationException.form(
            message: 'The form contains invalid data',
            stackTrace: stackTrace,
            originalError: error,
          );
        }
      } else if (error is DioException) {
        // Handle other HTTP errors
        switch (error.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.receiveTimeout:
          case DioExceptionType.sendTimeout:
            jetException = JetNetworkException.timeout(
              message: 'Creating post is taking too long. Please try again.',
              stackTrace: stackTrace,
              originalError: error,
            );
            break;
          case DioExceptionType.connectionError:
            jetException = JetNetworkException.noConnection(
              message:
                  'Cannot create post. Please check your internet connection.',
              stackTrace: stackTrace,
              originalError: error,
            );
            break;
          case DioExceptionType.badResponse:
            final statusCode = error.response?.statusCode ?? 0;
            if (statusCode == 401) {
              jetException = JetAuthException.unauthorized(
                message: 'You must be logged in to create a post.',
                stackTrace: stackTrace,
                originalError: error,
              );
            } else if (statusCode == 403) {
              jetException = JetAuthException.forbidden(
                message: 'You do not have permission to create posts.',
                stackTrace: stackTrace,
                originalError: error,
              );
            } else if (statusCode >= 500) {
              jetException = JetNetworkException.serverError(
                statusCode: statusCode,
                message:
                    'Server error while creating post. Please try again later.',
                stackTrace: stackTrace,
                originalError: error,
              );
            } else {
              jetException = JetNetworkException.clientError(
                statusCode: statusCode,
                message:
                    'Failed to create post. Please check your input and try again.',
                stackTrace: stackTrace,
                originalError: error,
              );
            }
            break;
          default:
            jetException = JetAppException.unknown(
              message: 'An unexpected error occurred while creating the post.',
              stackTrace: stackTrace,
              originalError: error,
            );
        }
      } else {
        jetException = JetAppException.unknown(
          message: 'Failed to create post due to an unexpected error.',
          stackTrace: stackTrace,
          originalError: error,
        );
      }

      return JetResult.failure(jetException);
    }
  }
}

final appNetworkProvider = AutoDisposeProvider<AppNetwork>(
  (ref) => AppNetwork(),
);
