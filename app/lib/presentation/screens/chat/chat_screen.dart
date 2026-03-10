// Chat Screen UI.
//
// Steps:
// 1. `BlocBuilder<ChatBloc, ChatState>` (builds message list).
// 2. `ListView.builder` (reverse: true) to show messages from bottom.
// 3. `TextField` + Send Button at bottom.
//    - On Send: Dispatch `SendMessageEvent`.
//    - Clear text field.
// 4. `AppBar` with Receiver Name/Avatar.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/presentation/bloc/chat/chat_bloc.dart';
import 'package:frontend_otis/presentation/bloc/chat/chat_event.dart';
import 'package:frontend_otis/presentation/bloc/chat/chat_state.dart';
import 'package:frontend_otis/presentation/widgets/chat/messenger_bubble.dart';

class ChatScreen extends StatefulWidget {
  final int roomId;
  final int userId;
  final String peerTitle; // "Admin" hoặc "Nguyen Van A"
  final String socketUrl;

  const ChatScreen({
    super.key,
    required this.roomId,
    required this.userId,
    required this.peerTitle,
    required this.socketUrl,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    context.read<ChatBloc>().add(
      ChatStarted(
        roomId: widget.roomId,
        userId: widget.userId,
        socketUrl: widget.socketUrl,
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bg = isDarkMode ? const Color(0xFF0B1220) : const Color(0xFFF5F7FB);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode ? const Color(0xFF111A2B) : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : const Color(0xFF111111),
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary.withOpacity(0.12),
              child: const Icon(Icons.support_agent, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.peerTitle,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                  BlocBuilder<ChatBloc, ChatState>(
                    builder: (_, s) => Text(
                      s.connected ? 'Online' : 'Connecting...',
                      style: TextStyle(
                        fontSize: 11,
                        color: s.connected ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatBloc, ChatState>(
                listenWhen: (p, n) => p.messages.length != n.messages.length,
                listener: (_, __) => _scrollToBottom(),
                builder: (context, state) {
                  final items = state.messages;

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(14, 16, 14, 12),
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final m = items[i];
                      final senderId = (m['senderId'] ?? m['sender_id']) as int?;
                      final isMe = senderId == widget.userId;
                      final text = (m['content'] ?? '').toString();

                      DateTime? time;
                      final createdAt = m['createdAt'] ?? m['created_at'];
                      if (createdAt is String) {
                        time = DateTime.tryParse(createdAt);
                      }

                      final optimistic = m['optimistic'] == true;

                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: MessengerBubble(
                          isMe: isMe,
                          text: text,
                          time: time,
                          optimistic: optimistic,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            _ChatInputBar(
              onSend: (text) {
                context.read<ChatBloc>().add(ChatTextChanged(text));
                context.read<ChatBloc>().add(ChatSendPressed());
              },
              onTyping: (text) => context.read<ChatBloc>().add(ChatTextChanged(text)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatInputBar extends StatefulWidget {
  final void Function(String text) onSend;
  final void Function(String text) onTyping;

  const _ChatInputBar({required this.onSend, required this.onTyping});

  @override
  State<_ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<_ChatInputBar> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final surface = isDarkMode ? const Color(0xFF111A2B) : Colors.white;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF0B1220) : const Color(0xFFF2F4F8),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: TextField(
                  controller: _controller,
                  onChanged: widget.onTyping,
                  onSubmitted: (_) => _send(),
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: _send,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }
}