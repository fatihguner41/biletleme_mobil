import 'dart:convert';

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
  Map<String, dynamic>? decodePayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return null;
      final normalized = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(normalized));
      return (jsonDecode(decoded) as Map).cast<String, dynamic>();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await tokenStorage.read();
    if (token == null) return false;

    final payload = decodePayload(token);
    final exp = (payload?['exp'] as num?)?.toInt();
    if (exp == null) return true;

    final now = DateTime.now().millisecondsSinceEpoch;
    if (now >= exp) {
      await tokenStorage.clear();
      return false;
    }

    return true;
  }
  @override
  Future<void> login({required String email, required String password}) async{
    // TODO: implement login
    final token = await authService.login(email, password);
    await tokenStorage.save(token);
  }

  @override
  Future<void> register({required String email, required String password, required String name, required String surname}) async {
    await authService.register(email: email, password: password, name: name, surname: surname);
  }

  @override
  Future<void> logout() async{
    await tokenStorage.clear();
  }

}