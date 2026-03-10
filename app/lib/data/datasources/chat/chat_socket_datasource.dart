import 'package:frontend_otis/core/network/socket_service.dart';

class ChatSocketDatasource {
  final SocketService socket;

  ChatSocketDatasource(this.socket);

  void connect({required String url, required int userId}) {
    socket.connect(url: url, userId: userId);
  }

  void joinRoom({required int roomId, required int userId}) {
    socket.joinRoom(roomId, userId: userId);
  }

  void sendMessage({
    required int roomId,
    required int senderId,
    required String content,
  }) {
    socket.sendMessage(roomId: roomId, senderId: senderId, content: content);
  }

  Stream<Map<String, dynamic>> onMessage() => socket.messageStream;
  Stream<bool> onConnection() => socket.connectionStream;

  bool get isConnected => socket.isConnected;
}