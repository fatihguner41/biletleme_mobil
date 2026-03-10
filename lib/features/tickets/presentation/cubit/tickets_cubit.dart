import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/core/usecase/usecase.dart';
import '../../domain/usecases/get_my_tickets_usecase.dart';
import 'tickets_state.dart';

class TicketsCubit extends Cubit<TicketsState> {
  final GetMyTicketsUseCase getMyTicketsUseCase;

  TicketsCubit({
    required this.getMyTicketsUseCase,
  }) : super(TicketsState.initial());

  Future<void> load() async {
    try {
      emit(state.copyWith(status: TicketsStatus.loading, errorMessage: null));
      final tickets = await getMyTicketsUseCase(NoParams());
      emit(state.copyWith(status: TicketsStatus.success, tickets: tickets));
    } catch (e) {
      emit(state.copyWith(status: TicketsStatus.failure, errorMessage: e.toString()));
    }
  }

}