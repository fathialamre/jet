import 'package:example/core/networking/app_network.dart';
import 'package:example/features/login/models/login_request.dart';
import 'package:example/features/login/models/login_response.dart';
import 'package:jet/jet_framework.dart';

import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_service.g.dart';

@RestApi()
abstract class LoginService {
  factory LoginService(Dio dio, {String baseUrl}) = _LoginService;

  @POST('/login')
  Future<LoginResponse> login(@Body() LoginRequest request);
}

@riverpod
LoginService loginService(Ref ref) {
  return LoginService(ref.read(appNetworkProvider).dio);
}
