import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/features/venues/presentation/bloc/search_venue/search_venue_event.dart';
import '../../../../core/di/service_locator.dart';
import '../bloc/search_venue/search_venue_bloc.dart';

class VenueRoot extends StatelessWidget {
  final Widget child;

  const VenueRoot({super.key, required this.child});

  @override
  Widget build(BuildContext context) {

      return BlocProvider(
        create: (_) => sl<SearchVenueBloc>()..add(VenueSearchQueryChanged("")),
        child: child,
      );

  }
}
