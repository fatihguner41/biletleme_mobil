import 'package:ticketing/core/network/api_constants.dart';
import 'package:ticketing/features/venues/data/mappers/venue_dto_mapper.dart';
import 'package:ticketing/features/venues/data/services/venue_api_service.dart';
import 'package:ticketing/features/venues/domain/entities/venue.dart';
import 'package:ticketing/features/venues/domain/repositories/venue_repository.dart';

import '../../domain/usecases/venue_search_page_model.dart';

class VenueRepositoryImpl extends VenueRepository {
  final VenueApiService _api;

  VenueRepositoryImpl(this._api);

  @override
  Future<VenueSearchPage> searchVenues({
    required String keyword,
    required int page,
  }) async {
    final result = await _api.searchVenues(
      keyword: keyword,
      page: page,
    );

    final venuesDto = result.embedded?.venues ?? const [];
    final venues = venuesDto.map(VenueDtoMapper.toEntity).toList();

    return VenueSearchPage(
      venues: venues,
      pageNumber: result.page.number,
      totalPages: result.page.totalPages,
      totalElements: result.page.totalElements,
      pageSize: result.page.size,
    );
  }

  @override
  Future<Venue> getVenueById(String id) async {
    final dto = await _api.getVenueById(
      apiKey: ApiConstants.apiKey,
      venueId: id,
    );
    return VenueDtoMapper.toEntity(dto);
  }
}