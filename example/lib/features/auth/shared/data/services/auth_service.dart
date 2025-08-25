import 'package:example/core/networking/app_network.dart';
import 'package:example/features/auth/login/data/models/login_request.dart';
import 'package:example/features/auth/login/data/models/login_response.dart';
import 'package:example/features/auth/shared/data/models/register_request.dart';
import 'package:example/features/auth/shared/data/models/register_response.dart';
import 'package:example/features/auth/shared/data/models/verify_register_request.dart';
import 'package:example/shared/constants/api_endpoints.dart';
import 'package:example/shared/models/base_response.dart';
import 'package:jet/jet_framework.dart';

import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST(ApiEndpoints.login)
  Future<LoginResponse> login(@Body() LoginRequest request);

  @POST(ApiEndpoints.register)
  Future<BaseResponse<RegisterResponse>> register(@Body() RegisterRequest request);

  @POST(ApiEndpoints.verifyRegister)
  Future<BaseResponse<LoginResponse>> verifyRegister(@Body() VerifyRegisterRequest request);
}

@riverpod
AuthService authService(Ref ref) {
  return AuthService(ref.read(appNetworkProvider).dio);
}
