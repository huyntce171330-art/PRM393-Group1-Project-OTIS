import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_otis/core/network/socket_service.dart';
import 'package:frontend_otis/presentation/bloc/chat/chat_bloc.dart';
import 'package:frontend_otis/presentation/screens/chat/chat_screen.dart';
import 'package:frontend_otis/core/injections/injection_container.dart';
import 'package:frontend_otis/domain/usecases/chat/mark_room_messages_as_read_usecase.dart';

class AdminChatDetailScreen extends StatefulWidget {
  final int roomId;
  final String peerTitle;
  final String socketUrl;

  const AdminChatDetailScreen({
    super.key,
    required this.roomId,
    required this.peerTitle,
    required this.socketUrl,
  });

  @override
  State<AdminChatDetailScreen> createState() => _AdminChatDetailScreenState();
}

class _AdminChatDetailScreenState extends State<AdminChatDetailScreen> {
  @override
  void initState() {
    super.initState();
    sl<MarkRoomMessagesAsReadUseCase>()(
      roomId: widget.roomId,
      viewerId: 1, // sample admin id
    );
    SocketService.instance.setActiveAdminRoom(widget.roomId);
  }
  @override
  void dispose() {
    if (SocketService.instance.activeAdminRoomId == widget.roomId) {
      SocketService.instance.setActiveAdminRoom(null);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChatBloc>(),
      child: ChatScreen(
        roomId: widget.roomId,
        userId: 1, // admin sample id
        peerTitle: widget.peerTitle,
        socketUrl: widget.socketUrl,
      ),
    );
  }
}