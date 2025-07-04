import 'package:dio/dio.dart';
import 'jet_api.dart';

/// Example implementation of JetApi for a typical REST API
/// Enhanced with singleton pattern and ResponseModel support
class ExampleApi extends JetApiService {
  // Private constructor for singleton pattern
  ExampleApi._();

  // Singleton instance getter
  static ExampleApi get instance => JetApiService.getInstance<ExampleApi>(
    'ExampleApi',
    () => ExampleApi._(),
  );

  @override
  String get baseUrl => 'https://api.example.com/v1';

  @override
  Map<String, dynamic> get defaultHeaders => {
    ...super.defaultHeaders,
    'User-Agent': 'JetFramework/1.0',
    'X-API-Version': '1.0',
  };

  @override
  List<Interceptor> get interceptors => [
    AuthInterceptor(),
    RetryInterceptor(),
  ];

  @override
  Duration get connectTimeout => const Duration(seconds: 15);

  @override
  Duration get receiveTimeout => const Duration(seconds: 30);

  // Example API methods using the abstract class methods

  /// Get user profile
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    return await network<Map<String, dynamic>>(
      request: () => get<Map<String, dynamic>>(
        '/users/$userId',
        decoder: (data) => data as Map<String, dynamic>,
      ),
    );
  }

  /// Create a new user
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    return await network<Map<String, dynamic>>(
      request: () => post<Map<String, dynamic>>(
        '/users',
        data: userData,
        decoder: (data) => data as Map<String, dynamic>,
      ),
    );
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateUser(
    String userId,
    Map<String, dynamic> userData,
  ) async {
    return await network<Map<String, dynamic>>(
      request: () => put<Map<String, dynamic>>(
        '/users/$userId',
        data: userData,
        decoder: (data) => data as Map<String, dynamic>,
      ),
    );
  }

  /// Delete user
  Future<bool> deleteUser(String userId) async {
    return await network<bool>(
      request: () async {
        final response = await delete<Map<String, dynamic>>(
          '/users/$userId',
          decoder: (data) => data as Map<String, dynamic>,
        );
        return ResponseModel<bool>(
          data: response.success,
          success: response.success,
          statusCode: response.statusCode,
        );
      },
      fallback: false,
    );
  }

  /// Get list of users with pagination
  Future<List<Map<String, dynamic>>> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    return await network<List<Map<String, dynamic>>>(
      request: () => get<List<Map<String, dynamic>>>(
        '/users',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (search != null) 'search': search,
        },
        decoder: (data) => (data['users'] as List).cast<Map<String, dynamic>>(),
      ),
      fallback: [],
    );
  }

  /// Upload user avatar
  Future<Map<String, dynamic>> uploadAvatar(
    String userId,
    String filePath,
  ) async {
    return await network<Map<String, dynamic>>(
      request: () => upload<Map<String, dynamic>>(
        '/users/$userId/avatar',
        FormData.fromMap({
          'avatar': MultipartFile.fromFileSync(filePath),
          'userId': userId,
        }),
        decoder: (data) => data as Map<String, dynamic>,
      ),
    );
  }
}

/// Example authentication interceptor
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add authentication token to requests
    // This is where you'd get the token from secure storage
    final token = _getAuthToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 unauthorized errors
    if (err.response?.statusCode == 401) {
      // Clear stored token and redirect to login
      _clearAuthToken();
      // You might want to emit an event or call a callback here
    }
    handler.next(err);
  }

  String? _getAuthToken() {
    // This would typically come from secure storage
    // For example: FlutterSecureStorage or SharedPreferences
    return null; // Placeholder
  }

  void _clearAuthToken() {
    // Clear the stored auth token
  }
}

/// Example retry interceptor for handling network failures
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration delay;

  RetryInterceptor({
    this.maxRetries = 3,
    this.delay = const Duration(seconds: 1),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only retry on specific error types
    if (_shouldRetry(err) && err.requestOptions.extra['retryCount'] == null) {
      err.requestOptions.extra['retryCount'] = 0;
    }

    final retryCount = err.requestOptions.extra['retryCount'] ?? 0;

    if (retryCount < maxRetries && _shouldRetry(err)) {
      // Increment retry count
      err.requestOptions.extra['retryCount'] = retryCount + 1;

      // Wait before retrying
      await Future.delayed(delay * (retryCount + 1));

      // Create a new Dio instance to avoid interceptor conflicts
      final dio = Dio();

      try {
        final response = await dio.request(
          err.requestOptions.path,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
          options: Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
          ),
        );
        handler.resolve(response);
        return;
      } catch (e) {
        // If retry fails, continue with the original error
      }
    }

    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    // Retry on network errors and certain HTTP status codes
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}

/// Example of how to use the API in your app
class ApiService {
  /// Get the API instance using singleton pattern
  static ExampleApi get api => ExampleApi.instance;

  /// Initialize API with auth token
  static void setAuthToken(String token) {
    api.addHeader('Authorization', 'Bearer $token');
  }

  /// Clear auth token
  static void clearAuthToken() {
    api.removeHeader('Authorization');
  }

  /// Example of error handling
  static Future<T?> safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } on JetApiError catch (e) {
      // Handle JetApi specific errors
      if (e.isNetworkError) {
        // Handle network errors
        print('Network error: ${e.message}');
      } else if (e.isClientError) {
        // Handle client errors (4xx)
        print('Client error: ${e.message}');
      } else if (e.isServerError) {
        // Handle server errors (5xx)
        print('Server error: ${e.message}');
      }
      return null;
    } catch (e) {
      // Handle unexpected errors
      print('Unexpected error: $e');
      return null;
    }
  }
}
