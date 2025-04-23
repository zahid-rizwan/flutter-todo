import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/user.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/update_user_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;

  ProfileBloc({
    required this.getUserProfile,
    required this.updateUserProfile,
  }) : super(ProfileInitialState()) {
    on<GetProfileEvent>(_onGetProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onGetProfile(GetProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());

    try {
      // This would normally call the use case
      // For now, we'll simulate fetching user profile
      await Future.delayed(const Duration(seconds: 1));

      final user = User(
        id: '1',
        name: 'Fazil Laghari',
        email: 'fazzzil72@gmail.com',
        avatarUrl: null,
      );

      emit(ProfileLoadedState(user: user));
    } catch (e) {
      emit(ProfileErrorState(message: e.toString()));
    }
  }

  Future<void> _onUpdateProfile(UpdateProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());

    try {
      // This would normally call the use case
      // For now, we'll simulate updating user profile
      await Future.delayed(const Duration(seconds: 1));

      final user = User(
        id: '1',
        name: event.name,
        email: event.email,
        avatarUrl: null,
      );

      emit(ProfileUpdatedState(user: user));
      emit(ProfileLoadedState(user: user));
    } catch (e) {
      emit(ProfileErrorState(message: e.toString()));
    }
  }
}