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

  /// Warm up database at app startup — call this in main() before runApp.
  /// Runs the full init flow silently so first real query is instant.
  static Future<void> warmUp() async {
    await database;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'otis.db');
    // REMOVE redundant delete so data persists across restarts
    await deleteDatabase(path);

    return openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        try {
          final script = await rootBundle.loadString(
            "assets/database/otis_v1.0.1.sql",
          );
          final statements = script.split(';');
          for (var statement in statements) {
            final trimmed = statement.trim();
            if (trimmed.isNotEmpty) {
              await db.execute(trimmed);
            }
          }
          print('--- Database Created and Seeded Successfully ---');
        } catch (e) {
          print('--- ERROR during database creation: $e ---');
          rethrow;
        }
      },
    );
  }
}
