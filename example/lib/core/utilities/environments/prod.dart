import 'package:envied/envied.dart';

part 'prod.g.dart';

@Envied(path: '.env')
abstract class ProdEnv {
  @EnviedField(varName: 'BASE_URL')
  static const String baseUrl = _ProdEnv.baseUrl;
}
