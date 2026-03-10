import 'package:ticketing/features/venues/domain/entities/venue.dart';
import 'package:ticketing/features/venues/domain/repositories/venue_repository.dart';
import 'package:ticketing/features/venues/domain/usecases/venue_search_page_model.dart';

class SearchVenuesUsecase {
  final VenueRepository repo;
  SearchVenuesUsecase(this.repo);

  Future<VenueSearchPage> call({required keyword,required int page}) async {

      return await repo.searchVenues(keyword: keyword,page: page);

  }
}