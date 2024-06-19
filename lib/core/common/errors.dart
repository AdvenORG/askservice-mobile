class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

class ServerException implements Exception {
  final String message;

  ServerException(this.message);

  @override
  String toString() => 'ServerException: $message';
}

class ValidationException implements Exception {
  final String message;

  ValidationException(this.message);

  @override
  String toString() => 'ValidationException: $message';
}

class PermissionDeniedException implements Exception {
  final String message;

  PermissionDeniedException(this.message);

  @override
  String toString() => 'PermissionDeniedException: $message';
}

class UnknownException implements Exception {
  final String message;

  UnknownException(this.message);

  @override
  String toString() => 'UnknownException: $message';
}

class IllegalOperationException implements Exception {
  final String message;
  IllegalOperationException({this.message = 'Illegal operation detected.'});
  @override
  String toString() => 'IllegalOperationException: $message';
}
