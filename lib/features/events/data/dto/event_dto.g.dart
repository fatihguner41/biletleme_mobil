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
      eventVenueId: EventDto._eventVenueFromJson(json['_embedded']),
    );

Map<String, dynamic> _$EventDtoToJson(EventDto instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'classifications': instance.eventType,
      'dates': instance.eventDate,
      '_embedded': instance.eventVenueId,
    };
