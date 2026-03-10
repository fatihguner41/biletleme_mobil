import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/purchase_ticket_usecase.dart';
import 'ticket_purchase_state.dart';

class TicketPurchaseCubit extends Cubit<TicketPurchaseState> {
  final PurchaseTicketUseCase purchaseTicketUseCase;

  TicketPurchaseCubit({required this.purchaseTicketUseCase})
      : super(TicketPurchaseInitial());

  Future<void> purchase(String eventId, String eventName) async {
    try {
      emit(TicketPurchaseLoading());
      await purchaseTicketUseCase(PurchaseTicketParams(eventId: eventId, eventName: eventName));
      emit(TicketPurchaseSuccess());
    } catch (e) {
      emit(TicketPurchaseFailure(e.toString()));
    }
  }
}