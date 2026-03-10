import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/core/di/service_locator.dart';
import 'package:ticketing/features/auth/presentation/cubit/auth_cubit.dart';
import 'auth_gate.dart';
import 'cubit/profile_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: AuthGate(
        title: 'Profile',
        message: 'Login or register to view your profile.',
        child: BlocProvider(
          create: (_) => sl<ProfileCubit>()..load(),
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading || state is ProfileInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ProfileError) {
                return Center(child: Text(state.message));
              }

              final payload = (state as ProfileLoaded).payload;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      const CircleAvatar(radius: 28, child: Icon(Icons.person)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Welcome', style: TextStyle(fontSize: 14)),
                            const SizedBox(height: 2),
                            Text(
                              payload.fullName,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.badge_outlined),
                          title: const Text('Name'),
                          subtitle: Text(payload.fullName),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.alternate_email),
                          title: const Text('Email'),
                          subtitle: Text(payload.email ?? '—'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout'),
                      onTap: () => context.read<AuthCubit>().signOut(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}