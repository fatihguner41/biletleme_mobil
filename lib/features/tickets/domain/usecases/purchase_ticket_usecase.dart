import 'package:ticketing/core/usecase/usecase.dart';
import '../entities/ticket.dart';
import '../repositories/ticket_repository.dart';

class PurchaseTicketParams {
  final String eventId;
  final String eventName;

  PurchaseTicketParams({
    required this.eventId,
    required this.eventName,
  });
}
class PurchaseTicketUseCase implements UseCase<Ticket, PurchaseTicketParams> {
  final TicketRepository repository;

  PurchaseTicketUseCase(this.repository);

  @override
  Future<Ticket> call(PurchaseTicketParams params) {
    return repository.purchaseTicket(
      params.eventId, params.eventName
    );
  }
}