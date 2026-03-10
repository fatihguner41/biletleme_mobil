import 'dart:convert';
import 'dart:math';

import '../../../../core/fake_backend/fake_db.dart';

class FakeAuthRemoteService {
  final FakeDb _db;

  FakeAuthRemoteService(this._db);

  Future<void> register(
      {required String email, required String password, required String name, required String surname}) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final e = email.trim();
    final p = password.trim();
    final n = name.trim();
    final s = surname.trim();

    if (e.isEmpty || p.isEmpty) throw Exception('Email/password required');
    if (!e.contains('@')) throw Exception('Invalid email');

    _db.insertUser(email: e, password: p, name: n, surname: s);
  }

  Future<String> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final e = email.trim();
    final p = password.trim();

    if (e.isEmpty || p.isEmpty) throw Exception('Invalid credentials');

    final user = _db.getUser(e);
    if (user == null) throw Exception('User not found');
    if (user.password != p) throw Exception('Wrong password');

    // fake JWT
    final header = base64UrlEncode(
      utf8.encode(jsonEncode({'alg': 'HS256', 'typ': 'JWT'})),
    );

    final payload = base64UrlEncode(
      utf8.encode(
        jsonEncode({
          'email': user.email,
          'name': user.name,
          'surname': user.surname,

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