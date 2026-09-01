class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException([this.message = '', this.statusCode]);

  @override
  String toString() => 'ApiException(statusCode: $statusCode, message: $message)';
}

class NetworkException extends ApiException {
  NetworkException([super.message = 'Network connection failure', super.statusCode]);
}

class AuthException extends ApiException {
  AuthException([super.message = 'Authentication failed', super.statusCode = 401]);
}

class ServerException extends ApiException {
  ServerException([super.message = 'Internal server error', super.statusCode = 500]);
}
