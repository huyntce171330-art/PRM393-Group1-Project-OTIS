import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDatasource chatRemoteDatasource;

  ChatRepositoryImpl(this.chatRemoteDatasource);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getChatRoomList() async {
    try {
      final result = await chatRemoteDatasource.getChatRoomList();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server Failure'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getAdminUnreadMessageCount({int adminId = 1}) async {
    try {
      final result = await chatRemoteDatasource.getAdminUnreadMessageCount(adminId: adminId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server Failure'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAdminChatRooms({int adminId = 1}) async {
    try {
      final result = await chatRemoteDatasource.getAdminChatRooms(adminId: adminId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server Failure'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> insertMessage({
    required int roomId,
    required int senderId,
    required String content,
    String? createdAt,
    int isRead = 0,
  }) async {
    try {
      final result = await chatRemoteDatasource.insertMessage(
        roomId: roomId,
        senderId: senderId,
        content: content,
        createdAt: createdAt,
        isRead: isRead,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server Failure'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getMessagesByRoom(int roomId) async {
    try {
      final result = await chatRemoteDatasource.getMessagesByRoom(roomId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server Failure'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCountForRoom({required int roomId, required int viewerId}) async {
    try {
      final result = await chatRemoteDatasource.getUnreadCountForRoom(roomId: roomId, viewerId: viewerId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server Failure'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalUnreadCount({required int viewerId}) async {
    try {
      final result = await chatRemoteDatasource.getTotalUnreadCount(viewerId: viewerId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server Failure'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> markRoomMessagesAsRead({required int roomId, required int viewerId}) async {
    try {
      final result = await chatRemoteDatasource.markRoomMessagesAsRead(roomId: roomId, viewerId: viewerId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server Failure'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllChatRoomsForViewer({required int viewerId}) async {
    try {
      final result = await chatRemoteDatasource.getAllChatRoomsForViewer(viewerId: viewerId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server Failure'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int?>> getRoomIdByUserId(int userId) async {
    try {
      final result = await chatRemoteDatasource.getRoomIdByUserId(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server Failure'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
