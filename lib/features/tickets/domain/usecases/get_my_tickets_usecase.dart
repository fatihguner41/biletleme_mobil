import 'package:ticketing/core/usecase/usecase.dart';
import '../entities/ticket.dart';
import '../repositories/ticket_repository.dart';

class GetMyTicketsUseCase implements UseCase<List<Ticket>, NoParams> {
  final TicketRepository repository;

  GetMyTicketsUseCase(this.repository);

  @override
  Future<List<Ticket>> call(NoParams params) {
    return repository.myTickets();
  }
}