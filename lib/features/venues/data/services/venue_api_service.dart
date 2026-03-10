import 'package:dio/dio.dart';
import 'package:ticketing/core/network/api_constants.dart';
import '../dto/venue_dto.dart';
import '../responses/venue_response.dart';

class VenueApiService {
  final Dio _dio;

  VenueApiService(this._dio);

  Future<VenueResponse> searchVenues({
    required String keyword,
    required int page, // ✅ eklendi
  }) async {
    final response = await _dio.get(
      ApiConstants.venuesRoute,
      queryParameters: {
        'apikey': ApiConstants.apiKey,
        if (keyword.trim().isNotEmpty) 'keyword': keyword.trim(),
        'countryCode': ApiConstants.countryCode,
        'page': page, // ✅ eklendi (0-based)
      },
    );

    return VenueResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<VenueDto> getVenueById({
    required String apiKey,
    required String venueId,
  }) async {
    final response = await _dio.get(
      '/discovery/v2/venues/$venueId.json',
      queryParameters: {'apikey': apiKey},
    );

    return VenueDto.fromJson(response.data as Map<String, dynamic>);
  }
}