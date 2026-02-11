// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueDto _$VenueDtoFromJson(Map<String, dynamic> json) => VenueDto(
      name: json['name'] as String,
      id: json['id'] as String,
      locale: json['locale'] as String,
      city: VenueDto._cityFromJson(json['city']),
      country: VenueDto._countryFromJson(json['country']),
      address: VenueDto._addressFromJson(json['address']),
      location: VenueDto._locationFromJson(json['location']),
      image: VenueDto._imageFromJson(json['images']),
    );
