import 'package:dio/dio.dart';
import '../responses/event_response.dart';

class EventApiService {
  final Dio _dio;

  EventApiService(this._dio);

  Future<EventResponse> getEvents({
    required String apiKey,
    required String countryCode,
    required String classification,
    required int size,
  }) async {
    final response = await _dio.get(
      '/discovery/v2/events.json',
      queryParameters: {
        'apikey': apiKey,
        'countryCode': countryCode,
        'classificationName': classification,
        'size': size,
      },
    );

    return EventResponse.fromJson(response.data);
  }
}
