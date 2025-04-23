import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasources.dart';
import '../datasources/profile_remote_datasources.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> getUserProfile() async {
    // This would normally check network connection and call the remote data source
    // For now, we'll simulate fetching user profile
    try {
      final user = User(
        id: '1',
        name: 'Fazil Laghari',
        email: 'fazzzil72@gmail.com',
        avatarUrl: null,
      );

      return Right(user);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateUserProfile({
    required String name,
    required String email,
    String? password,
  }) async {
    // This would normally check network connection and call the remote data source
    // For now, we'll simulate updating user profile
    try {
      final user = User(
        id: '1',
        name: name,
        email: email,
        avatarUrl: null,
      );

      return Right(user);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}