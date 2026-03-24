import 'package:frontend_otis/core/injections/database_helper.dart';
import 'package:frontend_otis/data/datasources/notification/notification_remote_datasource.dart';
import 'package:frontend_otis/data/models/notification_model.dart';
import 'package:frontend_otis/domain/entities/notification_filter.dart';

class NotificationRemoteDatasourceImpl implements NotificationRemoteDatasource {
  @override
  Future<List<NotificationModel>> fetchNotifications({Map<String, dynamic>? filterParams}) async {
    final db = await DatabaseHelper.database;
    final page = filterParams?['page'] ?? 1;
    final limit = filterParams?['limit'] ?? 20;
    final offset = (page - 1) * limit;

    final whereClauses = <String>['IFNULL(is_deleted, 0) = 0'];
    final whereArgs = <dynamic>[];

    if (filterParams != null) {
      final type = filterParams['type'];
      if (type != null && type.toString().isNotEmpty) {
        whereClauses.add('type = ?');
        whereArgs.add(type);
      }

      final isRead = filterParams['isRead'];
      if (isRead != null) {
        whereClauses.add('is_read = ?');
        whereArgs.add(isRead == true ? 1 : 0);
      }

      final searchQuery = filterParams['searchQuery'];
      if (searchQuery != null && searchQuery.isNotEmpty) {
        whereClauses.add('(title LIKE ? OR body LIKE ?)');
        whereArgs.add('%$searchQuery%');
        whereArgs.add('%$searchQuery%');
      }
    }

    final whereString = whereClauses.join(' AND ');

    final result = await db.rawQuery(
      '''
      SELECT notification_id, title, body, is_read, user_id, created_at, type, payload
      FROM notifications
      WHERE $whereString
      ORDER BY created_at DESC
      LIMIT ? OFFSET ?
      ''',
      [...whereArgs, limit, offset],
    );

    return result.map((row) => NotificationModel.fromJson({
      'notification_id': row['notification_id'],
      'title': row['title'],
      'body': row['body'],
      'is_read': row['is_read'],
      'user_id': row['user_id'],
      'created_at': row['created_at'],
      'type': row['type'],
      'payload': row['payload'],
    })).toList();
  }

  @override
  Future<NotificationModel> fetchNotificationDetail(String id) async {
    final db = await DatabaseHelper.database;
    final result = await db.rawQuery(
      '''
      SELECT notification_id, title, body, is_read, user_id, created_at, type, payload
      FROM notifications
      WHERE notification_id = ? AND IFNULL(is_deleted, 0) = 0
      LIMIT 1
      ''',
      [id],
    );

    if (result.isEmpty) {
      throw Exception('Notification not found');
    }

    return NotificationModel.fromJson({
      'notification_id': result.first['notification_id'],
      'title': result.first['title'],
      'body': result.first['body'],
      'is_read': result.first['is_read'],
      'user_id': result.first['user_id'],
      'created_at': result.first['created_at'],
      'type': result.first['type'],
      'payload': result.first['payload'],
    });
  }

  @override
  Future<NotificationModel> createNotification(NotificationModel notification) async {
    final db = await DatabaseHelper.database;

    final createdAt = DateTime.now().toIso8601String();
    final id = await db.insert(
      'notifications',
      {
        'title': notification.title,
        'body': notification.body,
        'is_read': notification.isRead ? 1 : 0,
        'user_id': notification.userId,
        'created_at': createdAt,
        'type': notification.type?.toString().split('.').last ?? 'general',
        'payload': notification.payload,
      },
    );

    // Verify insert was successful (id > 0 means success in SQLite)
    if (id <= 0) {
      throw Exception('Failed to create notification: Insert returned $id');
    }

    // Fetch the created notification to ensure all data matches
    final result = await db.query(
      'notifications',
      where: 'notification_id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      throw Exception('Failed to create notification: Could not fetch created notification');
    }

    final row = result.first;
    return NotificationModel(
      id: row['notification_id'].toString(),
      title: row['title'] as String,
      body: row['body'] as String,
      isRead: (row['is_read'] as int) == 1,
      userId: row['user_id'] as String,
      createdAt: DateTime.parse(row['created_at'] as String),
      type: _parseType(row['type'] as String?),
      payload: row['payload'] as String?,
    );
  }

  NotificationType? _parseType(String? value) {
    if (value == null) return NotificationType.general;
    final str = value.toLowerCase().trim();
    for (final type in NotificationType.values) {
      if (type.toString().split('.').last == str) return type;
    }
    return NotificationType.general;
  }

  @override
  Future<void> updateNotificationStatus(String id, bool isRead) async {
    final db = await DatabaseHelper.database;
    await db.rawUpdate(
      'UPDATE notifications SET is_read = ? WHERE notification_id = ?',
      [isRead ? 1 : 0, id],
    );
  }

  @override
  Future<void> deleteNotification(String id) async {
    final db = await DatabaseHelper.database;
    await db.rawUpdate(
      'UPDATE notifications SET is_deleted = 1 WHERE notification_id = ?',
      [id],
    );
  }

  @override
  Future<void> markAllAsRead() async {
    final db = await DatabaseHelper.database;
    await db.rawUpdate(
      'UPDATE notifications SET is_read = 1 WHERE is_read = 0',
    );
  }
}
