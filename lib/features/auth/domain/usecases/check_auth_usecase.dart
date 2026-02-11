import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class CheckAuthUseCase implements UseCase<bool, NoParams> {
  final AuthRepository repository;

  CheckAuthUseCase(this.repository);

  @override
  Future<bool> call(NoParams params) {
    return repository.isLoggedIn();
  }
}
