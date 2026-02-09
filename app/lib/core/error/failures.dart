// This file defines failure handling classes.
//
// Steps to implement:
// 1. Define an abstract class `Failure` with properties like message.
// 2. Extend it for specific failures:
//    - `ServerFailure`
//    - `CacheFailure`
//    - `NetworkFailure`
//    - `ValidationFailure`

/// Abstract base class for all failures/exceptions in the domain layer.
/// Follows the Either pattern for error handling.
abstract class Failure {
  final String message;

  const Failure({required this.message});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is Failure && other.message == message);
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);
}

/// Failure representing server-side errors.
/// Examples: 500 errors, API failures, timeouts.
class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error occurred'});
}

/// Failure representing cache/database errors.
/// Examples: SQLite errors, local storage failures.
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error occurred'});
}

/// Failure representing network connectivity issues.
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection'});
}

/// Failure representing validation errors.
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}
