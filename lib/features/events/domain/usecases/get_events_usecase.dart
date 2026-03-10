import 'package:ticketing/features/events/domain/entities/event.dart';
import 'package:ticketing/features/events/domain/repositories/event_repository.dart';
import 'package:ticketing/features/events/domain/usecases/event_list_page_model.dart';

class GetEventsUsecase {
  final EventRepository repository;

  GetEventsUsecase(this.repository);

  Future<EventListPageModel> call({required String keyword,required int page, required String classification}){
    return repository.getEvents(keyword: keyword, page: page, classification: classification);

  }
}