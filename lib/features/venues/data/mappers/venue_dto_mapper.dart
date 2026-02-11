import 'package:ticketing/features/venues/data/dto/venue_dto.dart';
import 'package:ticketing/features/venues/domain/entities/venue.dart';

class VenueDtoMapper {
  static Venue toEntity(VenueDto dto) {
    return Venue(
      name: dto.name,
      id: dto.id,
      locale: dto.locale,
      city: dto.city,
      country: dto.country,
      address: dto.address,
      location: dto.location,
      image: dto.image,
    );
  }
}
