import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/features/venues/presentation/bloc/venue_state.dart';
import 'package:ticketing/features/venues/presentation/pages/venue_card.dart';
import 'package:ticketing/features/venues/presentation/pages/venue_detail_page.dart';
import '../bloc/venue_bloc.dart';

class VenuePage extends StatelessWidget {
  const VenuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VenueBloc, VenueState>(
      builder: (context, state) {
        if (state is VenueLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is VenueLoaded) {
          return ListView.builder(
            itemCount: state.venues.length,
            itemBuilder: (context, index) {
              final venue = state.venues[index];
              return VenueCard(
                venue: venue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VenueDetailPage(venue: venue),
                    ),
                  );
                },
              );
            },
          );
        }

        if (state is VenueError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }
}
