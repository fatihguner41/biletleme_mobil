import 'package:json_annotation/json_annotation.dart';
import '../../../../core/domain/entities/image_entity.dart';

part 'event_dto.g.dart';

@JsonSerializable(createToJson: false)
class EventDto {
  final String id;
  final String name;

  @JsonKey(fromJson: _eventTypeFromJson, name: 'classifications')
  final String eventType;

  @JsonKey(fromJson: _eventDateFromJson, name: 'dates')
  final String eventDate;

  @JsonKey(readValue: _readVenueId)
  final String? eventVenueId;

  @JsonKey(readValue: _readVenueName)
  final String? eventVenueName;

  @JsonKey(fromJson: _imageFromJson, name: 'images')
  final ImageEntity? image;

  EventDto({
    required this.id,
    required this.name,
    required this.eventType,
    required this.eventDate,
    this.eventVenueId,
    this.eventVenueName,
    this.image,
  });

  factory EventDto.fromJson(Map<String, dynamic> json) =>
      _$EventDtoFromJson(json);

  static String _eventTypeFromJson(dynamic json) {
    try {
      final classifications = json as List;
      if (classifications.isEmpty) return 'Unknown';
      return (classifications[0] as Map<String, dynamic>)['segment']['name'] as String;
    } catch (_) {
      return 'Unknown';
    }
  }

  static String _eventDateFromJson(dynamic json) {
    try {
      final dates = json as Map<String, dynamic>;
      final start = dates['start'] as Map<String, dynamic>?;

      final localDate = start?['localDate'] as String?;
      final localTime = start?['localTime'] as String?;

      if (localDate == null) return 'Unknown';
      if (localTime == null) return localDate;

      return '$localDate $localTime';
    } catch (_) {
      return 'Unknown';
    }
  }

// --- readValue helpers ---
  static Object? _readVenueId(Map json, String key) {
    try {
      final embedded = json['_embedded'] as Map<String, dynamic>?;
      final venues = embedded?['venues'] as List?;
      final first = (venues != null && venues.isNotEmpty) ? venues.first as Map : null;
      return first?['id'] as String?;
    } catch (_) {
      return null;
    }
  }

  static Object? _readVenueName(Map json, String key) {
    try {
      final embedded = json['_embedded'] as Map<String, dynamic>?;
      final venues = embedded?['venues'] as List?;
      final first = (venues != null && venues.isNotEmpty) ? venues.first as Map : null;
      return first?['name'] as String?;
    } catch (_) {
      return null;
    }
  }

  static ImageEntity? _imageFromJson(dynamic json) {
    try {
      final list = json as List;
      if (list.isEmpty) return null;

      final image = list.first as Map<String, dynamic>;
      return ImageEntity(
        ratio: image['ratio'] as String,
        url: image['url'] as String,
        width: image['width'] as int,
        height: image['height'] as int,
      );
    } catch (_) {
      return null;
    }
  }
}