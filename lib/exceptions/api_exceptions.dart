// lib/exceptions/api_exceptions.dart

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException(super.message);
}

class ServerException extends ApiException {
  final int? statusCode;
  ServerException(super.message, [this.statusCode]);
  @override
  String toString() => 'Server error: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class DataParseException extends ApiException {
  DataParseException(super.message);
}