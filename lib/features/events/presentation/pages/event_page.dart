import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/event_bloc.dart';
import '../bloc/event_state.dart';
import 'event_card.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        if (state is EventLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is EventLoaded) {
          return ListView.builder(
            itemCount: state.events.length,
            itemBuilder: (context, index) {
              final event = state.events[index];
              return EventCard(
                event: event,
                onTap: (){
                  print(event.name);
                },
              );
            },
          );
        }

        if (state is EventError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }
}
