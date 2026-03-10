import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<void, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<void> call(RegisterParams params) {
    return repository.register(email: params.email, password: params.password, name: params.name, surname: params.surname);
  }
}

class RegisterParams {
  final String email;
  final String password;
  final String name;
  final String surname;

  RegisterParams(this.email, this.password, this.name, this.surname);

}