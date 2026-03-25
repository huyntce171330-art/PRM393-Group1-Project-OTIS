import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({String message = 'Server connection error'}) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure({String message = 'Cache memory error'}) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure({String message = 'Network connection error'}) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure({required String message}) : super(message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({required String message}) : super(message);
}

class LocationFailure extends Failure {
  const LocationFailure({String message = 'Location access error'}) : super(message);
}
