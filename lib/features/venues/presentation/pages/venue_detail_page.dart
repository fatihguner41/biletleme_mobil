import 'package:flutter/material.dart';

import '../../domain/entities/venue.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class VenueDetailPage extends StatelessWidget {
  final Venue venue;

  late final lat = double.tryParse(venue.location?.latitude ?? '');
  late final lng = double.tryParse(venue.location?.longitude ?? '');
  VenueDetailPage({super.key, required this.venue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildContent(context)),
        ],
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
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
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

          const SizedBox(height: 12),

          _infoRow(
            Icons.map,
            venue.location != null
                ? 'Lat: ${venue.location!.latitude}, '
                      'Lng: ${venue.location!.longitude}'
                : 'Location not available',
          ),

          const SizedBox(height: 24),

          const Divider(),

          const SizedBox(height: 12),

          Text("Venue ID", style: Theme.of(context).textTheme.labelMedium),
          Text(venue.id, style: Theme.of(context).textTheme.bodyMedium),

          if (lat != null && lng != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildMap(lat!, lng!),
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
          options: MapOptions(initialCenter: LatLng(lat, lng), initialZoom: 15),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.yourapp.ticketing',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(lat, lng),
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_pin,
                    size: 40,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
