import 'package:sqflite/sqflite.dart';
import 'profile_remote_datasource.dart';
import '../../models/user_model.dart';

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final Database database;

  ProfileRemoteDatasourceImpl(this.database);

  @override
  Future<int> updateUserProfile({
    required int userId,
    required String fullName,
    required String address,
    required String phone,
  }) async {
    return database.update(
      'users',
      {'full_name': fullName, 'address': address, 'phone': phone},
      where: 'user_id = ?',
      whereArgs: [userId],
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  @override
  Future<UserModel?> getUserById(int userId) async {
    final rows = await database.query(
      'users',
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return UserModel.fromJson(rows.first);
  }

  @override
  Future<int> countCustomers() async {
    final rows = await database.rawQuery('''
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

  @override
  Future<int> updateUserStatus({
    required int userId,
    required String status,
  }) async {
    return database.update(
      'users',
      {'status': status},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  @override
  Future<List<UserModel>> getUsers({
    String? query,
    String? status,
    String? sortBy,
  }) async {
    final whereParts = <String>[
      "r.role_name = 'customer'",
    ];
    final args = <Object?>[];

    if (query != null && query.isNotEmpty) {
      whereParts.add("(u.full_name LIKE ? OR u.phone LIKE ? OR u.shop_name LIKE ?)");
      final kw = '%$query%';
      args.add(kw);
      args.add(kw);
      args.add(kw);
    }

    if (status != null && status != 'all') {
      whereParts.add("u.status = ?");
      args.add(status);
    }

    final orderBySql = sortBy == 'oldest' ? 'u.user_id ASC' : 'u.user_id DESC';

    final sql = '''
      SELECT 
        u.*,
        r.role_name
      FROM users u
      INNER JOIN user_roles r ON r.role_id = u.role_id
      WHERE ${whereParts.join(' AND ')}
      ORDER BY $orderBySql
    ''';

    final rows = await database.rawQuery(sql, args);
    return rows.map((m) => UserModel.fromJson(m)).toList();
  }
}
