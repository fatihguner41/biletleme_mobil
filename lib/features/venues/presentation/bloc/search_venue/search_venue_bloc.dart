import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/features/venues/domain/usecases/search_venues_usecase.dart';
import 'package:ticketing/features/venues/presentation/bloc/search_venue/search_venue_event.dart';
import 'package:ticketing/features/venues/presentation/bloc/search_venue/search_venue_state.dart';

class SearchVenueBloc extends Bloc<SearchVenueEvent, SearchVenueState> {
  final SearchVenuesUsecase _searchVenues;


  SearchVenueBloc(this._searchVenues)
      : super(SearchVenueState.initial()) {
    on<VenueSearchQueryChanged>(_onQueryChanged);
    on<VenueSearchLoadMoreRequested>(_onLoadMore);
  }

  Future<void> _onQueryChanged(
      VenueSearchQueryChanged event,
      Emitter<SearchVenueState> emit,
      ) async {
    emit(state.copyWith(
      status: SearchVenueStatus.loading,
      query: event.query,
      page: 0,
      venues: [],
      hasMore: true,
    ));

    final result = await _searchVenues(
      keyword: event.query,
      page: 0,
    );

    emit(state.copyWith(
      status: SearchVenueStatus.success,
      venues: result.venues,
      page: result.pageNumber,
      hasMore: result.hasMore,
    ));
  }

  Future<void> _onLoadMore(
      VenueSearchLoadMoreRequested event,
      Emitter<SearchVenueState> emit,
      ) async {
    if (!state.hasMore || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.page + 1;

    final result = await _searchVenues(
      keyword: state.query,
      page: nextPage,
    );

    emit(state.copyWith(
      venues: [...state.venues, ...result.venues],
      page: result.pageNumber,
      hasMore: result.hasMore,
      isLoadingMore: false,
    ));
  }
}