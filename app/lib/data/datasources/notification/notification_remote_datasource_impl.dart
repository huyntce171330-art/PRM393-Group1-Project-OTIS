import 'package:sqflite/sqflite.dart';
import 'package:frontend_otis/data/datasources/notification/notification_remote_datasource.dart';
import 'package:frontend_otis/data/models/notification_model.dart';
import 'package:frontend_otis/domain/entities/notification_filter.dart';
import 'package:frontend_otis/domain/entities/notification_filter.dart';

class NotificationRemoteDatasourceImpl implements NotificationRemoteDatasource {
  final Database database;
  bool _migrationChecked = false;

  NotificationRemoteDatasourceImpl(this.database);

  Future<void> _ensureMigrated() async {
    if (_migrationChecked) return;
    _migrationChecked = true;
    await _ensureNotificationColumns(database);
  }

  static Future<void> _ensureNotificationColumns(Database db) async {
    try {
      final result = await db.rawQuery("PRAGMA table_info(notifications)");
      final columns = result.map((col) => col['name'] as String).toSet();

      if (!columns.contains('type')) {
        print("Adding 'type' column to notifications table...");
        await db.execute(
          "ALTER TABLE notifications ADD COLUMN type TEXT DEFAULT 'general'",
        );
      }

      if (!columns.contains('payload')) {
        print("Adding 'payload' column to notifications table...");
        await db.execute("ALTER TABLE notifications ADD COLUMN payload TEXT");
      }

      if (!columns.contains('is_deleted')) {
        print("Adding 'is_deleted' column to notifications table...");
        await db.execute(
          "ALTER TABLE notifications ADD COLUMN is_deleted INTEGER DEFAULT 0",
        );
      }

      // Speed up ORDER BY created_at queries
      final indexes = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='index' AND tbl_name='notifications'",
      );
      final indexNames = indexes.map((r) => r['name'] as String).toSet();
      if (!indexNames.contains('idx_notifications_created_at')) {
        print("Creating index on notifications.created_at...");
        await db.execute(
          "CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at DESC)",
        );
      }
    } catch (e) {
      print("Migration check failed: $e");
    }
  }

  @override
  Future<List<NotificationModel>> fetchNotifications({
    Map<String, dynamic>? filterParams,
  }) async {
    await _ensureMigrated();
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

      final userId = filterParams['userId'];
      if (userId != null) {
        // Only show notifications for this user OR system-wide ones (NULL)
        whereClauses.add('(user_id = ? OR user_id IS NULL)');
        whereArgs.add(userId);
      }
    }

    final whereString = whereClauses.join(' AND ');

    final result = await database.rawQuery(
      '''
      SELECT notification_id, title, body, is_read, user_id, created_at, type, payload
      FROM notifications
      WHERE $whereString
      ORDER BY created_at DESC
      LIMIT ? OFFSET ?
      ''',
      [...whereArgs, limit, offset],
    );

    return result
        .map(
          (row) => NotificationModel.fromJson({
            'notification_id': row['notification_id'],
            'title': row['title'],
            'body': row['body'],
            'is_read': row['is_read'],
            'user_id': row['user_id'],
            'created_at': row['created_at'],
            'type': row['type'],
            'payload': row['payload'],
          }),
        )
        .toList();
  }

  @override
  Future<NotificationModel> fetchNotificationDetail(String id) async {
    await _ensureMigrated();
    final result = await database.rawQuery(
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
  Future<NotificationModel> createNotification(
    NotificationModel notification,
  ) async {
    await _ensureMigrated();
    final createdAt = DateTime.now().toIso8601String();
    final id = await database.insert('notifications', {
      'title': notification.title,
      'body': notification.body,
      'is_read': notification.isRead ? 1 : 0,
      'user_id':
          (notification.userId == 'system' || notification.userId.isEmpty)
          ? null
          : int.tryParse(notification.userId),
      'created_at': createdAt,
      'type': notification.type?.toString().split('.').last ?? 'general',
      'payload': notification.payload,
    });

    // Verify insert was successful (id > 0 means success in SQLite)
    if (id <= 0) {
      throw Exception('Failed to create notification: Insert returned $id');
    }

    // Fetch the created notification to ensure all data matches
    final result = await database.query(
      'notifications',
      where: 'notification_id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      throw Exception(
        'Failed to create notification: Could not fetch created notification',
      );
    }

    final row = result.first;
    return NotificationModel(
      id: row['notification_id'].toString(),
      title: row['title']?.toString() ?? '',
      body: row['body']?.toString() ?? '',
      isRead: (row['is_read'] as int? ?? 0) == 1,
      userId: row['user_id']?.toString() ?? '',
      createdAt: DateTime.parse(
        row['created_at']?.toString() ?? DateTime.now().toIso8601String(),
      ),
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
    await database.rawUpdate(
      'UPDATE notifications SET is_read = ? WHERE notification_id = ?',
      [isRead ? 1 : 0, id],
    );
  }

  @override
  Future<void> deleteNotification(String id) async {
    await database.rawUpdate(
      'UPDATE notifications SET is_deleted = 1 WHERE notification_id = ?',
      [id],
    );
  }

  @override
  Future<void> markAllAsRead() async {
    await database.rawUpdate(
      'UPDATE notifications SET is_read = 1 WHERE is_read = 0',
    );
  }
}
