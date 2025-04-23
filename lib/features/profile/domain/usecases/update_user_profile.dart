import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user.dart';
import '../repositories/profile_repository.dart';


class UpdateUserProfileParams {
  final String name;
  final String email;
  final String? password;

  UpdateUserProfileParams({
    required this.name,
    required this.email,
    this.password,
  });
}

class UpdateUserProfile {
  final ProfileRepository repository;

  UpdateUserProfile(this.repository);

  Future<Either<Failure, User>> call(UpdateUserProfileParams params) async {
    return await repository.updateUserProfile(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}