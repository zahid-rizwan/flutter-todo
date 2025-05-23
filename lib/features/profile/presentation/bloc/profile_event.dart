part of 'profile_bloc.dart';


abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String name;
  final String email;
  final String? password;

  const UpdateProfileEvent({
    required this.name,
    required this.email,
    this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

