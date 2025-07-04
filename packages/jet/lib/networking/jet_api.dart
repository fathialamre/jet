import 'package:dio/dio.dart';

/// Response wrapper model for standardized API responses
/// Inspired by clean architecture patterns for consistent response handling
class ResponseModel<T> {
  final T? data;
  final String? message;
  final bool success;
  final int? statusCode;
  final Map<String, dynamic>? meta;

  ResponseModel({
    this.data,
    this.message,
    this.success = true,
    this.statusCode,
    this.meta,
  });

  factory ResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? decoder,
  ) {
    return ResponseModel<T>(
      data: decoder != null ? decoder(json['data']) : json['data'] as T?,
      message: json['message']?.toString(),
      success: json['success'] ?? true,
      statusCode: json['status_code'],
      meta: json['meta'],
    );
  }

  factory ResponseModel.fromResponse(
    Response response,
    T Function(dynamic)? decoder,
  ) {
    return ResponseModel<T>(
      data: decoder != null ? decoder(response.data) : response.data as T?,
      message: response.statusMessage,
      success:
          response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300,
      statusCode: response.statusCode,
      meta: {
        'headers': response.headers.map,
        'requestPath': response.requestOptions.path,
      },
    );
  }
}

/// Abstract base class for HTTP API interactions
/// Enhanced with singleton pattern and response model wrapper
/// Provides a comprehensive networking solution with:
/// - All HTTP methods (GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS)
/// - Custom interceptors support
/// - Default headers management
/// - Generic JSON response decoding with ResponseModel wrapper
/// - Singleton pattern for efficient resource management
/// - Enhanced error handling and caching support
abstract class JetApiService {
  static final Map<String, JetApiService> _instances = {};
  late final Dio _dio;
  late final CancelToken _cancelToken;

  /// Base URL for all API requests
  String get baseUrl;

  /// API service identifier for singleton management
  String get serviceId => runtimeType.toString();

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

  /// Get singleton instance of an API service
  static T getInstance<T extends JetApiService>(
    String serviceId,
    T Function() creator,
  ) {
    if (!_instances.containsKey(serviceId)) {
      _instances[serviceId] = creator();
    }
    return _instances[serviceId] as T;
  }

  JetApiService() {
    _cancelToken = CancelToken();
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
    _dio.interceptors.add(_createLoggingInterceptor());

    // Add custom interceptors
    _dio.interceptors.addAll(interceptors);
  }

  /// Enhanced GET request with ResponseModel wrapper
  Future<ResponseModel<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
    T Function(dynamic)? decoder,
    bool useResponseModel = true,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: _mergeOptions(options),
        cancelToken: cancelToken ?? _cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      if (useResponseModel) {
        return ResponseModel.fromResponse(response, decoder);
      } else {
        return ResponseModel<T>(
          data: _decodeResponse<T>(response, decoder),
          success: true,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Enhanced POST request with ResponseModel wrapper
  Future<ResponseModel<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    T Function(dynamic)? decoder,
    bool useResponseModel = true,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options),
        cancelToken: cancelToken ?? _cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if (useResponseModel) {
        return ResponseModel.fromResponse(response, decoder);
      } else {
        return ResponseModel<T>(
          data: _decodeResponse<T>(response, decoder),
          success: true,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Enhanced PUT request with ResponseModel wrapper
  Future<ResponseModel<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    T Function(dynamic)? decoder,
    bool useResponseModel = true,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options),
        cancelToken: cancelToken ?? _cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if (useResponseModel) {
        return ResponseModel.fromResponse(response, decoder);
      } else {
        return ResponseModel<T>(
          data: _decodeResponse<T>(response, decoder),
          success: true,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Enhanced DELETE request with ResponseModel wrapper
  Future<ResponseModel<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? decoder,
    bool useResponseModel = true,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options),
        cancelToken: cancelToken ?? _cancelToken,
      );

      if (useResponseModel) {
        return ResponseModel.fromResponse(response, decoder);
      } else {
        return ResponseModel<T>(
          data: _decodeResponse<T>(response, decoder),
          success: true,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Enhanced PATCH request with ResponseModel wrapper
  Future<ResponseModel<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    T Function(dynamic)? decoder,
    bool useResponseModel = true,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options),
        cancelToken: cancelToken ?? _cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if (useResponseModel) {
        return ResponseModel.fromResponse(response, decoder);
      } else {
        return ResponseModel<T>(
          data: _decodeResponse<T>(response, decoder),
          success: true,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw _handleError(e);
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
        path,
        queryParameters: queryParameters,
        options: _mergeOptions(options),
        cancelToken: cancelToken ?? _cancelToken,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// OPTIONS request
  Future<Response> optionsRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? requestOptions,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(
          (requestOptions ?? Options()).copyWith(method: 'OPTIONS'),
        ),
        cancelToken: cancelToken ?? _cancelToken,
      );
    } catch (e) {
      throw _handleError(e);
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
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken ?? _cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        options: _mergeOptions(options),
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Upload files with multipart/form-data
  Future<ResponseModel<T>> upload<T>(
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
        path,
        data: formData,
        queryParameters: queryParameters,
        options: _mergeOptions(options),
        cancelToken: cancelToken ?? _cancelToken,
        onSendProgress: onSendProgress,
      );
      return ResponseModel.fromResponse(response, decoder);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Network utility method inspired by Nylo framework
  /// Provides a clean interface for making requests with automatic response handling
  Future<T> network<T>({
    required Future<ResponseModel<T>> Function() request,
    T? fallback,
    bool throwOnError = true,
  }) async {
    try {
      final responseModel = await request();
      if (responseModel.success && responseModel.data != null) {
        return responseModel.data!;
      } else if (fallback != null) {
        return fallback;
      } else if (throwOnError) {
        throw JetApiError(
          type: JetErrorType.serverError,
          message: responseModel.message ?? 'Request failed',
          statusCode: responseModel.statusCode,
          data: responseModel.data,
        );
      } else {
        return responseModel.data!;
      }
    } catch (e) {
      if (fallback != null && !throwOnError) {
        return fallback;
      }
      rethrow;
    }
  }

  /// Cancel all pending requests
  void cancelRequests([String? reason]) {
    _cancelToken.cancel(reason);
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

  /// Merge cache options with request options - inspired by Nylo caching patterns
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

  /// Decode response data to specified type
  T _decodeResponse<T>(Response response, T Function(dynamic)? decoder) {
    if (decoder != null) {
      return decoder(response.data);
    }

    // Default decoding for common types
    if (T == String) {
      return response.data.toString() as T;
    } else if (T == Map<String, dynamic>) {
      return response.data as T;
    } else if (T == List) {
      return response.data as T;
    } else if (T == int) {
      return (response.data as num).toInt() as T;
    } else if (T == double) {
      return (response.data as num).toDouble() as T;
    } else if (T == bool) {
      return response.data as T;
    }

    // For custom types, return the raw data and let the caller handle it
    return response.data as T;
  }

  /// Create error interceptor for consistent error handling
  Interceptor _createErrorInterceptor() {
    return InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) {
        final jetError = _createJetError(error);
        handler.next(
          DioException(
            requestOptions: error.requestOptions,
            error: jetError,
            type: error.type,
            response: error.response,
          ),
        );
      },
    );
  }

  /// Create logging interceptor for debugging
  Interceptor _createLoggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        _log('🚀 ${options.method} ${options.path}');
        _log('Headers: ${options.headers}');
        if (options.data != null) {
          _log('Data: ${options.data}');
        }
        handler.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        _log('✅ ${response.statusCode} ${response.requestOptions.path}');
        _log('Response: ${response.data}');
        handler.next(response);
      },
      onError: (DioException error, ErrorInterceptorHandler handler) {
        _log('❌ ${error.requestOptions.method} ${error.requestOptions.path}');
        _log('Error: ${error.message}');
        handler.next(error);
      },
    );
  }

