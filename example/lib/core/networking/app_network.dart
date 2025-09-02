import 'dart:io';

import 'package:example/core/utilities/environments/prod.dart';
import 'package:example/features/posts/data/models/post_response.dart';
import 'package:jet/helpers/jet_logger.dart';
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


  @override
  List<Interceptor> get interceptors => [TestInterceptor()];
}

final appNetworkProvider = AutoDisposeProvider<AppNetwork>(
  (ref) => AppNetwork(),
);

class TestInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    dump('TestInterceptor');
    super.onRequest(options, handler);
  }
}
