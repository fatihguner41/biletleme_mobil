import '../../../domain/entities/venue.dart';

enum SearchVenueStatus { initial, loading, success, failure }

class SearchVenueState {
  final SearchVenueStatus status;
  final List<Venue> venues;
  final String query;

  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  final String? errorMessage;

  const SearchVenueState({
    required this.status,
    required this.venues,
    required this.query,
    required this.page,
    required this.hasMore,
    required this.isLoadingMore,
    required this.errorMessage,
  });

  factory SearchVenueState.initial() => const SearchVenueState(
    status: SearchVenueStatus.initial,
    venues: [],
    query: "",
    page: 0,
    hasMore: true,
    isLoadingMore: false,
    errorMessage: null,
  );

  SearchVenueState copyWith({
    SearchVenueStatus? status,
    List<Venue>? venues,
    String? query,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return SearchVenueState(
      status: status ?? this.status,
      venues: venues ?? this.venues,
      query: query ?? this.query,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
    );
  }
}