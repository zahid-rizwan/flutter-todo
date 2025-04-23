import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';
import '../../domain/usecases/register_user.dart';
part 'auth_event.dart';
part 'auth_state.dart';

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final LogoutUser logoutUser;
  final GetCurrentUser getCurrentUser;

  AuthBloc({
    required this.loginUser,
    required this.registerUser,
    required this.logoutUser,
    required this.getCurrentUser,
  }) : super(AuthInitialState()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      // This would normally call the use case with proper params
      // For now, we'll simulate a successful login
      await Future.delayed(const Duration(seconds: 1));

      final user = User(
        id: '1',
        name: 'Fazil Laghari',
        email: event.email,
        avatarUrl: null,
      );

      emit(AuthenticatedState(user: user));
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      // This would normally call the use case with proper params
      // For now, we'll simulate a successful registration
      await Future.delayed(const Duration(seconds: 1));

      final user = User(
        id: '1',
        name: event.name,
        email: event.email,
        avatarUrl: null,
      );

      emit(AuthenticatedState(user: user));
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      // This would normally call the use case
      // For now, we'll simulate a successful logout
      await Future.delayed(const Duration(milliseconds: 500));

      emit(UnauthenticatedState());
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      // This would normally call the use case to check if user is logged in
      // For now, we'll simulate no user is logged in
      await Future.delayed(const Duration(milliseconds: 500));

      emit(UnauthenticatedState());
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }
}