import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FakeUser {
  final String email;
  final String password;
  final String name;
  final String surname;

  FakeUser({
    required this.email,
    required this.password,
    required this.name,
    required this.surname,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'name': name,
    'surname': surname,
  };

  factory FakeUser.fromJson(Map<String, dynamic> json) => FakeUser(
    email: json['email'] as String,
    password: json['password'] as String,
    name: json['name'] as String,
    surname: json['surname'] as String,
  );
}

class FakeTicket {
  final String id;
  final String userEmail;
  final String eventId;
  final String eventName;
  final String qrData;
  final int createdAtMs;

  FakeTicket({
    required this.id,
    required this.userEmail,
    required this.eventId,
    required this.eventName,
    required this.qrData,
    required this.createdAtMs,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userEmail': userEmail,
    'eventId': eventId,
    'eventName': eventName,
    'qrData': qrData,
    'createdAtMs': createdAtMs,
  };

  factory FakeTicket.fromJson(Map<String, dynamic> json) => FakeTicket(
    id: json['id'] as String,
    userEmail: json['userEmail'] as String,
    eventId: json['eventId'] as String,
    eventName: json['eventName'] as String,
    qrData: json['qrData'] as String,
    createdAtMs: (json['createdAtMs'] as num).toInt(),
  );
}

class FakeDb {
  static const _kUsers = 'fake_db_users';
  static const _kTickets = 'fake_db_tickets';

  final SharedPreferences _prefs;

  FakeDb(this._prefs);

  final Map<String, FakeUser> _usersByEmail = {};
  final List<FakeTicket> _tickets = [];

  /// App açılırken bir kere çağır
  Future<void> init() async {
    final usersRaw = _prefs.getString(_kUsers);
    if (usersRaw != null && usersRaw.isNotEmpty) {
      final list = (jsonDecode(usersRaw) as List).cast<dynamic>();
      for (final item in list) {
        final u = FakeUser.fromJson((item as Map).cast<String, dynamic>());
        _usersByEmail[u.email] = u;
      }
    }

    final ticketsRaw = _prefs.getString(_kTickets);
    if (ticketsRaw != null && ticketsRaw.isNotEmpty) {
      final list = (jsonDecode(ticketsRaw) as List).cast<dynamic>();
      _tickets
        ..clear()
        ..addAll(list.map((e) => FakeTicket.fromJson((e as Map).cast<String, dynamic>())));
    }
  }

  Future<void> _persistUsers() async {
    final list = _usersByEmail.values.map((u) => u.toJson()).toList();
    await _prefs.setString(_kUsers, jsonEncode(list));
  }

  Future<void> _persistTickets() async {
    final list = _tickets.map((t) => t.toJson()).toList();
    await _prefs.setString(_kTickets, jsonEncode(list));
  }

  FakeUser? getUser(String email) => _usersByEmail[email];

  Future<void> insertUser({
    required String email,
    required String password,
    required String name,
    required String surname,
  }) async {
    if (_usersByEmail.containsKey(email)) {
      throw Exception('User already exists');
    }
    _usersByEmail[email] = FakeUser(
      email: email,
      password: password,
      name: name,
      surname: surname,
    );
    await _persistUsers();
  }

  Future<FakeTicket> insertTicket({
    required FakeTicket ticket,
  }) async {
    _tickets.add(ticket);
    await _persistTickets();
    return ticket;
  }

  List<FakeTicket> getTicketsForUser(String email) {
    final list = _tickets.where((t) => t.userEmail == email).toList();
    list.sort((a, b) => b.createdAtMs.compareTo(a.createdAtMs));
    return list;
  }
}