sealed class EventEvent {
  const EventEvent();
}

class EventQueryChanged extends EventEvent {
  final String query;
  const EventQueryChanged(this.query);
}
class EventClassificationChanged extends EventEvent {
  final String classification;
  const EventClassificationChanged(this.classification);
}

class EventLoadMoreRequested extends EventEvent {
  const EventLoadMoreRequested();
}
class EventLoadMoreByVenueIdRequested extends EventEvent {
  final String venueId;
  const EventLoadMoreByVenueIdRequested(this.venueId);
}
class VenuePageOpened extends EventEvent {
  final String venueId;
  const VenuePageOpened(this.venueId);
}