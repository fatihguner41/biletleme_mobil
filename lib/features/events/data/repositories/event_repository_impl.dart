import 'package:ticketing/core/network/api_constants.dart';
import 'package:ticketing/features/events/data/mappers/event_dto_mapper.dart';
import 'package:ticketing/features/events/domain/usecases/event_list_page_model.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../services/event_api_service.dart';

class EventRepositoryImpl extends EventRepository{
  final EventApiService _api;

  EventRepositoryImpl(this._api);

  @override
  Future<EventListPageModel> getEvents({required String keyword,required int page, required String classification}) async {
    final response = await _api.getEvents(
      page: page,
      keyword: keyword,
      classification: classification,
    );
    final responseDto = response.embedded?.events ?? const [];
    final events = responseDto.map(EventDtoMapper.toEntity).toList();


    return EventListPageModel(events: events
        , pageNumber: response.page.number,
        totalPages: response.page.totalPages,
        totalElements: response.page.totalElements,
        pageSize: response.page.size);
  }
  @override
  Future<EventListPageModel> getEventsByVenueId({required String venueId,required int page}) async {
    final response = await _api.getEventsByVenueId(
      page: page,
      venueId: venueId,
    );
    final responseDto = response.embedded?.events ?? const [];
    final events = responseDto.map(EventDtoMapper.toEntity).toList();


    return EventListPageModel(events: events
        , pageNumber: response.page.number,
        totalPages: response.page.totalPages,
        totalElements: response.page.totalElements,
        pageSize: response.page.size);
  }
}
