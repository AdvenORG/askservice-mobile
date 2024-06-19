import 'dart:io';

abstract class HttpResponse {
  final HttpStatus statusCode;
  final String? message;

  const HttpResponse({required this.statusCode, required this.message});
}

class HttpJsonResponse<T extends Object> extends HttpResponse {
  final int? page;
  final int? offSet;
  final T? data;

  const HttpJsonResponse({
    required super.statusCode,
    super.message,
    this.page,
    this.offSet,
    this.data,
  });
}

class StreamResponse<T extends Object> extends HttpResponse {
  final Stream<T>? streamData;
  const StreamResponse({
    required super.statusCode,
    super.message,
    this.streamData,
  });
}
