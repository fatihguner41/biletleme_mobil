import 'package:json_annotation/json_annotation.dart';
import '../dto/event_dto.dart';

part 'event_response.g.dart';

@JsonSerializable()
class EventResponse {
  @JsonKey(name: '_embedded')
  final EmbeddedEvents embedded;

  EventResponse({required this.embedded});

  factory EventResponse.fromJson(Map<String, dynamic> json) =>
      _$EventResponseFromJson(json);
}

@JsonSerializable()
class EmbeddedEvents {
  final List<EventDto> events;

  EmbeddedEvents({required this.events});

  factory EmbeddedEvents.fromJson(Map<String, dynamic> json) =>
      _$EmbeddedEventsFromJson(json);
}
