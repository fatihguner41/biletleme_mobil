
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/domain/entities/image_entity.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/location.dart';

part 'venue_dto.g.dart';

@JsonSerializable(createToJson: false)
class VenueDto {
  final String name;
  final String id;
  final String locale;

  @JsonKey(fromJson: _cityFromJson)
  final String? city;

  @JsonKey(fromJson: _countryFromJson)
  final Country? country;

  @JsonKey(fromJson: _addressFromJson)
  final String? address;

  @JsonKey(fromJson: _locationFromJson)
  final Location? location;

  @JsonKey(fromJson: _imageFromJson, name: 'images')
  final ImageEntity? image;

  VenueDto({
    required this.name,
    required this.id,
    required this.locale,
    this.city,
    this.country,
    this.address,
    this.location,
    this.image,
  });

  factory VenueDto.fromJson(Map<String, dynamic> json) =>
      _$VenueDtoFromJson(json);

  static String? _cityFromJson(dynamic json) {
    try {
      final city = json as Map<String, dynamic>;
      return city['name'] as String;
    } catch (e) {
      return 'unknown';
    }
  }

  static Country? _countryFromJson(dynamic json) {
    try {
      final countryMap = json as Map<String, dynamic>;
      return Country(countryMap['name'] as String, countryMap['countryCode'] as String);
    } catch (e) {
      return null;
    }
  }

  static String? _addressFromJson(dynamic json) {
    try {
      final addressMap = json as Map<String, dynamic>;
      String address = '';
      for (String key in addressMap.keys) {
        address += '${json[key]!} ';
      }
      return address;
    } catch (e) {
      return 'unknown';
    }
  }

  static Location? _locationFromJson(dynamic json) {
    try {
      final locationMap = json as Map<String, dynamic>;
      return Location(locationMap['longitude'] as String, locationMap['latitude'] as String);
    } catch (e) {
      return null;
    }
  }

  static ImageEntity? _imageFromJson(dynamic json) {
    try {
      final jsonMap = json as List;
      final imageMap = jsonMap[0];
      final image = imageMap as Map<String,dynamic>;
      return ImageEntity(
        ratio: image['ratio'] as String,
        url: image['url'] as String,
        width: image['width'] as int,
        height: image['height'] as int,
      );
    } catch (e) {
      return null;
    }
  }
}
