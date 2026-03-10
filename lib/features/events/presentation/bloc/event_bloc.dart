import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/features/events/domain/usecases/get_events_by_venue_id_usecase.dart';
import 'package:ticketing/features/events/domain/usecases/get_events_usecase.dart';

import 'event_event.dart';
import 'event_state.dart';
class EventBloc extends Bloc<EventEvent, EventState> {
  final GetEventsUsecase _searchEvents;
  final GetEventsByVenueIdUsecase _searchEventsByVenueId;


  EventBloc(this._searchEvents, this._searchEventsByVenueId)
      : super(EventState.initial()) {
    on<EventQueryChanged>(_onQueryChanged);
    on<VenuePageOpened>(_venuePageOpened);
    on<EventClassificationChanged>(_onClassificationChanged);
    on<EventLoadMoreRequested>(_onLoadMore);
    on<EventLoadMoreByVenueIdRequested>(_onLoadMoreByVenueId);
  }
  Future<void> _venuePageOpened(
      VenuePageOpened event,
      Emitter<EventState> emit,
      ) async {
    emit(state.copyWith(
      status: EventStatus.loading,
      venueId: event.venueId,
      page: 0,
      events: [],
      hasMore: true,
    ));

    final result = await _searchEventsByVenueId(
        venueId: event.venueId,
        page: 0,
    );

    emit(state.copyWith(
      status: EventStatus.success,
      events: result.events,
      page: result.pageNumber,
      hasMore: result.hasMore,
    ));
  }
  Future<void> _onQueryChanged(
      EventQueryChanged event,
      Emitter<EventState> emit,
      ) async {
    emit(state.copyWith(
      status: EventStatus.loading,
      query: event.query,
      classification: "",
      page: 0,
      events: [],
      hasMore: true,
    ));

    final result = await _searchEvents(
      keyword: event.query,
      page: 0,
      classification: state.classification
    );

    emit(state.copyWith(
      status: EventStatus.success,
      events: result.events,
      page: result.pageNumber,
      hasMore: result.hasMore,
    ));
  }
  Future<void> _onClassificationChanged(
      EventClassificationChanged event,
      Emitter<EventState> emit,
      ) async {
    emit(state.copyWith(
      status: EventStatus.loading,
      classification: event.classification,
      query: "",
      page: 0,
      events: [],
      hasMore: true,
    ));

    final result = await _searchEvents(
      keyword: state.query,
      page: 0,
      classification: event.classification
    );

    emit(state.copyWith(
      status: EventStatus.success,
      events: result.events,
      page: result.pageNumber,
      hasMore: result.hasMore,
    ));
  }

  Future<void> _onLoadMore(
      EventLoadMoreRequested event,
      Emitter<EventState> emit,
      ) async {
    if (!state.hasMore || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.page + 1;

    final result = await _searchEvents(
      keyword: state.query,
      page: nextPage,
      classification: state.classification
    );

    emit(state.copyWith(
      events: [...state.events, ...result.events],
      page: result.pageNumber,
      hasMore: result.hasMore,
      isLoadingMore: false,
    ));
  }

  Future<void> _onLoadMoreByVenueId(
      EventLoadMoreByVenueIdRequested event,
      Emitter<EventState> emit,
      ) async {
    if (!state.hasMore || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.page + 1;

    final result = await _searchEventsByVenueId(
      venueId: event.venueId,
      page: nextPage,
    );

    emit(state.copyWith(
      events: [...state.events, ...result.events],
      page: result.pageNumber,
      hasMore: result.hasMore,
      isLoadingMore: false,
    ));
  }
}