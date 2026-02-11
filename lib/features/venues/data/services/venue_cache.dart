import '../../domain/entities/venue.dart';

class VenueCache {
  final Map<String, Venue> _venues = {};

  void setAll(List<Venue> venues) {
    for (final venue in venues) {
      _venues[venue.id] = venue;
    }
  }

  Venue? getById(String id) {
    return _venues[id];
  }

  bool get isEmpty => _venues.isEmpty;
}
