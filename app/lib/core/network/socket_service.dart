import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  SocketService._();
  static final SocketService instance = SocketService._();

  IO.Socket? _socket;

  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  final _adminInboxController =
  StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get adminInboxStream =>
      _adminInboxController.stream;

  final _connectedController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _connectedController.stream;

  bool get isConnected => _socket?.connected == true;

  void connect({
    required String url,
    required int userId,
  }) {
    if (_socket != null) return;

    final socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableReconnection()
          .setReconnectionAttempts(999999)
          .setReconnectionDelay(500)
          .disableAutoConnect()
          .setQuery({'userId': userId.toString()})
          .build(),
    );

    _socket = socket;

    socket.onConnect((_) {
      _connectedController.add(true);
      print('[socket] connected: ${socket.id}');
    });

    socket.onDisconnect((_) {
      _connectedController.add(false);
      print('[socket] disconnected');
    });

    socket.on('new_message', (data) {
      if (data is Map && data['message'] is Map) {
        _messageController.add(
          Map<String, dynamic>.from(data['message'] as Map),
        );
      }
    });

    socket.on('admin_inbox_message', (data) {
      if (data is Map && data['message'] is Map) {
        _adminInboxController.add(
          Map<String, dynamic>.from(data['message'] as Map),
        );
      }
    });

    socket.on('error', (e) {
      print('[socket] error: $e');
    });

    socket.connect();
  }

  void joinRoom(int roomId, {required int userId}) {
    _socket?.emit('join_room', {
      'roomId': roomId,
      'userId': userId,
    });
  }

  void sendMessage({
    required int roomId,
    required int senderId,
    required String content,
  }) {
    _socket?.emit('send_message', {
      'roomId': roomId,
      'senderId': senderId,
      'content': content,
      'clientMsgId': DateTime.now().microsecondsSinceEpoch.toString(),
    });
  }

  void reset() {
    _socket?.off('new_message');
    _socket?.off('admin_inbox_message');
    _socket?.off('error');
    _socket?.off('connect');
    _socket?.off('disconnect');
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  void dispose() {
    reset();
    _messageController.close();
    _adminInboxController.close();
    _connectedController.close();
  }

  int? _activeAdminRoomId;
  int? get activeAdminRoomId => _activeAdminRoomId;

  void setActiveAdminRoom(int? roomId) {
    _activeAdminRoomId = roomId;
  }
}