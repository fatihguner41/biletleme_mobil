import 'package:ticketing/features/events/domain/entities/event.dart';

abstract class EventRepository {
  Future<List<Event>> getEvents();
}