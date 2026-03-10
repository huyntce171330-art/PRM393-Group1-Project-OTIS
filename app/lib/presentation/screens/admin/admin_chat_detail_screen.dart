import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_otis/core/network/socket_service.dart';
import 'package:frontend_otis/core/injections/database_helper.dart';
import 'package:frontend_otis/data/datasources/chat/chat_socket_datasource.dart';
import 'package:frontend_otis/presentation/bloc/chat/chat_bloc.dart';
import 'package:frontend_otis/presentation/screens/chat/chat_screen.dart';

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
    DatabaseHelper.markRoomMessagesAsRead(
      roomId: widget.roomId,
      viewerId: 1,
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
      create: (_) => ChatBloc(
        datasource: ChatSocketDatasource(SocketService.instance),
      ),
      child: ChatScreen(
        roomId: widget.roomId,
        userId: 1, // admin sample id
        peerTitle: widget.peerTitle,
        socketUrl: widget.socketUrl,
      ),
    );
  }
}