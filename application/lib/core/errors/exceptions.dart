/// Base exception class
class AppException implements Exception {
  final String message;
  final int? code;

  const AppException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Server exception
class ServerException extends AppException {
  const ServerException({
    super.message = 'Server error occurred',
    super.code,
  });
}

/// Cache exception
class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache error occurred',
    super.code,
  });
}

/// Network exception
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection',
    super.code,
  });
}

/// Authentication exception
class AuthException extends AppException {
  const AuthException({
    super.message = 'Authentication failed',
    super.code,
  });
}

/// Validation exception
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
  });
}
