// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueResponse _$VenueResponseFromJson(Map<String, dynamic> json) =>
    VenueResponse(
      embedded: json['_embedded'] == null
          ? null
          : EmbeddedVenues.fromJson(json['_embedded'] as Map<String, dynamic>),
      page: PageInfo.fromJson(json['page'] as Map<String, dynamic>),
    );

EmbeddedVenues _$EmbeddedVenuesFromJson(Map<String, dynamic> json) =>
    EmbeddedVenues(
      venues: (json['venues'] as List<dynamic>?)
              ?.map((e) => VenueDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

PageInfo _$PageInfoFromJson(Map<String, dynamic> json) => PageInfo(
      size: (json['size'] as num).toInt(),
      totalElements: (json['totalElements'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      number: (json['number'] as num).toInt(),
    );
