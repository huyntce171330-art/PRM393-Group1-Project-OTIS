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
    final path = join(dbPath, 'otis_v1.0.0.db');

    final exists = await databaseExists(path);

    if (!exists) {
      print("Creating new copy from asset ${path}");

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(
        join("assets", "database", "otis_v1.0.0.db"),
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
}
