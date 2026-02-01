// This file defines failure handling classes.
//
// Steps to implement:
// 1. Define an abstract class `Failure` with properties like message.
// 2. Extend it for specific failures:
//    - `ServerFailure`
//    - `CacheFailure`
//    - `NetworkFailure`

abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);
}
