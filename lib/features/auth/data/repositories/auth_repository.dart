import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasources.dart';
import '../datasources/auth_remote_datasources.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    // This would normally check network connection and call the remote data source
    // For now, we'll simulate a successful login
    try {
      final user = User(
        id: '1',
        name: 'Fazil Laghari',
        email: email,
        avatarUrl: null,
      );

      return Right(user);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // This would normally check network connection and call the remote data source
    // For now, we'll simulate a successful registration
    try {
      final user = User(
        id: '1',
        name: name,
        email: email,
        avatarUrl: null,
      );

      return Right(user);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    // This would normally call the local data source to clear user data
    // For now, we'll simulate a successful logout
    try {
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    // This would normally call the local data source to get the current user
    // For now, we'll simulate no user is logged in
    try {
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
}