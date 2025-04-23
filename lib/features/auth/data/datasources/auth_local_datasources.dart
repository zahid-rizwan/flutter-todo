import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getUser();
  Future<void> saveUser(UserModel user);
  Future<void> removeUser();
}

const CACHED_USER_KEY = 'CACHED_USER';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel?> getUser() async {
    final jsonString = sharedPreferences.getString(CACHED_USER_KEY);

    if (jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    }

    return null;
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await sharedPreferences.setString(
      CACHED_USER_KEY,
      json.encode(user.toJson()),
    );
  }

  @override
  Future<void> removeUser() async {
    await sharedPreferences.remove(CACHED_USER_KEY);
  }
}