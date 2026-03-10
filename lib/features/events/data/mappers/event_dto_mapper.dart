import '../../domain/entities/event.dart';
import '../dto/event_dto.dart';

class EventDtoMapper {
  static Event toEntity(EventDto dto) {
    return Event(
      id: dto.id,
      name: dto.name,
      eventType: dto.eventType,
      date: dto.eventDate,
      eventVenueId: dto.eventVenueId,
      eventVenueName: dto.eventVenueName,
      imageUrl: dto.image?.url,
    );
  }
}
