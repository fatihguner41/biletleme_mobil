import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/features/events/domain/usecases/get_events_usecase.dart';
import 'package:ticketing/features/events/presentation/bloc/event_event.dart';
import 'package:ticketing/features/events/presentation/bloc/event_state.dart';

class EventBloc extends Bloc<EventEvent,EventState>{
  final GetEventsUsecase getEventsUsecase;

  EventBloc(this.getEventsUsecase):super(EventInitial()){
    on<FetchEvents>(_onFetchEvents);
  }

  Future<void> _onFetchEvents(FetchEvents event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try{
      final events = await getEventsUsecase();
      emit(EventLoaded(events));
    }catch(e){
      emit(EventError("Event loading failed."));
    }
  }

}