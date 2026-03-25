import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/chat_repository.dart';

class GetRoomByUserIdUseCase {
  final ChatRepository repository;

  GetRoomByUserIdUseCase(this.repository);

  Future<Either<Failure, int?>> call(int userId) {
    return repository.getRoomIdByUserId(userId);
  }
}
