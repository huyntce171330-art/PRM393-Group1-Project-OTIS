import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_otis/core/injections/database_helper.dart';
import 'package:frontend_otis/data/datasources/chat/chat_socket_datasource.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatSocketDatasource datasource;

  StreamSubscription? _msgSub;
  StreamSubscription? _connSub;

  int? _roomId;
  int? _userId;

  // Chống xử lý trùng cùng 1 message
  final Set<String> _seenMessageKeys = {};

  ChatBloc({required this.datasource}) : super(ChatState.initial()) {
    on<ChatStarted>(_onStarted);
    on<ChatTextChanged>(_onTextChanged);
    on<ChatSendPressed>(_onSendPressed);
    on<ChatMessageReceived>(_onMessageReceived);
    on<ChatConnectionChanged>(_onConnectionChanged);
  }

  String _messageKeyFromMap(Map<String, dynamic> msg) {
    final roomId = msg['roomId'] ?? msg['room_id'] ?? '';
    final senderId = msg['senderId'] ?? msg['sender_id'] ?? '';
    final content = (msg['content'] ?? '').toString();
    final createdAt = (msg['createdAt'] ?? msg['created_at'] ?? '').toString();

    return '$roomId|$senderId|$content|$createdAt';
  }

  Future<void> _onStarted(ChatStarted e, Emitter<ChatState> emit) async {
    _roomId = e.roomId;
    _userId = e.userId;
    _seenMessageKeys.clear();

    // 1. Load lịch sử local trước
    final history = await DatabaseHelper.getMessagesByRoom(e.roomId);
    final historyMaps = history.map((m) => Map<String, dynamic>.from(m)).toList();

    for (final m in historyMaps) {
      _seenMessageKeys.add(_messageKeyFromMap(m));
    }

    emit(state.copyWith(messages: historyMaps));

    await DatabaseHelper.markRoomMessagesAsRead(
      roomId: e.roomId,
      viewerId: e.userId,
    );

    // 2. Connect socket
    datasource.connect(url: e.socketUrl, userId: e.userId);

    await _connSub?.cancel();
    _connSub = datasource.onConnection().listen((connected) {
      add(ChatConnectionChanged(connected));
    });

    // 3. Join room
    datasource.joinRoom(roomId: e.roomId, userId: e.userId);

    // 4. Listen message realtime
    await _msgSub?.cancel();
    _msgSub = datasource.onMessage().listen((msg) {
      final msgRoom = msg['roomId'] ?? msg['room_id'];
      if (msgRoom == e.roomId) {
        add(ChatMessageReceived(Map<String, dynamic>.from(msg)));
      }
    });
  }

  void _onTextChanged(ChatTextChanged e, Emitter<ChatState> emit) {
    emit(state.copyWith(input: e.text));
  }

  Future<void> _onSendPressed(
      ChatSendPressed e,
      Emitter<ChatState> emit,
      ) async {
    final text = state.input.trim();
    if (text.isEmpty) return;

    final roomId = _roomId;
    final userId = _userId;
    if (roomId == null || userId == null) return;

    emit(state.copyWith(input: ''));

    datasource.sendMessage(
      roomId: roomId,
      senderId: userId,
      content: text,
    );
  }

  Future<void> _onMessageReceived(
      ChatMessageReceived e,
      Emitter<ChatState> emit,
      ) async {
    final roomId = (e.message['roomId'] ?? e.message['room_id']) as int?;
    final senderId = (e.message['senderId'] ?? e.message['sender_id']) as int?;
    final content = (e.message['content'] ?? '').toString();
    final createdAt =
    (e.message['createdAt'] ?? e.message['created_at'])?.toString();

    if (roomId == null || senderId == null || content.isEmpty) return;

    final key = '$roomId|$senderId|$content|${createdAt ?? ''}';
    if (_seenMessageKeys.contains(key)) {
      return;
    }
    _seenMessageKeys.add(key);

    // Lưu local để có history
    await DatabaseHelper.insertMessage(
      roomId: roomId,
      senderId: senderId,
      content: content,
      createdAt: createdAt,
      isRead: 1,
    );

    final history = await DatabaseHelper.getMessagesByRoom(roomId);

    emit(state.copyWith(
      messages: history.map((m) => Map<String, dynamic>.from(m)).toList(),
    ));
  }

  void _onConnectionChanged(
      ChatConnectionChanged e,
      Emitter<ChatState> emit,
      ) {
    emit(state.copyWith(connected: e.connected));
  }

  @override
  Future<void> close() async {
    await _msgSub?.cancel();
    await _connSub?.cancel();
    return super.close();
  }
}