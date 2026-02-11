import '../entities/venue.dart';

abstract class VenueRepository {
  Future<List<Venue>> getVenues();
}