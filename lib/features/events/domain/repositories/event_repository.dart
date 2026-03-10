import 'package:ticketing/features/events/domain/usecases/event_list_page_model.dart';

abstract class EventRepository {
  Future<EventListPageModel> getEvents({
    required int page,
    required String classification,
    required String keyword,
  });
  Future<EventListPageModel> getEventsByVenueId({
    required int page,
    required String venueId,
  });
}