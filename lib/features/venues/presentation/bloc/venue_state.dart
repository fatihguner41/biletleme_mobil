import '../../domain/entities/venue.dart';

class VenueState {}

class VenueInitial extends VenueState {}

class VenueLoading extends VenueState {}

class VenueLoaded extends VenueState {
  final List<Venue> venues;

  VenueLoaded(this.venues);
}

class VenueError extends VenueState{
  final String message;

  VenueError(this.message);
}
