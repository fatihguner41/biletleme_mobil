import 'package:ticketing/core/network/api_constants.dart';
import 'package:ticketing/features/events/data/mappers/event_dto_mapper.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../services/event_api_service.dart';

class EventRepositoryImpl extends EventRepository{
  final EventApiService _api;

  EventRepositoryImpl(this._api);

  @override
  Future<List<Event>> getEvents() async {
    final response = await _api.getEvents(
      apiKey: ApiConstants.apiKey,
      countryCode: 'US',
      classification: 'sport',
      size: 20,
    );

    return response.embedded.events.map(EventDtoMapper.toEntity).toList();
  }
}
