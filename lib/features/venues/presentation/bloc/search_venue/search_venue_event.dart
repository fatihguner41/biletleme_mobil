sealed class SearchVenueEvent {
  const SearchVenueEvent();
}

class VenueSearchQueryChanged extends SearchVenueEvent {
  final String query;
  const VenueSearchQueryChanged(this.query);
}

class VenueSearchLoadMoreRequested extends SearchVenueEvent {
  const VenueSearchLoadMoreRequested();
}