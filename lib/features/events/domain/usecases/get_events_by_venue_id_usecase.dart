import 'package:ticketing/features/events/domain/repositories/event_repository.dart';
import 'package:ticketing/features/events/domain/usecases/event_list_page_model.dart';

import '../entities/event.dart';

class GetEventsByVenueIdUsecase {
  final EventRepository _repo;

  GetEventsByVenueIdUsecase(this._repo);


  Future<EventListPageModel> call({required String venueId,required int page}){
    return _repo.getEventsByVenueId(venueId: venueId, page: page);

  }
}