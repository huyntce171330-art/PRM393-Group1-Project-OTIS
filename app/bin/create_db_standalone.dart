import 'dart:io';
import 'dart:convert';

// Simple SQLite wrapper using process
void main() async {
  print('========================================');
  print('🔄 CREATING NEW DATABASE');
  print('========================================\n');

  final dbPath = 'app/assets/database/otis.db';
  final sqlFilePath = 'database/migration_v2.sql';

  // Create directory if not exists
  Directory(dbPath.replaceAll('otis.db', '')).create(recursive: true);

  // Delete existing database
  if (File(dbPath).existsSync()) {
    File(dbPath).deleteSync();
    print('🗑️ Deleted existing database');
  }

  print('📦 Creating new database...');
  print('📋 Reading from: $sqlFilePath');

  // Read SQL from migration file
  final sqlContent = File(sqlFilePath).readAsStringSync();

  // Write SQL to temp file
  final tempSqlFile = 'temp_create_db.sql';
  File(tempSqlFile).writeAsStringSync(sqlContent);

  // Execute using sqlite3 with file redirection
  final result = await Process.run('sqlite3', [dbPath]);

  // Pass SQL via stdin
  final process = await Process.start('sqlite3', [dbPath]);
  process.stdin.write(sqlContent);
  await process.stdin.flush();
  await process.stdin.close();

  final exitCode = await process.exitCode;

  // Clean up temp file
  File(tempSqlFile).deleteSync();

  if (exitCode != 0) {
    print('❌ Error creating database');
    print('stderr: ${await process.stderr.transform(utf8.decoder).join()}');
    return;
  }

  print('✅ All tables created and data inserted');

  // Verify
  final verifyResult = await Process.run('sqlite3', [dbPath, '.tables']);
  print('📊 Tables: ${verifyResult.stdout}');

  // Count products
  final countResult = await Process.run('sqlite3', [
    dbPath,
    'SELECT COUNT(*) FROM products;',
  ]);
  print('📊 Products count: ${countResult.stdout.trim()}');

  print('\n========================================');
  print('✅ DATABASE CREATED SUCCESSFULLY!');
  print('========================================');
  print('📍 Database: $dbPath');
}
