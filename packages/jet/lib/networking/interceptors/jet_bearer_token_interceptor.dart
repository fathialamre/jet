import 'package:dio/dio.dart';
import 'package:jet/helpers/jet_logger.dart';
import 'package:jet/storage/local_storage.dart';

class JetBearerTokenInterceptor extends Interceptor {
  @override
  Future<dynamic> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    const String localeStorageKey = 'selected_locale';
    String token = JetStorage.getSession()?.token ?? '';
    dump(token, tag: 'token');
    final savedLocaleCode = JetStorage.read<String>(localeStorageKey);
    dump(savedLocaleCode, tag: 'savedLocaleCode');
    options.headers.addAll(
      {
        'Authorization': 'Bearer $token',
        'Accept-Language': savedLocaleCode,
      },
    );
    return handler.next(options);
  }
}
