import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/core/auth/jwt_payload.dart';
import 'package:ticketing/core/usecase/usecase.dart';
import 'package:ticketing/features/auth/domain/usecases/get_token_usecase.dart';


import 'package:ticketing/core/auth/jwt_payload.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final JwtPayload payload;
  ProfileLoaded(this.payload);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileCubit extends Cubit<ProfileState> {
  final GetTokenUseCase getTokenUseCase;

  ProfileCubit({required this.getTokenUseCase}) : super(ProfileInitial());

  Future<void> load() async {
    try {
      emit(ProfileLoading());
      final token = await getTokenUseCase(NoParams());
      if (token == null) {
        emit(ProfileLoaded(const JwtPayload()));
        return;
      }
      emit(ProfileLoaded(JwtPayload.fromToken(token)));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}