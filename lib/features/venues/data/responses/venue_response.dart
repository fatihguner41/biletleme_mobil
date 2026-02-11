import 'package:json_annotation/json_annotation.dart';

import '../dto/venue_dto.dart';

part 'venue_response.g.dart';

@JsonSerializable(createToJson: false)
class VenueResponse {
  @JsonKey(name: '_embedded')
  final EmbeddedVenues embedded;

  VenueResponse({required this.embedded});

  factory VenueResponse.fromJson(Map<String, dynamic> json) =>
      _$VenueResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class EmbeddedVenues {
  final List<VenueDto> venues;

  EmbeddedVenues({required this.venues});

  factory EmbeddedVenues.fromJson(Map<String, dynamic> json) =>
      _$EmbeddedVenuesFromJson(json);
}
