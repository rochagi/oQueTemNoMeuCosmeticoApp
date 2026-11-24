class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class NetworkException extends ApiException {
  NetworkException(String message) : super(message, null);

  @override
  String toString() => 'NetworkException: $message';
}

class ServerException extends ApiException {
  ServerException(super.message, [super.statusCode]);

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}
