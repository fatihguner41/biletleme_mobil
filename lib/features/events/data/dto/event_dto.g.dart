// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventDto _$EventDtoFromJson(Map<String, dynamic> json) => EventDto(
      id: json['id'] as String,
      name: json['name'] as String,
      eventType: EventDto._eventTypeFromJson(json['classifications']),
      eventDate: EventDto._eventDateFromJson(json['dates']),
      eventVenueId: EventDto._readVenueId(json, 'eventVenueId') as String?,
      eventVenueName:
          EventDto._readVenueName(json, 'eventVenueName') as String?,
      image: EventDto._imageFromJson(json['images']),
    );
