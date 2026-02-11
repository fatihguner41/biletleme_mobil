import 'package:flutter/material.dart';
import '../../domain/entities/venue.dart';

class VenueCard extends StatelessWidget {
  final Venue venue;
  final VoidCallback? onTap;

  const VenueCard({
    super.key,
    required this.venue,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            _VenueImage(imageUrl: venue.image?.url),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _VenueInfo(venue: venue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VenueImage extends StatelessWidget {
  final String? imageUrl;

  const _VenueImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      color: Colors.grey.shade200,
      child: imageUrl != null
          ? Image.network(imageUrl!, fit: BoxFit.fill)
          : const Icon(Icons.location_on, size: 40),
    );
  }
}

class _VenueInfo extends StatelessWidget {
  final Venue venue;

  const _VenueInfo({required this.venue});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          venue.name,
          style: Theme.of(context).textTheme.titleMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        if (venue.city != null)
          Text(
            venue.city!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        if (venue.country != null)
          Text(
            venue.country!.name,
            style: Theme.of(context).textTheme.bodySmall,
          ),
      ],
    );
  }
}
