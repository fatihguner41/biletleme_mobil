import '../../../domain/entities/venue.dart';

enum VenueDetailStatus { loading, success, failure }

class VenueDetailState {
  final VenueDetailStatus status;
  final Venue? venue;
  final String? errorMessage;

  const VenueDetailState({
    required this.status,
    required this.venue,
    required this.errorMessage,
  });

  factory VenueDetailState.initial() =>
      const VenueDetailState(status: VenueDetailStatus.loading, venue: null, errorMessage: null);

  VenueDetailState copyWith({
    VenueDetailStatus? status,
    Venue? venue,
    String? errorMessage,
  }) {
    return VenueDetailState(
      status: status ?? this.status,
      venue: venue ?? this.venue,
      errorMessage: errorMessage,
    );
  }
}