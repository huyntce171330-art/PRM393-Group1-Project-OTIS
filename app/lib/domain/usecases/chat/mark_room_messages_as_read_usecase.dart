import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/chat_repository.dart';

class MarkRoomMessagesAsReadUseCase {
  final ChatRepository repository;

  MarkRoomMessagesAsReadUseCase(this.repository);

  Future<Either<Failure, int>> call({
    required int roomId,
    required int viewerId,
  }) {
    return repository.markRoomMessagesAsRead(
      roomId: roomId,
      viewerId: viewerId,
    );
  }
}
