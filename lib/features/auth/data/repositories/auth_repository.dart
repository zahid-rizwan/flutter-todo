import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart' as app_user;
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasources.dart';
import '../datasources/auth_remote_datasources.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final supabase.SupabaseClient supabaseClient;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.supabaseClient,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, app_user.User>> login({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: ''));
    }

    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return Left(AuthFailure(message: 'User not found'));
      }

      final userData = await supabaseClient
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .single();

      final user = app_user.User(
        id: response.user!.id,
        name: userData['name'] ?? 'No Name',
        email: response.user!.email ?? email,
        avatarUrl: userData['avatar_url'],
      );

      await localDataSource.saveUser(UserModel.fromEntity(user));

      return Right(user);
    } on supabase.AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(AuthFailure(message: 'Login failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, app_user.User>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: ''));
    }

    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'email': email,
        },
      );

      if (response.user == null) {
        return Left(AuthFailure(message: 'Registration failed'));
      }

      // Insert user profile data
      await supabaseClient.from('profiles').insert({
        'id': response.user!.id,
        'name': name,
        'email': email,
      });

      final user = app_user.User(
        id: response.user!.id,
        name: name,
        email: email,
        avatarUrl: null,
      );

      await localDataSource.saveUser(UserModel.fromEntity(user));

      return Right(user);
    } on supabase.AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(AuthFailure(message: 'Registration failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await supabaseClient.auth.signOut();
      await localDataSource.removeUser();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(message: 'Logout failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, app_user.User?>> getCurrentUser() async {
    try {
      final session = supabaseClient.auth.currentSession;
      if (session == null) {
        return const Right(null);
      }

      final user = session.user;
      if (user == null) {
        return const Right(null);
      }

      final userData = await supabaseClient
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return Right(app_user.User(
        id: user.id,
        name: userData['name'] ?? 'No Name',
        email: user.email ?? '',
        avatarUrl: userData['avatar_url'],
      ));
    } catch (e) {
      return Left(AuthFailure(message: 'Failed to get current user: ${e.toString()}'));
    }
  }
}