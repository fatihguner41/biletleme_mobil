import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../bloc/venue_bloc.dart';
import '../bloc/venue_event.dart';

class VenueRoot extends StatelessWidget {
  final Widget child;

  const VenueRoot({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VenueBloc>()..add(FetchVenues()),
      child: child,
    );
  }

}
