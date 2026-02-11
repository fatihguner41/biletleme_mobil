import 'package:ticketing/features/venues/domain/entities/venue.dart';
import 'package:ticketing/features/venues/domain/repositories/venue_repository.dart';

class GetVenuesUsecase {
  final VenueRepository repo;

  GetVenuesUsecase(this.repo);

  Future<List<Venue>> call() async{
    return await repo.getVenues();
  }
}