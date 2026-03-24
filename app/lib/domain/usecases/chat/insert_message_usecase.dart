import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/chat_repository.dart';

class InsertMessageUseCase {
  final ChatRepository repository;

  InsertMessageUseCase(this.repository);

  Future<Either<Failure, int>> call({
    required int roomId,
    required int senderId,
    required String content,
    String? createdAt,
    int isRead = 0,
  }) {
    return repository.insertMessage(
      roomId: roomId,
      senderId: senderId,
      content: content,
      createdAt: createdAt,
      isRead: isRead,
    );
  }
}
