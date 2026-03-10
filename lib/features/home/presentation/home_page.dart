import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/features/auth/presentation/auth_page.dart';
import 'package:ticketing/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ticketing/features/home/presentation/main_shell.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'TFFBilet',
            style: TextStyle(
              color: Colors.red.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return PopupMenuButton<String>(
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: "profile", child: Text("Profile")),
                    PopupMenuItem(value: "logout", child: Text("Logout")),
                  ],
                  onSelected: (value) {
                    if (value == "logout") {
                      context.read<AuthCubit>().signOut();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Logout successful")),
                      );
                    }
                    if (value == "profile") {
                      // Artık profile tab var, istersen burada MainShell'e geçiş yaptırabiliriz.
                      // Şimdilik boş bırakıyorum.
                    }
                  },
                );
              }

              if (state is AuthInitial || state is AuthLoading) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Center(
                    child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                );
              }

              // Unauthenticated
              return TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => BlocProvider.value(
                      value: context.read<AuthCubit>(),
                      child: const AuthPage(),
                    ),
                  );
                },
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.red.shade800),
                ),
              );
            },
          ),
        ],
      ),
      body: const MainShell(),
    );
  }
}