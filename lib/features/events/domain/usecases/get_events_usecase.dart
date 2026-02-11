import 'package:ticketing/features/events/domain/entities/event.dart';
import 'package:ticketing/features/events/domain/repositories/event_repository.dart';

class GetEventsUsecase {
  final EventRepository repository;

  GetEventsUsecase(this.repository);

  Future<List<Event>> call(){
    return repository.getEvents();
  }
}