import 'package:json_annotation/json_annotation.dart';

part 'event_dto.g.dart';

@JsonSerializable()
class EventDto {
  final String id;
  final String name;

  @JsonKey(
      fromJson: _eventTypeFromJson,
      name: 'classifications')
  final String eventType;

  @JsonKey(
      fromJson: _eventDateFromJson,
      name: 'dates')
  final String eventDate;

  @JsonKey(
      fromJson: _eventVenueFromJson,
      name: '_embedded')
  final String eventVenueId;

  EventDto({
    required this.id,
    required this.name,
    required this.eventType,
    required this.eventDate,
    required this.eventVenueId,
  });

  factory EventDto.fromJson(Map<String, dynamic> json)
  => _$EventDtoFromJson(json);

  static String _eventTypeFromJson(dynamic json) {
    try {
      final classifications = json as List;
      if (classifications.isEmpty) return 'Unknown';

      return classifications[0]['segment']['name'] as String;
    } catch (_) {
      return 'Unknown';
    }
  }

  static String _eventDateFromJson(dynamic json) {
    try {
      final dates = json as Map<String,dynamic>;

      var localDate = dates['start']['localDate'] as String;
      var localTime = dates['start']['localTime'] as String;

      return '$localDate  $localTime';
    } catch (_) {
      return 'Unknown';
    }
  }
  static String _eventVenueFromJson(dynamic json) {
    try {
      final dates = json as Map<String,dynamic>;

       return dates['venues'][0]['id'];
    } catch (_) {
      return 'Unknown';
    }
  }
}
