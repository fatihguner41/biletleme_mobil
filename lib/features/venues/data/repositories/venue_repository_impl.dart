import 'package:ticketing/core/network/api_constants.dart';
import 'package:ticketing/features/venues/data/mappers/venue_dto_mapper.dart';
import 'package:ticketing/features/venues/data/services/venue_api_service.dart';
import 'package:ticketing/features/venues/domain/entities/venue.dart';
import 'package:ticketing/features/venues/domain/repositories/venue_repository.dart';

class VenueRepositoryImpl extends VenueRepository {
  final VenueApiService _api;

  VenueRepositoryImpl(this._api);

  @override
  Future<List<Venue>> getVenues() async {
    final result = await _api.getEvents(
      apiKey: ApiConstants.apiKey,
      countryCode: 'US',
      size: 50,
    );
    return result.embedded.venues.map(VenueDtoMapper.toEntity).toList();
  }
}
