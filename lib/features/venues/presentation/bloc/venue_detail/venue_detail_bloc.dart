import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/features/venues/presentation/bloc/venue_detail/venue_detail_event.dart';
import 'package:ticketing/features/venues/presentation/bloc/venue_detail/venue_detail_state.dart';

import '../../../domain/usecases/get_venue_by_id_usecase.dart';

class VenueDetailBloc extends Bloc<VenueDetailEvent, VenueDetailState> {
  final GetVenueByIdUseCase _getVenueById;

  VenueDetailBloc(this._getVenueById) : super(VenueDetailState.initial()) {
    on<VenueDetailStarted>(_onStarted);
  }

  Future<void> _onStarted(
      VenueDetailStarted event,
      Emitter<VenueDetailState> emit,
      ) async {
    // 1) cache/initial varsa hemen göster
    if (event.initialVenue != null) {
      emit(state.copyWith(status: VenueDetailStatus.success, venue: event.initialVenue, errorMessage: null));
    }

    // 2) venueId yoksa iş biter (sadece initial ile açılmıştır)
    final id = event.venueId;
    if (id == null || id.isEmpty) return;

    // 3) venueId varsa: fetch
    // Eğer initial vardıysa "refreshing" gibi davranmak için loading’e çekiyoruz ama venue’yu koruyoruz.
    emit(state.copyWith(status: VenueDetailStatus.loading, errorMessage: null));

    try {
      final venue = await _getVenueById(id);
      emit(state.copyWith(status: VenueDetailStatus.success, venue: venue, errorMessage: null));
    } catch (e) {
      // initial venue varsa ekranda kalır; sadece hata mesajı gösterirsin
      emit(state.copyWith(status: VenueDetailStatus.failure, errorMessage: e.toString()));
    }
  }
}