  /// Create standardized error from DioException
  JetApiError _createJetError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return JetApiError(
          type: JetErrorType.connectionTimeout,
          message: 'Connection timeout',
          statusCode: null,
          data: dioError.response?.data,
        );
      case DioExceptionType.sendTimeout:
        return JetApiError(
          type: JetErrorType.sendTimeout,
          message: 'Send timeout',
          statusCode: null,
          data: dioError.response?.data,
        );
      case DioExceptionType.receiveTimeout:
        return JetApiError(
          type: JetErrorType.receiveTimeout,
          message: 'Receive timeout',
          statusCode: null,
          data: dioError.response?.data,
        );
      case DioExceptionType.badResponse:
        return JetApiError(
          type: JetErrorType.serverError,
          message: dioError.response?.statusMessage ?? 'Server error',
          statusCode: dioError.response?.statusCode,
          data: dioError.response?.data,
        );
      case DioExceptionType.cancel:
        return JetApiError(
          type: JetErrorType.cancelled,
          message: 'Request cancelled',
          statusCode: null,
          data: null,
        );
      case DioExceptionType.connectionError:
        return JetApiError(
          type: JetErrorType.connectionError,
          message: 'Connection error',
          statusCode: null,
          data: null,
        );
      case DioExceptionType.badCertificate:
        return JetApiError(
          type: JetErrorType.certificateError,
          message: 'Certificate error',
          statusCode: null,
          data: null,
        );
      case DioExceptionType.unknown:
        return JetApiError(
          type: JetErrorType.unknown,
          message: dioError.message ?? 'Unknown error',
          statusCode: null,
          data: dioError.response?.data,
        );
    }
  }

  /// Handle and transform errors
  Exception _handleError(dynamic error) {
    if (error is DioException && error.error is JetApiError) {
      return error.error as JetApiError;
    } else if (error is DioException) {
      return _createJetError(error);
    } else {
      return JetApiError(
        type: JetErrorType.unknown,
        message: error.toString(),
        statusCode: null,
        data: null,
      );
    }
  }

  /// Logging utility
  void _log(String message) {
    // In debug mode, you might want to use a proper logger
    // For now, using print for simplicity
    print('[JetApi] $message');
  }
}

/// Custom error types for better error handling
enum JetErrorType {
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  serverError,
  connectionError,
  certificateError,
  cancelled,
  unknown,
}

/// Custom error class for standardized error handling
class JetApiError implements Exception {
  final JetErrorType type;
  final String message;
  final int? statusCode;
  final dynamic data;

  JetApiError({
    required this.type,
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() {
    return 'JetApiError{type: $type, message: $message, statusCode: $statusCode, data: $data}';
  }

  /// Check if the error is a specific HTTP status code
  bool isStatusCode(int code) => statusCode == code;

  /// Check if the error is a client error (4xx)
  bool get isClientError =>
      statusCode != null && statusCode! >= 400 && statusCode! < 500;

  /// Check if the error is a server error (5xx)
  bool get isServerError => statusCode != null && statusCode! >= 500;

  /// Check if the error is a network-related error
  bool get isNetworkError =>
      type == JetErrorType.connectionError ||
      type == JetErrorType.connectionTimeout ||
      type == JetErrorType.sendTimeout ||
      type == JetErrorType.receiveTimeout;
}
