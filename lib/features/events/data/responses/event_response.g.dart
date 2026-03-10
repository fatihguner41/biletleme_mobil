// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventResponse _$EventResponseFromJson(Map<String, dynamic> json) =>
    EventResponse(
      embedded: json['_embedded'] == null
          ? null
          : EmbeddedEvents.fromJson(json['_embedded'] as Map<String, dynamic>),
      page: PageInfo.fromJson(json['page'] as Map<String, dynamic>),
    );

EmbeddedEvents _$EmbeddedEventsFromJson(Map<String, dynamic> json) =>
    EmbeddedEvents(
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => EventDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
