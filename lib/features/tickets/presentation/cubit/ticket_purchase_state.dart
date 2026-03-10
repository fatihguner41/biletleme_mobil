abstract class TicketPurchaseState {}

class TicketPurchaseInitial extends TicketPurchaseState {}

class TicketPurchaseLoading extends TicketPurchaseState {}

class TicketPurchaseSuccess extends TicketPurchaseState {}

class TicketPurchaseFailure extends TicketPurchaseState {
  final String message;
  TicketPurchaseFailure(this.message);
}