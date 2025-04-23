part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final User user;

  const ProfileLoadedState({required this.user});

  @override
  List<Object?> get props => [user];
}

class ProfileUpdatedState extends ProfileState {
  final User user;

  const ProfileUpdatedState({required this.user});

  @override
  List<Object?> get props => [user];
}

class ProfileErrorState extends ProfileState {
  final String message;

  const ProfileErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}