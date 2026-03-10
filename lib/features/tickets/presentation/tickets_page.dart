import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/core/di/service_locator.dart';
import '../../auth/presentation/auth_gate.dart';
import 'cubit/tickets_cubit.dart';
import 'cubit/tickets_state.dart';
import 'ticket_detail_page.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tickets')),
      body: AuthGate(
        title: 'Tickets are private',
        message: 'Login or register to view your tickets.',
        child: BlocProvider(
          create: (_) => sl<TicketsCubit>()..load(),
          child: BlocBuilder<TicketsCubit, TicketsState>(
            builder: (context, state) {
              if (state.status == TicketsStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == TicketsStatus.failure) {
                return Center(child: Text(state.errorMessage ?? 'Error'));
              }

              if (state.tickets.isEmpty) {
                return const Center(child: Text('No tickets yet'));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.tickets.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final t = state.tickets[i];

                  return Card(
                    child: ListTile(
                      title: Text(t.eventName,style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold
                      ),),
                      subtitle: Text(
                        'Ticket: ${t.id}\nCreated: ${t.createdAt}',
                      ),
                      isThreeLine: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TicketDetailPage(ticket: t),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}