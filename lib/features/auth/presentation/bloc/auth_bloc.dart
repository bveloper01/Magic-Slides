import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, BlocAuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<BlocAuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userId = await authRepository.signUp(event.email, event.password);
      if (userId != null) {
        emit(AuthAuthenticated(userId));
      } else {
        emit(AuthError('Signup failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<BlocAuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userId = await authRepository.login(event.email, event.password);
      if (userId != null) {
        emit(AuthAuthenticated(userId));
      } else {
        emit(AuthError('Login failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<BlocAuthState> emit,
  ) async {
    await authRepository.logout();
    emit(AuthUnauthenticated());
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<BlocAuthState> emit,
  ) async {
    final isLoggedIn = await authRepository.isUserLoggedIn();
    if (isLoggedIn) {
      final userId = await authRepository.getCurrentUser();
      if (userId != null) {
        emit(AuthAuthenticated(userId));
      } else {
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }
}