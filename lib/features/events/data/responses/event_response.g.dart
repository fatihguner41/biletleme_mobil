// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventResponse _$EventResponseFromJson(Map<String, dynamic> json) =>
    EventResponse(
      embedded:
          EmbeddedEvents.fromJson(json['_embedded'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EventResponseToJson(EventResponse instance) =>
    <String, dynamic>{
      '_embedded': instance.embedded,
    };

EmbeddedEvents _$EmbeddedEventsFromJson(Map<String, dynamic> json) =>
    EmbeddedEvents(
      events: (json['events'] as List<dynamic>)
          .map((e) => EventDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EmbeddedEventsToJson(EmbeddedEvents instance) =>
    <String, dynamic>{
      'events': instance.events,
    };
