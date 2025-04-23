import 'package:supabase_flutter/supabase_flutter.dart';
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
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Login failed');
    }

    final userData = await supabaseClient
        .from('profiles')
        .select()
        .eq('id', response.user!.id)
        .single();

    return UserModel(
      id: response.user!.id,
      name: userData['name'] ?? 'No Name',
      email: response.user!.email ?? email,
      avatarUrl: userData['avatar_url'],
    );
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await supabaseClient.auth.signUp(
      email: email,
      password: password,
      data: {
        'name': name,
        'email': email,
      },
    );

    if (response.user == null) {
      throw Exception('Registration failed');
    }

    // Insert user profile data
    await supabaseClient.from('profiles').insert({
      'id': response.user!.id,
      'name': name,
      'email': email,
    });

    return UserModel(
      id: response.user!.id,
      name: name,
      email: email,
      avatarUrl: null,
    );
  }

  @override
  Future<void> logout() async {
    await supabaseClient.auth.signOut();
  }
}