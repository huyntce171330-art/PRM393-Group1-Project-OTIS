import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'otis_database.db');

    return openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        final script = await rootBundle.loadString("assets/database/otis_v1.0.1.sql");
        final statements = script.split(';');
        for (var statement in statements) {
          final trimmed = statement.trim();
          if (trimmed.isNotEmpty) {
            await db.execute(trimmed);
          }
        }
      },
    );
  }

  // ===== USER PROFILE: UPDATE + READ =====

  static Future<int> updateUserProfile({
    required int userId,
    required String fullName,
    required String address,
    required String phone,
  }) async {
    final db = await DatabaseHelper.database;

    return db.update(
      'users',
      {
        'full_name': fullName,
        'address': address,
        'phone': phone,
      },
      where: 'user_id = ?',
      whereArgs: [userId],
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  static Future<Map<String, Object?>?> getUserById(int userId) async {
    final db = await DatabaseHelper.database;

    final rows = await db.query(
      'users',
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return rows.first;
  }

  static Future<int> countCustomers() async {
    final db = await DatabaseHelper.database;

    final rows = await db.rawQuery('''
      SELECT COUNT(*) AS cnt
      FROM users u
      INNER JOIN user_roles r ON r.role_id = u.role_id
      WHERE r.role_name = 'customer'
    ''');

    final v = rows.first['cnt'];
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  // ===== ADMIN USER MANAGEMENT =====

  static Future<int> updateUserStatus({
    required int userId,
    required String status, // active | inactive | banned
  }) async {
    final db = await DatabaseHelper.database;

    return db.update(
      'users',
      {'status': status},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  // ===== CHAT ROOM LIST =====

  static Future<List<Map<String, Object?>>> getChatRoomList() async {
    final db = await DatabaseHelper.database;

    return db.rawQuery('''
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

  // ===== ADMIN CHAT =====

  static Future<int> getAdminUnreadMessageCount({
    int adminId = 1,
  }) async {
    final db = await DatabaseHelper.database;

    final rows = await db.rawQuery('''
      SELECT COUNT(*) AS cnt
      FROM messages
      WHERE sender_id != ?
        AND IFNULL(is_read, 0) = 0
    ''', [adminId]);

    final v = rows.first['cnt'];
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  static Future<List<Map<String, Object?>>> getAdminChatRooms({
    int adminId = 1,
  }) async {
    final db = await DatabaseHelper.database;

    return db.rawQuery('''
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
    ''', [adminId]);
  }

  // ===== CHAT HISTORY =====

  static Future<int> insertMessage({
    required int roomId,
    required int senderId,
    required String content,
    String? createdAt,
    int isRead = 0,
  }) async {
    final db = await DatabaseHelper.database;
    final safeCreatedAt = createdAt ?? DateTime.now().toIso8601String();

    // 1) Chặn trùng tuyệt đối
    final exactExisting = await db.query(
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
    // Nếu cùng room + cùng sender + cùng content và tin gần nhất cách <= 3 giây
    final recentExisting = await db.query(
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
        } catch (_) {
          // bỏ qua parse lỗi, tiếp tục insert bình thường
        }
      }
    }

    return db.insert(
      'messages',
      {
        'room_id': roomId,
        'sender_id': senderId,
        'content': content,
        'is_read': isRead,
        'created_at': safeCreatedAt,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, Object?>>> getMessagesByRoom(int roomId) async {
    final db = await DatabaseHelper.database;

    return db.query(
      'messages',
      where: 'room_id = ?',
      whereArgs: [roomId],
      orderBy: 'created_at ASC, message_id ASC',
    );
  }

  // ===== CHAT UNREAD / READ =====

  static Future<int> getUnreadCountForRoom({
    required int roomId,
    required int viewerId,
  }) async {
    final db = await DatabaseHelper.database;

    final rows = await db.rawQuery('''
      SELECT COUNT(*) AS cnt
      FROM messages
      WHERE room_id = ?
        AND sender_id != ?
        AND IFNULL(is_read, 0) = 0
    ''', [roomId, viewerId]);

    final v = rows.first['cnt'];
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  static Future<int> getTotalUnreadCount({
    required int viewerId,
  }) async {
    final db = await DatabaseHelper.database;

    final rows = await db.rawQuery('''
      SELECT COUNT(*) AS cnt
      FROM messages
      WHERE sender_id != ?
        AND IFNULL(is_read, 0) = 0
    ''', [viewerId]);

    final v = rows.first['cnt'];
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  static Future<int> markRoomMessagesAsRead({
    required int roomId,
    required int viewerId,
  }) async {
    final db = await DatabaseHelper.database;

    return db.update(
      'messages',
      {'is_read': 1},
      where: 'room_id = ? AND sender_id != ? AND IFNULL(is_read, 0) = 0',
      whereArgs: [roomId, viewerId],
    );
  }

  static Future<List<Map<String, Object?>>> getAllChatRoomsForViewer({
    required int viewerId,
  }) async {
    final db = await DatabaseHelper.database;

    return db.rawQuery('''
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
    ''', [viewerId]);
  }

  static Future<int?> getRoomIdByUserId(int userId) async {
    final db = await DatabaseHelper.database;

    final rows = await db.query(
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