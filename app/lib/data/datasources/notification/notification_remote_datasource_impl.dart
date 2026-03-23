import 'package:frontend_otis/core/injections/database_helper.dart';
import 'package:frontend_otis/data/datasources/notification/notification_remote_datasource.dart';
import 'package:frontend_otis/data/models/notification_model.dart';

class NotificationRemoteDatasourceImpl implements NotificationRemoteDatasource {
  @override
  Future<List<NotificationModel>> fetchNotifications({Map<String, dynamic>? filterParams}) async {
    final db = await DatabaseHelper.database;
    final page = filterParams?['page'] ?? 1;
    final limit = filterParams?['limit'] ?? 20;
    final offset = (page - 1) * limit;

    final whereClauses = <String>['1=1'];
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
      WHERE notification_id = ?
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

    return NotificationModel(
      id: id.toString(),
      title: notification.title,
      body: notification.body,
      isRead: notification.isRead,
      userId: notification.userId,
      createdAt: DateTime.parse(createdAt),
      type: notification.type,
      payload: notification.payload,
    );
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
      'DELETE FROM notifications WHERE notification_id = ?',
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
