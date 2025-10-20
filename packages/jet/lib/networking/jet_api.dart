import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/bootstrap/boot.dart';
import 'package:jet/networking/errors/jet_error.dart';
import 'package:jet/networking/errors/jet_error_handler.dart';
import 'package:jet/networking/interceptors/jet_dio_logger_interceptor.dart';

/// Abstract base class for HTTP API interactions
/// Provides a comprehensive networking solution with:
/// - All HTTP methods (GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS)
/// - Custom interceptors support
/// - Default headers management
/// - Generic JSON response decoding with type T
/// - Enhanced error handling and caching support
abstract class JetApiService {
  late final Dio _dio;
  late final CancelToken _sharedCancelToken;

  Ref ref;

  /// Base URL for all API requests
  String get baseUrl;

  /// Default headers that will be added to all requests
  Map<String, dynamic> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Timeout configuration
  Duration get connectTimeout => const Duration(seconds: 30);
  Duration get receiveTimeout => const Duration(seconds: 30);
  Duration get sendTimeout => const Duration(seconds: 30);

  /// Custom interceptors to be added to the Dio instance
  List<Interceptor> get interceptors => [];

  /// Cache options configuration (can be overridden)
  Options? get globalCacheOptions => null;

  /// HTTP client adapter (can be overridden for HTTP/2, etc.)
  HttpClientAdapter? get httpClientAdapter => null;

  JetApiService(this.ref) {
    _sharedCancelToken = CancelToken();
    _initializeDio();
  }

