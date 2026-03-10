import 'dart:convert';

class JwtPayload {
  final String? email;
  final String? name;
  final String? surname;
  final int? exp;

  const JwtPayload({
    this.email,
    this.name,
    this.surname,
    this.exp,
  });

  factory JwtPayload.fromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return const JwtPayload();

      final payloadPart = parts[1];

      // base64Url decode: padding fix
      final normalized = base64Url.normalize(payloadPart);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final map = jsonDecode(decoded) as Map<String, dynamic>;

      return JwtPayload(
        email: map['email'] as String?,
        name: map['name'] as String?,
        surname: map['surname'] as String?,
        exp: (map['exp'] as num?)?.toInt(),
      );
    } catch (_) {
      return const JwtPayload();
    }
  }

  bool get isExpired {
    if (exp == null) return false;
    return DateTime.now().millisecondsSinceEpoch >= exp!;
  }

  String get fullName {
    final n = (name ?? '').trim();
    final s = (surname ?? '').trim();
    final both = '$n $s'.trim();
    return both.isEmpty ? 'User' : both;
  }
}