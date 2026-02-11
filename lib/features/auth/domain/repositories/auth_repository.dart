abstract class AuthRepository {
  Future<void> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<bool> isLoggedIn();

  Future<String?> getToken();
}
