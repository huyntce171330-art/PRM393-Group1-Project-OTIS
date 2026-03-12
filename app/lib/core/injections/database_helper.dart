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

    final db = await openDatabase(
      path,
      version: 2,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          print("Migrating database to version 2...");
          await _createNotificationsTable(db);
          print("Migration completed");
        }
      },
    );
    
    // Create shop_locations table if not exists
    await _createShopLocationsTable(db);

    // Create/migrate notifications table
    await _createNotificationsTable(db);
    
    return db;
  }

  static Future<void> _createShopLocationsTable(Database db) async {
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='shop_locations'",
    );
    
    if (result.isEmpty) {
      print("Creating shop_locations table...");
      await db.execute('''
        CREATE TABLE shop_locations (
          shop_id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          phone TEXT NOT NULL,
          address TEXT NOT NULL,
          latitude REAL NOT NULL,
          longitude REAL NOT NULL,
          image_url TEXT,
          is_active INTEGER NOT NULL DEFAULT 1,
          created_at TEXT NOT NULL,
          updated_at TEXT
        )
      ''');
      print("shop_locations table created successfully");
    } else {
      print("shop_locations table already exists");
    }
  }

  static Future<void> _createNotificationsTable(Database db) async {
    // Check if notifications table exists
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='notifications'",
    );

    if (result.isEmpty) {
      print("Creating notifications table...");
      await db.execute('''
        CREATE TABLE notifications (
          notification_id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          body TEXT NOT NULL,
          is_read INTEGER NOT NULL DEFAULT 0,
          user_id TEXT NOT NULL,
          type TEXT DEFAULT 'system',
          created_at TEXT NOT NULL
        )
      ''');
      print("notifications table created successfully");
    } else {
      print("notifications table already exists, checking columns...");

      // Check if type column exists using PRAGMA
      final columns = await db.rawQuery("PRAGMA table_info(notifications)");
      final columnNames = columns.map((c) => c['name'] as String).toList();

      if (!columnNames.contains('type')) {
        print("Adding type column to notifications table...");
        await db.execute("ALTER TABLE notifications ADD COLUMN type TEXT DEFAULT 'system'");
        print("type column added successfully");
      } else {
        print("type column already exists");
      }
    }
  }
}
