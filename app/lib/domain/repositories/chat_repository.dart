import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<Map<String, dynamic>>>> getChatRoomList();
  
  Future<Either<Failure, int>> getAdminUnreadMessageCount({int adminId = 1});
  
  Future<Either<Failure, List<Map<String, dynamic>>>> getAdminChatRooms({int adminId = 1});
  
  Future<Either<Failure, int>> insertMessage({
    required int roomId,
    required int senderId,
    required String content,
    String? createdAt,
    int isRead = 0,
  });
  
  Future<Either<Failure, List<Map<String, dynamic>>>> getMessagesByRoom(int roomId);
  
  Future<Either<Failure, int>> getUnreadCountForRoom({required int roomId, required int viewerId});
  
  Future<Either<Failure, int>> getTotalUnreadCount({required int viewerId});
  
  Future<Either<Failure, int>> markRoomMessagesAsRead({required int roomId, required int viewerId});
  
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllChatRoomsForViewer({required int viewerId});
  
  Future<Either<Failure, int?>> getRoomIdByUserId(int userId);
}
