import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../tickets/presentation/fake_payment_page.dart';
import '../../../tickets/presentation/cubit/ticket_purchase_cubit.dart';
import '../../../tickets/presentation/cubit/ticket_purchase_state.dart';
import '../../../venues/presentation/pages/venue_detail_page.dart';
import '../../domain/entities/event.dart';

class EventDetailPage extends StatelessWidget {
  final Event event;

  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TicketPurchaseCubit>(),
      child: BlocConsumer<TicketPurchaseCubit, TicketPurchaseState>(
        listener: (context, state) {
          if (state is TicketPurchaseSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Ticket created!')),
              );
          } else if (state is TicketPurchaseFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.message)),
              );
          }
        },
        builder: (context, state) {
          final purchasing = state is TicketPurchaseLoading;

          return Scaffold(
            appBar: AppBar(title: Text(event.name)),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImage(),
                  const SizedBox(height: 16),
                  _buildSectionTitle("Event Info"),
                  _buildInfoTile("Name", event.name),
                  if (event.date != null) _buildInfoTile("Date", event.date!),
                  if (event.eventType != null) _buildInfoTile("Type", event.eventType!),
                  if (event.venue != null) _buildInfoTile("Venue", event.venue!),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Venue Info"),
                  if (event.eventVenueId != null && event.eventVenueName != null)
                    _buildVenueMiniCard(context),
                  const SizedBox(height: 24),
                  _buyTicketButton(context, purchasing),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buyTicketButton(BuildContext context, bool purchasing) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade300,
          shadowColor: Colors.red.shade800,
          elevation: 1,
        ),
        onPressed: purchasing
            ? null
            : () async {
          final paid = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => FakePaymentPage(
                eventId: event.id,
                eventName: event.name,
              ),
            ),
          );

          if (paid == true && context.mounted) {
            context.read<TicketPurchaseCubit>().purchase(
              event.id,
              event.name
            );
          }
        },
        child: purchasing
            ? const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
            : const Text('Buy Ticket', style: TextStyle(color: Colors.black)),
      ),
    );
  }

  Widget _buildImage() {
    if (event.imageUrl == null || event.imageUrl!.isEmpty) {
      return Container(
        height: 220,
        color: Colors.grey.shade300,
        alignment: Alignment.center,
        child: const Icon(
          Icons.image_not_supported,
          size: 64,
          color: Colors.grey,
        ),
      );
    }

    return Image.network(
      event.imageUrl!,
      height: 220,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          height: 220,
          color: Colors.grey.shade300,
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image, size: 64, color: Colors.grey),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildVenueMiniCard(BuildContext context) {
    final id = event.eventVenueId;
    final name = event.eventVenueName;

    if (id == null || id.isEmpty || name == null || name.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => VenueDetailPage(venueId: id)),
          );
        },
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Venue",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(name, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}