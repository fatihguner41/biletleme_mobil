import 'dart:convert';
import 'dart:math';

class FakeAuthRemoteService {
  Future<String> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.isEmpty) {
      throw Exception('Invalid credentials');
    }

    final header = base64UrlEncode(
      utf8.encode(jsonEncode({'alg': 'HS256', 'typ': 'JWT'})),
    );

    final payload = base64UrlEncode(
      utf8.encode(
        jsonEncode({
          'email': email,
          'exp': DateTime.now()
              .add(const Duration(hours: 2))
              .millisecondsSinceEpoch,
        }),
      ),
    );

    final signature = base64UrlEncode(
      utf8.encode(Random().nextInt(9999999).toString()),
    );

    return '$header.$payload.$signature';
  }
}
