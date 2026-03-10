import '../../domain/entities/ticket.dart';

enum TicketsStatus { initial, loading, success, failure }

class TicketsState {
  final TicketsStatus status;
  final List<Ticket> tickets;
  final String? errorMessage;

  const TicketsState({
    required this.status,
    required this.tickets,
    this.errorMessage,
  });

  factory TicketsState.initial() => const TicketsState(
    status: TicketsStatus.initial,
    tickets: [],
  );

  TicketsState copyWith({
    TicketsStatus? status,
    List<Ticket>? tickets,
    String? errorMessage,
  }) {
    return TicketsState(
      status: status ?? this.status,
      tickets: tickets ?? this.tickets,
      errorMessage: errorMessage,
    );
  }
}