import '../entities/ticket.dart';

abstract class TicketRepository {
  Future<Ticket> purchaseTicket(String eventId, String eventName);
  Future<List<Ticket>> myTickets();
}
