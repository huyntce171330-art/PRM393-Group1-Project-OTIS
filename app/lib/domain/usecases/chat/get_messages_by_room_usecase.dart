import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/chat_repository.dart';

class GetMessagesByRoomUseCase {
  final ChatRepository repository;

  GetMessagesByRoomUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> call(int roomId) {
    return repository.getMessagesByRoom(roomId);
  }
}
