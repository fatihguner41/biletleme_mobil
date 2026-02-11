import 'package:dio/dio.dart';
import '../responses/venue_response.dart';

class VenueApiService {
  final Dio _dio;

  VenueApiService(this._dio);

  Future<VenueResponse> getEvents({
    required String apiKey,
    required String countryCode,
    required int size,
  }) async {
    final response = await _dio.get(
      '/discovery/v2/venues.json',
      queryParameters: {
        'apikey': apiKey,
        'countryCode': countryCode,
        'size': size,
      },
    );

    return VenueResponse.fromJson(response.data);
  }
}
