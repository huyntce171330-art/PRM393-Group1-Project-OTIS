import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/chat_repository.dart';

class GetAllChatRoomsForViewerUseCase {
  final ChatRepository repository;

  GetAllChatRoomsForViewerUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> call(int viewerId) {
    return repository.getAllChatRoomsForViewer(viewerId: viewerId);
  }
}
