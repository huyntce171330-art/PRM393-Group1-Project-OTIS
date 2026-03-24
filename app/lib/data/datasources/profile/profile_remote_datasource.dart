import '../../models/user_model.dart';

abstract class ProfileRemoteDatasource {
  Future<int> updateUserProfile({
    required int userId,
    required String fullName,
    required String address,
    required String phone,
  });

  Future<UserModel?> getUserById(int userId);

  Future<int> countCustomers();

  Future<int> updateUserStatus({
    required int userId,
    required String status,
  });

  Future<List<UserModel>> getUsers({
    String? query,
    String? status,
    String? sortBy,
  });
}
