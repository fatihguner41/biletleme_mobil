abstract class AuthRepository {

  Future<void> login({
    required String email,
    required String password,
  });

  Future<void> register({required String email, required String password, required String name, required String surname});

  Future<void> logout();

  Future<bool> isLoggedIn();

  Future<String?> getToken();
  Map<String, dynamic>? decodePayload(String token);
}
