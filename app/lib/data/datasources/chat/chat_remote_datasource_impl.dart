import 'package:sqflite/sqflite.dart';
import 'chat_remote_datasource.dart';

class ChatRemoteDatasourceImpl implements ChatRemoteDatasource {
  final Database database;

  ChatRemoteDatasourceImpl(this.database);

  @override
  Future<List<Map<String, dynamic>>> getChatRoomList() async {
    return database.rawQuery('''
      SELECT 
        r.room_id,
        r.user_id,
        u.full_name,
        u.phone,
        u.avatar_url,
        u.status
      FROM chat_rooms r
      JOIN users u ON u.user_id = r.user_id
      ORDER BY r.updated_at DESC
    ''');
  }

  @override
  Future<int> getAdminUnreadMessageCount({int adminId = 1}) async {
    final rows = await database.rawQuery(
      '''
      SELECT COUNT(*) AS cnt
      FROM messages
      WHERE sender_id != ?
        AND IFNULL(is_read, 0) = 0
    ''',
      [adminId],
    );

    final v = rows.first['cnt'];
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  @override
  Future<List<Map<String, dynamic>>> getAdminChatRooms({
    int adminId = 1,
  }) async {
    return database.rawQuery(
      '''
      SELECT
        r.room_id,
        r.user_id,
        u.full_name,
        u.phone,
        u.avatar_url,
        u.status,
        COALESCE(last_msg.content, '') AS last_message,
        COALESCE(last_msg.created_at, r.updated_at) AS last_time,
        (
          SELECT COUNT(*)
          FROM messages m2
          WHERE m2.room_id = r.room_id
            AND m2.sender_id != ?
            AND IFNULL(m2.is_read, 0) = 0
        ) AS unread_count
      FROM chat_rooms r
      INNER JOIN users u ON u.user_id = r.user_id
      LEFT JOIN messages last_msg ON last_msg.message_id = (
        SELECT m1.message_id
        FROM messages m1
        WHERE m1.room_id = r.room_id
        ORDER BY m1.created_at DESC, m1.message_id DESC
        LIMIT 1
      )
      ORDER BY COALESCE(last_msg.created_at, r.updated_at) DESC
    ''',
      [adminId],
    );
  }

  @override
  Future<int> insertMessage({
    required int roomId,
    required int senderId,
    required String content,
    String? createdAt,
    int isRead = 0,
  }) async {
    final safeCreatedAt = createdAt ?? DateTime.now().toIso8601String();

    // 1) Chặn trùng tuyệt đối
    final exactExisting = await database.query(
      'messages',
      columns: ['message_id'],
      where: 'room_id = ? AND sender_id = ? AND content = ? AND created_at = ?',
      whereArgs: [roomId, senderId, content, safeCreatedAt],
      limit: 1,
    );

    if (exactExisting.isNotEmpty) {
      return exactExisting.first['message_id'] as int;
    }

    // 2) Chặn trùng gần nhau theo thời gian
    final recentExisting = await database.query(
      'messages',
      columns: ['message_id', 'created_at'],
      where: 'room_id = ? AND sender_id = ? AND content = ?',
      whereArgs: [roomId, senderId, content],
      orderBy: 'message_id DESC',
      limit: 1,
    );

    if (recentExisting.isNotEmpty) {
      final lastCreatedAtRaw = recentExisting.first['created_at']?.toString();
      if (lastCreatedAtRaw != null && lastCreatedAtRaw.isNotEmpty) {
        try {
          final lastTime = DateTime.parse(lastCreatedAtRaw).toUtc();
          final newTime = DateTime.parse(safeCreatedAt).toUtc();
          final diff = newTime.difference(lastTime).inSeconds.abs();

          if (diff <= 3) {
            return recentExisting.first['message_id'] as int;
          }
        } catch (_) {}
      }
    }

    return database.insert('messages', {
      'room_id': roomId,
      'sender_id': senderId,
      'content': content,
      'is_read': isRead,
      'created_at': safeCreatedAt,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<List<Map<String, dynamic>>> getMessagesByRoom(int roomId) async {
    return database.query(
      'messages',
      where: 'room_id = ?',
      whereArgs: [roomId],
      orderBy: 'created_at ASC, message_id ASC',
    );
  }

  @override
  Future<int> getUnreadCountForRoom({
    required int roomId,
    required int viewerId,
  }) async {
    final rows = await database.rawQuery(
      '''
      SELECT COUNT(*) AS cnt
      FROM messages
      WHERE room_id = ?
        AND sender_id != ?
        AND IFNULL(is_read, 0) = 0
    ''',
      [roomId, viewerId],
    );

    final v = rows.first['cnt'];
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  @override
  Future<int> getTotalUnreadCount({required int viewerId}) async {
    final rows = await database.rawQuery(
      '''
      SELECT COUNT(*) AS cnt
      FROM messages
      WHERE sender_id != ?
        AND IFNULL(is_read, 0) = 0
    ''',
      [viewerId],
    );

    final v = rows.first['cnt'];
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  @override
  Future<int> markRoomMessagesAsRead({
    required int roomId,
    required int viewerId,
  }) async {
    return database.update(
      'messages',
      {'is_read': 1},
      where: 'room_id = ? AND sender_id != ? AND IFNULL(is_read, 0) = 0',
      whereArgs: [roomId, viewerId],
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getAllChatRoomsForViewer({
    required int viewerId,
  }) async {
    return database.rawQuery(
      '''
      SELECT
        r.room_id,
        r.user_id,
        u.full_name,
        u.phone,
        u.avatar_url,
        COALESCE(last_msg.content, '') AS last_message,
        COALESCE(last_msg.created_at, r.updated_at) AS last_time,
        (
          SELECT COUNT(*)
          FROM messages m2
          WHERE m2.room_id = r.room_id
            AND m2.sender_id != ?
            AND IFNULL(m2.is_read, 0) = 0
        ) AS unread_count
      FROM chat_rooms r
      INNER JOIN users u ON u.user_id = r.user_id
      LEFT JOIN messages last_msg ON last_msg.message_id = (
        SELECT m1.message_id
        FROM messages m1
        WHERE m1.room_id = r.room_id
        ORDER BY m1.created_at DESC, m1.message_id DESC
        LIMIT 1
      )
      ORDER BY COALESCE(last_msg.created_at, r.updated_at) DESC
    ''',
      [viewerId],
    );
  }

  @override
  Future<int?> getRoomIdByUserId(int userId) async {
    final rows = await database.query(
      'chat_rooms',
      columns: ['room_id'],
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    final value = rows.first['room_id'];
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
