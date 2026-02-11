import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<void, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<void> call(LoginParams params) {
    return repository.login(email:params.email, password:params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams(this.email, this.password);
}
