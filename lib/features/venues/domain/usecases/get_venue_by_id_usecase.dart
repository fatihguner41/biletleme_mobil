import '../entities/venue.dart';
import '../repositories/venue_repository.dart';

class GetVenueByIdUseCase {
  final VenueRepository _repo;
  GetVenueByIdUseCase(this._repo);

  Future<Venue> call(String id) => _repo.getVenueById(id);
}