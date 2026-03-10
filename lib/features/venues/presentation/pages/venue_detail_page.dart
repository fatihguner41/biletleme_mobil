import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:ticketing/features/events/presentation/pages/event_page.dart';
import 'package:ticketing/features/events/presentation/pages/events_embedded_page.dart';

import '../../../../core/di/service_locator.dart';
import '../../../events/presentation/bloc/event_bloc.dart';
import '../../../events/presentation/bloc/event_event.dart';
import '../../../events/presentation/bloc/event_state.dart';
import '../../../events/presentation/pages/event_card.dart';
import '../../../events/presentation/pages/event_detail_page.dart';
import '../../domain/entities/venue.dart';
import '../bloc/venue_detail/venue_detail_bloc.dart';
import '../bloc/venue_detail/venue_detail_event.dart';
import '../bloc/venue_detail/venue_detail_state.dart';

class VenueDetailPage extends StatelessWidget {
  final Venue? venue;
  final String? venueId;

  const VenueDetailPage({
    super.key,
    this.venue,
    this.venueId,
  }) : assert(
  (venue != null) ^ (venueId != null),
  'Either venue or venueId must be provided (but not both).',
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VenueDetailBloc>()
        ..add(
          VenueDetailStarted(
            venueId: venueId,
            initialVenue: venue,
          ),
        ),
      child: BlocBuilder<VenueDetailBloc, VenueDetailState>(
        builder: (context, state) {
          final currentVenue = state.venue;

          // İlk açılış: hiç venue yok + loading
          if (currentVenue == null && state.status == VenueDetailStatus.loading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Hata ve elimizde hiç veri yok
          if (currentVenue == null && state.status == VenueDetailStatus.failure) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(child: Text(state.errorMessage ?? "Error")),
            );
          }

          // Elimizde venue var: UI’yı bas
          return _VenueDetailScaffold(
            venue: currentVenue!,
            isRefreshing: state.status == VenueDetailStatus.loading && venue != null,
            errorMessage: state.status == VenueDetailStatus.failure ? state.errorMessage : null,
          );
        },
      ),
    );
  }
}


class _VenueDetailScaffold extends StatelessWidget {
  final Venue venue;
  final bool isRefreshing;
  final String? errorMessage;

  const _VenueDetailScaffold({
    required this.venue,
    required this.isRefreshing,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final lat = double.tryParse(venue.location?.latitude ?? '');
    final lng = double.tryParse(venue.location?.longitude ?? '');

    return BlocProvider(
      create: (_) => sl<EventBloc>()
        ..add(
          VenuePageOpened(venue.id),
        ),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: _buildContent(context, lat, lng),
            ),
            SliverToBoxAdapter(
               child: EventsEmbeddedPage(venueId: venue.id),
            )
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (venue.image?.url != null)
              Image.network(venue.image!.url, fit: BoxFit.fill)
            else
              const Icon(Icons.location_on),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black38],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            if (isRefreshing)
              const Positioned(
                right: 12,
                top: 36,
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, double? lat, double? lng) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(venue.name, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),

          _infoRow(
            Icons.location_city,
            '${venue.city ?? ''}, ${venue.country?.name ?? ''}',
          ),
          const SizedBox(height: 12),
          _infoRow(Icons.home, venue.address ?? 'Address not available'),

          if (errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(errorMessage!, style: const TextStyle(color: Colors.red)),
          ],

          const SizedBox(height: 24),
          const Divider(),

          if (lat != null && lng != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildMap(lat, lng),
            ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }

  Widget _buildMap(double lat, double lng) {
    return SizedBox(
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FlutterMap(
          options: MapOptions(initialCenter: LatLng(lat, lng), initialZoom: 12),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.netas.arge.ticketing',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(lat, lng),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin, size: 40, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}