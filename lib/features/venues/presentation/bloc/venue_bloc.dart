import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/features/venues/data/services/venue_cache.dart';
import 'package:ticketing/features/venues/domain/usecases/get_venues_usecase.dart';
import 'package:ticketing/features/venues/presentation/bloc/venue_event.dart';
import 'package:ticketing/features/venues/presentation/bloc/venue_state.dart';

class VenueBloc extends Bloc<VenueEvent, VenueState>{
  final GetVenuesUsecase getVenuesUsecase;
  final VenueCache venueCache;
  VenueBloc(this.getVenuesUsecase,this.venueCache):super(VenueInitial()){
    on<FetchVenues>(_onFetchVenues);
  }

  Future<void> _onFetchVenues(FetchVenues e, Emitter<VenueState> emit) async{
    emit(VenueLoading());
    try{
      final venues= await getVenuesUsecase();
      venueCache.setAll(venues);
      emit(VenueLoaded(venues));
    }catch(e){
      emit(VenueError('Venue loading failed.'));
    }
  }
}