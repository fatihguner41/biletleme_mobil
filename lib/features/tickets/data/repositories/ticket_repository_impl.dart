import 'dart:convert';
import 'dart:math';
import 'package:ticketing/core/fake_backend/fake_db.dart';
import 'package:ticketing/features/auth/domain/repositories/auth_repository.dart';
import 'package:ticketing/features/tickets/domain/entities/ticket.dart';

import '../../domain/repositories/ticket_repository.dart';

class TicketRepositoryImpl extends TicketRepository{
  final FakeDb db;
  final AuthRepository authRepository;

  TicketRepositoryImpl({required this.db, required this.authRepository});

  @override
  Future<Ticket> purchaseTicket(String eventId, String eventName) async {
    final token = await authRepository.getToken();
    if (token == null) throw Exception('Not logged in');

    // token payload’dan email’i çek (pratik)
    final email = _emailFromToken(token);
    if (email == null) throw Exception('Invalid token');

    final id = _randomId();
    final qr = 'TICKET:$id:$eventId:$email';

    final createdAtMs = DateTime.now().millisecondsSinceEpoch;

    final saved = await db.insertTicket(
      ticket: FakeTicket(
        id: id,
        userEmail: email,
        eventId: eventId,
        eventName: eventName,
        qrData: qr,
        createdAtMs: createdAtMs,
      ),
    );

    return Ticket(
      id: saved.id,
      eventId: saved.eventId,
      eventName: saved.eventName,
      qrData: saved.qrData,
      createdAt: DateTime.fromMillisecondsSinceEpoch(saved.createdAtMs),
    );
  }

  @override
  Future<List<Ticket>> myTickets() async {
    final token = await authRepository.getToken();
    if (token == null) return [];

    final email = _emailFromToken(token);
    if (email == null) return [];

    return db.getTicketsForUser(email).map((t) {
      return Ticket(
        id: t.id,
        eventId: t.eventId,
        eventName: t.eventName,
        qrData: t.qrData,
        createdAt: DateTime.fromMillisecondsSinceEpoch(t.createdAtMs),
      );
    }).toList();
  }

  String _randomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final r = Random();
    return List.generate(12, (_) => chars[r.nextInt(chars.length)]).join();
  }

  String? _emailFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return null;
      final normalized = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final map = (jsonDecode(decoded) as Map).cast<String, dynamic>();
      return map['email'] as String?;
    } catch (_) {
      return null;
    }
  }
  String? _eventNameFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return null;
      final normalized = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final map = (jsonDecode(decoded) as Map).cast<String, dynamic>();
      return map['eventName'] as String?;
    } catch (_) {
      return null;
    }
  }
}