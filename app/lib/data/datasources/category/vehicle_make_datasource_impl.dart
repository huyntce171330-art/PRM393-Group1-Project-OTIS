import 'package:sqflite/sqflite.dart';

import '../../models/vehicle_make_model.dart';
import 'vehicle_make_datasource.dart';

class VehicleMakeDataSourceImpl implements VehicleMakeDataSource {
  final Database database;

  VehicleMakeDataSourceImpl(this.database);

  @override
  Future<List<VehicleMakeModel>> getAll() async {
    final result = await database.query('vehicle_makes');

    return result.map((e) => VehicleMakeModel.fromJson(e)).toList();
  }

  @override
  Future<VehicleMakeModel> getById(String id) async {
    final result = await database.query(
      'vehicle_makes',
      where: 'make_id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) {
      throw Exception('Vehicle make not found');
    }

    return VehicleMakeModel.fromJson(result.first);
  }

  @override
  Future<void> create(VehicleMakeModel make) async {
    await database.insert('vehicle_makes', make.toJson());
  }

  @override
  Future<void> update(VehicleMakeModel make) async {
    await database.update(
      'vehicle_makes',
      make.toJson(),
      where: 'make_id = ?',
      whereArgs: [make.id],
    );
  }

  @override
  Future<void> delete(String id) async {
    await database.delete(
      'vehicle_makes',
      where: 'make_id = ?',
      whereArgs: [id],
    );
  }
}