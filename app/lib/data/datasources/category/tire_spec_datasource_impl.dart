import 'package:sqflite/sqflite.dart';

import '../../models/tire_spec_model.dart';
import 'tire_spec_datasource.dart';

class TireSpecDataSourceImpl implements TireSpecDataSource {
  final Database database;

  TireSpecDataSourceImpl(this.database);

  @override
  Future<List<TireSpecModel>> getAll() async {
    final result = await database.query('tire_specs');

    return result.map((e) => TireSpecModel.fromJson(e)).toList();
  }

  @override
  Future<TireSpecModel> getById(String id) async {
    final result = await database.query(
      'tire_specs',
      where: 'tire_spec_id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) {
      throw Exception('Tire spec not found');
    }

    return TireSpecModel.fromJson(result.first);
  }

  @override
  Future<void> create(TireSpecModel spec) async {
    await database.insert('tire_specs', spec.toJson());
  }

  @override
  Future<void> update(TireSpecModel spec) async {
    await database.update(
      'tire_specs',
      spec.toJson(),
      where: 'tire_spec_id = ?',
      whereArgs: [spec.id],
    );
  }

  @override
  Future<void> delete(String id) async {
    await database.delete(
      'tire_specs',
      where: 'tire_spec_id = ?',
      whereArgs: [id],
    );
  }
}