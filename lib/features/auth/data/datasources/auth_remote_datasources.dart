
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // This would normally use Supabase client
  // For now, we'll just implement the methods with mock data

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    return UserModel(
      id: '1',
      name: 'Fazil Laghari',
      email: email,
      avatarUrl: null,
    );
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    return UserModel(
      id: '1',
      name: name,
      email: email,
      avatarUrl: null,
    );
  }

  @override
  Future<void> logout() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    return;
  }
}