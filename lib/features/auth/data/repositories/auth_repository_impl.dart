import 'package:ticketing/core/storage/token_storage.dart';
import 'package:ticketing/features/auth/data/services/fake_auth_remote_service.dart';
import 'package:ticketing/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository{
  final FakeAuthRemoteService authService;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({required this.authService, required this.tokenStorage});

  @override
  Future<String?> getToken() async{
    // TODO: implement getToken
    return await tokenStorage.read();
  }

  @override
  Future<bool> isLoggedIn() async{
    // TODO: implement isLoggedIn
    return await tokenStorage.read() != null;
  }

  @override
  Future<void> login({required String email, required String password}) async{
    // TODO: implement login
    final token = await authService.login(email, password);
    await tokenStorage.save(token);
  }

  @override
  Future<void> logout() async{
    await tokenStorage.clear();
  }

}