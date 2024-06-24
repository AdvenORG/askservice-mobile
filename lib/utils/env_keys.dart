import 'package:app_chat_proxy/core/common/environment.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvKeys {
  static String host = "HOST";
  static String scheme = "SCHEME";
}

class EnvironmentLoader {
  static late String host;
  static late String scheme;

  EnvironmentLoader._internal();

  static Future<void> load(DotEnv dotEnv) async {
    host = dotEnv.env[EnvKeys.host]!;
    scheme = dotEnv.env[EnvKeys.scheme]!;
  }
}

final appEnv = AppEnvironmentData();

class AppEnvironmentData extends EnvironmentData<String> {
  @override
  String dev() {
    return "${EnvironmentLoader.scheme}://${EnvironmentLoader.host}";
  }

  @override
  String prod() {
    throw UnimplementedError();
  }

  @override
  String stg() {
    throw UnimplementedError();
  }
}