  /// Initialize Dio with configuration - enhanced with additional options
  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: defaultHeaders,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        sendTimeout: sendTimeout,
        responseType: ResponseType.json,
      ),
    );

    // Set custom HTTP client adapter if provided
    if (httpClientAdapter != null) {
      _dio.httpClientAdapter = httpClientAdapter!;
    }

    // Add default error interceptor
    _dio.interceptors.add(_createErrorInterceptor());

    // Add logging interceptor in debug mode
    _dio.interceptors.add(
      JetDioLoggerInterceptor(ref.read(jetProvider).config.dioLoggerConfig),
    );

    // Add custom interceptors
    _dio.interceptors.addAll(interceptors);
  }

  /// GET request with generic type decoding
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
    T Function(dynamic)? decoder,
  }) async {
    try {
      final response = await _dio.get(
        '$baseUrl$path',
        queryParameters: queryParameters,
        options: _mergeOptions(options),
        cancelToken: cancelToken ?? CancelToken(),
        onReceiveProgress: onReceiveProgress,
      );

      return decoder != null ? decoder(response.data) : response.data as T;
    } catch (e, stackTrace) {
      throw _handleError(e, stackTrace);
    }
  }

  /// POST request with generic type decoding
  Future<T> post<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    T Function(dynamic)? decoder,
  }) async {
    try {
      final response = await _dio.post(
        '$baseUrl$path',
        data: body,
        queryParameters: queryParameters,
        options: _mergeOptions(options),
        cancelToken: cancelToken ?? CancelToken(),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return decoder != null ? decoder(response.data) : response.data as T;
    } catch (e, stackTrace) {
      throw _handleError(e, stackTrace);
    }
  }

  /// PUT request with generic type decoding
  Future<T> put<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    T Function(dynamic)? decoder,
  }) async {
    try {
      final response = await _dio.put(
        '$baseUrl$path',
        data: body,
        queryParameters: queryParameters,
        options: _mergeOptions(options),
        cancelToken: cancelToken ?? CancelToken(),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return decoder != null ? decoder(response.data) : response.data as T;
    } catch (e, stackTrace) {
      throw _handleError(e, stackTrace);
    }
  }

  /// DELETE request with generic type decoding
  Future<T> delete<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? decoder,
  }) async {
    try {
      final response = await _dio.delete(
        '$baseUrl$path',
        data: body,
        queryParameters: queryParameters,
        options: _mergeOptions(options),
        cancelToken: cancelToken ?? CancelToken(),
      );

      return decoder != null ? decoder(response.data) : response.data as T;
    } catch (e, stackTrace) {
      throw _handleError(e, stackTrace);
    }
  }

  /// PATCH request with generic type decoding
  Future<T> patch<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    T Function(dynamic)? decoder,
  }) async {
    try {
      final response = await _dio.patch(
        '$baseUrl$path',
        data: body,
        queryParameters: queryParameters,
        options: _mergeOptions(options),
        cancelToken: cancelToken ?? CancelToken(),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return decoder != null ? decoder(response.data) : response.data as T;
    } catch (e, stackTrace) {
      throw _handleError(e, stackTrace);
    }
  }

  /// HEAD request
  Future<Response> head(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.head(
        '$baseUrl$path',
        queryParameters: queryParameters,
        options: _mergeOptions(options),
        cancelToken: cancelToken ?? CancelToken(),
      );
    } catch (e, stackTrace) {
      throw _handleError(e, stackTrace);
    }
  }

  /// OPTIONS request
  Future<Response> optionsRequest(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? requestOptions,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.request(
        '$baseUrl$path',
        data: body,
        queryParameters: queryParameters,
        options: _mergeOptions(
          (requestOptions ?? Options()).copyWith(method: 'OPTIONS'),
        ),
        cancelToken: cancelToken ?? CancelToken(),
      );
    } catch (e, stackTrace) {
      throw _handleError(e, stackTrace);
    }
  }

  /// Download file
  Future<Response> download(
    String urlPath,
    String savePath, {
    void Function(int, int)? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    Options? options,
  }) async {
    try {
      return await _dio.download(
        '$baseUrl$urlPath',
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken ?? CancelToken(),
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        options: _mergeOptions(options),
      );
    } catch (e, stackTrace) {
      throw _handleError(e, stackTrace);
    }
  }

  /// Upload files with multipart/form-data
  Future<T> upload<T>(
    String path,
    FormData formData, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    T Function(dynamic)? decoder,
  }) async {
    try {
      final response = await _dio.post(
        '$baseUrl$path',
        data: formData,
        queryParameters: queryParameters,
        options: _mergeOptions(options),
        cancelToken: cancelToken ?? CancelToken(),
        onSendProgress: onSendProgress,
      );
      return decoder != null ? decoder(response.data) : response.data as T;
    } catch (e, stackTrace) {
      throw _handleError(e, stackTrace);
    }
  }

  /// Cancel all pending requests that use the shared cancel token
  ///
  /// Note: By default, each request creates its own cancel token.
  /// This method is maintained for backward compatibility but won't cancel
  /// individual requests unless they explicitly use the shared token.
  ///
  /// To cancel a specific request, pass a custom CancelToken when making the request
  /// and call cancel() on that token directly.
  ///
  /// Example:
  /// ```dart
  /// final token = CancelToken();
  /// final future = apiService.get('/users', cancelToken: token);
  /// // Later, cancel this specific request:
  /// token.cancel('User cancelled');
  /// ```
  @Deprecated(
    'Use individual cancel tokens for better control. '
    'Each request now creates its own token by default.',
  )
  void cancelRequests([String? reason]) {
    _sharedCancelToken.cancel(reason);
  }

  /// Create a new cancel token
  CancelToken createCancelToken() => CancelToken();

  /// Add a header that will persist for all subsequent requests
  void addHeader(String key, String value) {
    _dio.options.headers[key] = value;
  }

  /// Remove a header
  void removeHeader(String key) {
    _dio.options.headers.remove(key);
  }

  /// Update multiple headers at once
  void updateHeaders(Map<String, String> headers) {
    _dio.options.headers.addAll(headers);
  }

  /// Clear all headers except default ones
  void clearHeaders() {
    _dio.options.headers.clear();
    _dio.options.headers.addAll(defaultHeaders);
  }

  /// Get current headers
  Map<String, dynamic> get currentHeaders => Map.from(_dio.options.headers);

  /// Add an interceptor at runtime
  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  /// Remove an interceptor
  void removeInterceptor(Interceptor interceptor) {
    _dio.interceptors.remove(interceptor);
  }

  /// Access to the underlying Dio instance for advanced usage
  Dio get dio => _dio;

  Options? _mergeOptions(Options? options) {
    if (options == null && globalCacheOptions == null) {
      return null;
    } else if (options == null && globalCacheOptions != null) {
      return globalCacheOptions;
    } else if (options != null && globalCacheOptions == null) {
      return options;
    }

    // Merge cache options with request options
    return options!.copyWith(
      extra: {
        ...globalCacheOptions?.extra ?? {},
        ...options.extra ?? {},
      },
    );
  }

  /// Create error interceptor for consistent error handling
  Interceptor _createErrorInterceptor() {
    return InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) {
        // Just pass through the DioException without modification
        handler.next(error);
      },
    );
  }

  /// Handle and transform errors
  /// Converts any error to JetError for consistent error handling
  JetError _handleError(dynamic error, [StackTrace? stackTrace]) {
    final handler = JetErrorHandler.instance;
    return handler.handle(error, stackTrace: stackTrace);
  }
}
