
import '../../../auth/data/models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getUserProfile();
  Future<UserModel> updateUserProfile({
    required String name,
    required String email,
    String? password,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  // This would normally use Supabase client
  // For now, we'll just implement the methods with mock data

  @override
  Future<UserModel> getUserProfile() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    return UserModel(
      id: '1',
      name: 'Fazil Laghari',
      email: 'fazzzil72@gmail.com',
      avatarUrl: null,
    );
  }

  @override
  Future<UserModel> updateUserProfile({
    required String name,
    required String email,
    String? password,
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
}