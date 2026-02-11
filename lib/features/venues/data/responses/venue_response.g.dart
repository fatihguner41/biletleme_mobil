// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueResponse _$VenueResponseFromJson(Map<String, dynamic> json) =>
    VenueResponse(
      embedded:
          EmbeddedVenues.fromJson(json['_embedded'] as Map<String, dynamic>),
    );

EmbeddedVenues _$EmbeddedVenuesFromJson(Map<String, dynamic> json) =>
    EmbeddedVenues(
      venues: (json['venues'] as List<dynamic>)
          .map((e) => VenueDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
