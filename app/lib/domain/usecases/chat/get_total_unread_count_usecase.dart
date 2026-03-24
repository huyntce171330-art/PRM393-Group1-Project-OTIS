import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/chat_repository.dart';

class GetTotalUnreadCountUseCase {
  final ChatRepository repository;

  GetTotalUnreadCountUseCase(this.repository);

  Future<Either<Failure, int>> call(int viewerId) {
    return repository.getTotalUnreadCount(viewerId: viewerId);
  }
}
