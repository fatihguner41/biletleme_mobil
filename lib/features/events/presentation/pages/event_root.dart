
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/features/events/presentation/bloc/event_event.dart';

import '../../../../core/di/service_locator.dart';
import '../bloc/event_bloc.dart';

class EventsRoot extends StatelessWidget {
  final Widget child;

  const EventsRoot({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EventBloc>()..add(EventQueryChanged("")),
      child: child,
    );
  }
}
