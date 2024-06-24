import 'package:app_chat_proxy/utils/env_keys.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/http_api_config.dart';

class AuthHttpApiConfig implements HttpApiConfig {
  @override
  Dio createDio() {
    final options = BaseOptions(
        connectTimeout: const Duration(seconds: 10000),
        receiveTimeout: const Duration(seconds: 10000),
        baseUrl: appEnv.getData());
    return Dio(options);
  }

  @override
  String get path => "/accounts/login";
}
