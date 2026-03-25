// Interface for Chat Remote Data Source.
//
// Steps:
// 1. Define `ChatRemoteDatasource`.
abstract class ChatRemoteDatasource {
  Future<List<Map<String, dynamic>>> getChatRoomList();
  
  Future<int> getAdminUnreadMessageCount({int adminId = 1});
  
  Future<List<Map<String, dynamic>>> getAdminChatRooms({int adminId = 1});
  
  Future<int> insertMessage({
    required int roomId,
    required int senderId,
    required String content,
    String? createdAt,
    int isRead = 0,
  });
  
  Future<List<Map<String, dynamic>>> getMessagesByRoom(int roomId);
  
  Future<int> getUnreadCountForRoom({required int roomId, required int viewerId});
  
  Future<int> getTotalUnreadCount({required int viewerId});
  
  Future<int> markRoomMessagesAsRead({required int roomId, required int viewerId});
  
  Future<List<Map<String, dynamic>>> getAllChatRoomsForViewer({required int viewerId});
  
  Future<int?> getRoomIdByUserId(int userId);
}
//    - `Stream<MessageModel> get onMessageReceived;`
