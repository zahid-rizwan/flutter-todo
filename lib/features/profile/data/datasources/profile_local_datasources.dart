import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../auth/data/models/user_model.dart';

abstract class ProfileLocalDataSource {
  Future<UserModel?> getUserProfile();
  Future<void> saveUserProfile(UserModel user);
}

const CACHED_USER_PROFILE_KEY = 'CACHED_USER_PROFILE';

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProfileLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel?> getUserProfile() async {
    final jsonString = sharedPreferences.getString(CACHED_USER_PROFILE_KEY);

    if (jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    }

    return null;
  }

  @override
  Future<void> saveUserProfile(UserModel user) async {
    await sharedPreferences.setString(
      CACHED_USER_PROFILE_KEY,
      json.encode(user.toJson()),
    );
  }
}