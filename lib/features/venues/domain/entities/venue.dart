import 'package:ticketing/core/domain/entities/image_entity.dart';

import 'country.dart';
import 'location.dart';

class Venue {
  final String name;
  final String id;
  final String locale;
  final String? city;
  final Country? country;
  final String? address;
  final Location? location;
  final ImageEntity? image;

  Venue({required this.name,required this.id,required this.locale, this.city, this.country, this.address,
this.location, this.image});


}