import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/core/network/socket_service.dart';
import 'package:frontend_otis/core/injections/injection_container.dart';
import 'package:frontend_otis/domain/usecases/chat/get_all_chat_rooms_for_viewer_usecase.dart';
import 'package:frontend_otis/domain/usecases/chat/insert_message_usecase.dart';
import 'package:frontend_otis/domain/usecases/chat/mark_room_messages_as_read_usecase.dart';

class AdminChatListScreen extends StatefulWidget {
  const AdminChatListScreen({super.key});

  @override
  State<AdminChatListScreen> createState() => _AdminChatListScreenState();
}

class _AdminChatListScreenState extends State<AdminChatListScreen> {
  static const int _adminId = 1;

  Future<List<Map<String, dynamic>>>? _future;
  final TextEditingController _searchController = TextEditingController();
  StreamSubscription? _inboxSub;

  @override
  void initState() {
    super.initState();
    _load();
    _listenRealtimeInbox();
  }

  @override
  void dispose() {
    _inboxSub?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _load() {
    _future = sl<GetAllChatRoomsForViewerUseCase>()(_adminId).then((res) => res.getOrElse(() => []));
    if (mounted) {
      setState(() {});
    }
  }

  void _listenRealtimeInbox() {
    _inboxSub = SocketService.instance.adminInboxStream.listen((msg) async {
      if (!mounted) return;
      if (!(ModalRoute.of(context)?.isCurrent ?? false)) return;

      final roomId = msg['roomId'] ?? msg['room_id'];
      final senderId = msg['senderId'] ?? msg['sender_id'];
      final content = (msg['content'] ?? '').toString();
      final createdAt = (msg['createdAt'] ?? msg['created_at'])?.toString();

      if (SocketService.instance.activeAdminRoomId == roomId) {
        return;
      }

      if (roomId != null &&
          senderId != null &&
          senderId != _adminId &&
          content.isNotEmpty) {
        await sl<InsertMessageUseCase>()(
          roomId: roomId as int,
          senderId: senderId as int,
          content: content,
          createdAt: createdAt,
          isRead: 0,
        );

        _load();
      }
    });
  }

  String _badgeText(int count) {
    if (count > 9) return '9+';
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
    isDarkMode ? const Color(0xFF101622) : const Color(0xFFF8F9FB);
    final surfaceColor = isDarkMode ? const Color(0xFF1A2230) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF333333);
    final textSecondaryColor =
    isDarkMode ? Colors.grey[400] : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          'Chats',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Search user...',
                  hintStyle: TextStyle(color: textSecondaryColor),
                  prefixIcon: Icon(Icons.search, color: textSecondaryColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snap.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snap.error}',
                      style: TextStyle(color: textColor),
                    ),
                  );
                }

                var rows = snap.data ?? [];

                final query = _searchController.text.trim().toLowerCase();
                if (query.isNotEmpty) {
                  rows = rows.where((row) {
                    final name =
                    (row['full_name'] ?? '').toString().toLowerCase();
                    final phone =
                    (row['phone'] ?? '').toString().toLowerCase();
                    return name.contains(query) || phone.contains(query);
                  }).toList();
                }

                if (rows.isEmpty) {
                  return Center(
                    child: Text(
                      'No conversations',
                      style: TextStyle(color: textSecondaryColor),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => _load(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: rows.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final row = rows[index];
                      final roomId = (row['room_id'] as int?) ?? 0;
                      final fullName = (row['full_name'] ?? '').toString();
                      final phone = (row['phone'] ?? '').toString();
                      final avatarUrl = (row['avatar_url'] ?? '').toString();
                      final lastMessage =
                      (row['last_message'] ?? '').toString().trim();
                      final unreadCount =
                          int.tryParse(row['unread_count'].toString()) ?? 0;

                      final displayName =
                      fullName.isNotEmpty ? fullName : phone;

                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          await sl<MarkRoomMessagesAsReadUseCase>()(
                            roomId: roomId,
                            viewerId: _adminId,
                          );

                          if (!mounted) return;

                          await context.push(
                            '/admin/chats/$roomId',
                            extra: {
                              'peerTitle': displayName,
                              'socketUrl': 'http://10.0.2.2:3000',
                            },
                          );

                          _load();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor:
                                AppColors.primary.withValues(alpha: 0.12),
                                backgroundImage: avatarUrl.isNotEmpty
                                    ? NetworkImage(avatarUrl)
                                    : null,
                                child: avatarUrl.isEmpty
                                    ? const Icon(
                                  Icons.person,
                                  color: AppColors.primary,
                                )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      displayName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      lastMessage.isNotEmpty
                                          ? lastMessage
                                          : 'No message yet',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: textSecondaryColor,
                                        fontSize: 12,
                                        fontWeight: unreadCount > 0
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              if (unreadCount > 0)
                                Container(
                                  constraints: const BoxConstraints(
                                    minWidth: 24,
                                    minHeight: 24,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 4,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      _badgeText(unreadCount),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}