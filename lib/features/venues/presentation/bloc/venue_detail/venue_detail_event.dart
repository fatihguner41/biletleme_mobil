import '../../../domain/entities/venue.dart';

sealed class VenueDetailEvent {
  const VenueDetailEvent();
}

class VenueDetailStarted extends VenueDetailEvent {
  final String? venueId;
  final Venue? initialVenue;

  const VenueDetailStarted({
    required this.venueId,
    required this.initialVenue,
  });
}