import 'package:json_annotation/json_annotation.dart';
import '../dto/venue_dto.dart';

part 'venue_response.g.dart';

@JsonSerializable(createToJson: false)
class VenueResponse {
  @JsonKey(name: '_embedded')
  final EmbeddedVenues? embedded;

  final PageInfo page;

  VenueResponse({
    required this.embedded,
    required this.page,
  });

  factory VenueResponse.fromJson(Map<String, dynamic> json) =>
      _$VenueResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class EmbeddedVenues {
  @JsonKey(defaultValue: [])
  final List<VenueDto> venues;

  EmbeddedVenues({required this.venues});

  factory EmbeddedVenues.fromJson(Map<String, dynamic> json) =>
      _$EmbeddedVenuesFromJson(json);

}

@JsonSerializable(createToJson: false)
class PageInfo {
  final int size;
  final int totalElements;
  final int totalPages;
  final int number; // 0-based page index

  const PageInfo({
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.number,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) =>
      _$PageInfoFromJson(json);
}