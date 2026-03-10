import 'package:ticketing/core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class GetTokenUseCase implements UseCase<String?, NoParams> {
  final AuthRepository repository;

  GetTokenUseCase(this.repository);

  @override
  Future<String?> call(NoParams params) {
    return repository.getToken();
  }
}