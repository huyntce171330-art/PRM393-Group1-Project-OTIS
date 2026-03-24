import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/chat_repository.dart';

class GetChatRoomListUseCase {
  final ChatRepository repository;

  GetChatRoomListUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> call() {
    return repository.getChatRoomList();
  }
}
