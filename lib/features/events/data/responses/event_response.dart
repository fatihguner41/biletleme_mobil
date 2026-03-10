import 'package:json_annotation/json_annotation.dart';

import '../../../venues/data/responses/venue_response.dart';
import '../dto/event_dto.dart';

part 'event_response.g.dart';

@JsonSerializable(createToJson: false)
class EventResponse {
  @JsonKey(name: '_embedded')
  final EmbeddedEvents? embedded;   // nullable yap

  final PageInfo page;

  EventResponse({
    required this.embedded,
    required this.page,
  });

  factory EventResponse.fromJson(Map<String, dynamic> json) =>
      _$EventResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class EmbeddedEvents {
  @JsonKey(defaultValue: [])
  final List<EventDto> events;   // defaultValue ekle

  EmbeddedEvents({required this.events});

  factory EmbeddedEvents.fromJson(Map<String, dynamic> json) =>
      _$EmbeddedEventsFromJson(json);
}