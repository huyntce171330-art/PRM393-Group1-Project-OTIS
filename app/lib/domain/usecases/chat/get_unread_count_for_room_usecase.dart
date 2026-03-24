import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/chat_repository.dart';

class GetUnreadCountForRoomUseCase {
  final ChatRepository repository;

  GetUnreadCountForRoomUseCase(this.repository);

  Future<Either<Failure, int>> call({
    required int roomId,
    required int viewerId,
  }) {
    return repository.getUnreadCountForRoom(
      roomId: roomId,
      viewerId: viewerId,
    );
  }
}
