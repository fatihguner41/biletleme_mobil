import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/core/usecase/usecase.dart';
import 'package:ticketing/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:ticketing/features/auth/domain/usecases/login_usecase.dart';
import 'package:ticketing/features/auth/domain/usecases/logout_usecase.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
class AuthCubit extends Cubit<AuthState> {
  final CheckAuthUseCase checkAuthUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  AuthCubit({
    required this.checkAuthUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial());

  Future<void> appStarted() async {
    final isLoggedIn = await checkAuthUseCase(NoParams());
    isLoggedIn
        ? emit(AuthAuthenticated())
        : emit(AuthUnauthenticated());
  }

  Future<void> signIn(String email, String password) async {
    try{
      emit(AuthLoading());
      await loginUseCase(LoginParams(email, password));
      emit(AuthAuthenticated());
    }catch(e){
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    await logoutUseCase(NoParams());
    emit(AuthUnauthenticated());
  }
}
