// Custom exceptions for error handling.
//
// These exceptions are used to differentiate between different types
// of failures in the data layer.
//
// Steps:
// 1. Define specific exception classes.
// 2. Use them in data sources to throw appropriate errors.
// 3. Catch them in repositories to convert to failures.

/// Exception thrown when server-side errors occur.
/// Examples: 500 errors, API failures, timeouts.
class ServerException implements Exception {
  final String? message;

  const ServerException({this.message});

  @override
  String toString() => 'ServerException: $message';
}

/// Exception thrown when cache-related errors occur.
/// Examples: SQLite errors, local storage failures.
class CacheException implements Exception {
  final String? message;

  const CacheException({this.message});

  @override
  String toString() => 'CacheException: $message';
}

/// Exception thrown when validation fails.
/// Examples: Invalid input data, missing required fields.
class ValidationException implements Exception {
  final String message;

  const ValidationException(this.message);

  @override
  String toString() => 'ValidationException: $message';
}
