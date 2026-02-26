import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'otis_v1.0.1.db');

    final exists = await databaseExists(path);

    if (!exists) {
      print("Creating new copy from asset ${path}");

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(
        join("assets", "database", "otis_v1.0.1.db"),
      );
      List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      await File(path).writeAsBytes(bytes, flush: true);
      print("Database copied successfully ${path}");
    } else {
      print("Opening existing database ${path}");
    }

    return await openDatabase(path, version: 1);
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
    required String status, // 'active' | 'inactive' | 'banned'
  }) async {
    final db = await DatabaseHelper.database;

    return db.update(
      'users',
      {'status': status},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
}
