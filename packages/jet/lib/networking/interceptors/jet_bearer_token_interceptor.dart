import 'package:dio/dio.dart';

/// Bearer token interceptor for adding authentication tokens to requests
///
/// This interceptor is configurable and allows custom token and locale providers.
///
/// Example usage:
/// ```dart
/// JetBearerTokenInterceptor(
///   tokenProvider: () async => await JetStorage.readSecure('auth_token'),
///   localeProvider: () => JetStorage.read<String>('selected_locale'),
/// )
/// ```
class JetBearerTokenInterceptor extends Interceptor {
  /// Function that provides the authentication token
  final Future<String?> Function() tokenProvider;

  /// Function that provides the locale code
  final String? Function()? localeProvider;

  /// Creates a new bearer token interceptor with custom providers
  ///
  /// [tokenProvider] is required and should return the authentication token
  /// [localeProvider] is optional and should return the locale code
  JetBearerTokenInterceptor({
    required this.tokenProvider,
    this.localeProvider,
  });

  @override
  Future<dynamic> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenProvider();
    final locale = localeProvider?.call();

    // Only add headers if values are not null
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    if (locale != null && locale.isNotEmpty) {
      options.headers['Accept-Language'] = locale;
    }

    return handler.next(options);
  }
}
