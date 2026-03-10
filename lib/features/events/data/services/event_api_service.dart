import 'package:dio/dio.dart';
import 'package:ticketing/core/network/api_constants.dart';
import '../responses/event_response.dart';

class EventApiService {
  final Dio _dio;

  EventApiService(this._dio);

  Future<EventResponse> getEvents({
    required String keyword,
    required String classification,
    required int page,
  }) async {
    final response = await _dio.get(
      ApiConstants.eventsRoute,
      queryParameters: {
        'apikey': ApiConstants.apiKey,
        'countryCode': ApiConstants.countryCode,
        'size': ApiConstants.size,
        'classificationName': classification,
        'keyword': keyword,
        'page': page,
      },
    );

    return EventResponse.fromJson(response.data);
  }

  Future<EventResponse> getEventsByVenueId({
    required String venueId,
    required int page,
  }) async {
    final response = await _dio.get(
      ApiConstants.eventsRoute,
      queryParameters: {
        'apikey': ApiConstants.apiKey,
        'countryCode': ApiConstants.countryCode,
        'size': ApiConstants.size,
        'venueId': venueId,
        'page': page,
      },
    );

    return EventResponse.fromJson(response.data);
  }
}
