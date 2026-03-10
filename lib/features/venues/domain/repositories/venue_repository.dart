import '../../data/dto/venue_dto.dart';
import '../entities/venue.dart';
import '../usecases/venue_search_page_model.dart';

abstract class VenueRepository {
  Future<VenueSearchPage> searchVenues({
    required String keyword,
    required int page
  });

  Future<Venue> getVenueById(String id);

}