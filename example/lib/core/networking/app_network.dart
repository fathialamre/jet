import 'package:jet/jet_framework.dart';

/// Enhanced network service with comprehensive error handling
///
/// This example demonstrates:
/// - Integration with Jet framework
/// - Simple error handling with standard exceptions
/// - Graceful error recovery
class AppNetwork extends JetApiService {
  AppNetwork(super.ref);

  @override
  String get baseUrl => JetEnv.getString('BASE_URL');

  @override
  Duration get sendTimeout => Duration(seconds: 2);

  @override
  Duration get connectTimeout => Duration(seconds: 2);

  @override
  Duration get receiveTimeout => Duration(seconds: 2);

  @override
  List<Interceptor> get interceptors => [];
}

final appNetworkProvider = Provider<AppNetwork>(
  (ref) => AppNetwork(ref),
);
