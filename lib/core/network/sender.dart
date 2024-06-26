import 'package:app_chat_proxy/core/network/http_api_config.dart';
import 'package:app_chat_proxy/core/network/http_method.dart';
import 'package:app_chat_proxy/dev/logger.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../common/result.dart';
import 'http_error.dart';

typedef Parser<D, J> = D Function(J);

typedef ListParser<D, J> = Iterable<D> Function(
    Iterable<J> items, Parser<D, J> parser);

List<D> commonListParser<D, J>({
  required Iterable<J> items,
  required Parser<D, J> parser,
}) {
  return (items.map((item) => parser(item))).toList();
}

class Sender {
  final HttpApiConfig httpApiConfig;
  final ErrorProcessing errorProcessing;

  Sender({
    required this.httpApiConfig,
    required this.errorProcessing,
  });

  @nonVirtual
  Future<Result<F, S>> sendApiRequest<F extends Object, S extends Object, J>({
    required HttpMethod method,
    required Parser<S, J> dataParser,
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic> queryParameters = const {},
    String pathParameter = "",
    ResponseType responseType = ResponseType.json,
    Options? options,
  }) async {
    final dio = httpApiConfig.createDio();
    options ??= Options(headers: headers, responseType: responseType);
    late Future<Response>? response;
    String path = httpApiConfig.path + pathParameter;
    if (method == HttpMethod.post) {
      logger.w("POST: ${dio.options.baseUrl}$path");
      logger.w("body: $body");
      response = dio.post(path,
          data: body, queryParameters: queryParameters, options: options);
    } else if (method == HttpMethod.get) {
      logger.w(
          "GET: ${dio.options.baseUrl}$path\nHeader: ${options.headers}\nResponseType: ${options.responseType}");
      response =
          dio.get(path, queryParameters: queryParameters, options: options);
    } else if (method == HttpMethod.delete) {
      response =
          dio.delete(path, queryParameters: queryParameters, options: options);
    } else if (method == HttpMethod.put) {
      response = dio.put(path,
          data: body, queryParameters: queryParameters, options: options);
    }
    if (response == null) {
      throw UnsupportedError("$method not supported");
    }
    late Result<F, S> rs;
    await response.then((value) {
      logger.w(
          "$method: ${dio.options.baseUrl}$path \n$value\n${dataParser.runtimeType}");
      try {
        rs = Result.success(dataParser(value.data));
      } catch (e) {
        logger.e(e);
      }
    }, onError: (error) {
      logger.e(error);
      rs = Result.failure(errorProcessing.handlerError(error) as F);
    });
    return rs;
  }
}
