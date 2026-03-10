import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ticketing/features/auth/presentation/auth_page.dart';

Future<bool> ensureLoggedIn(BuildContext context) async {
  final state = context.read<AuthCubit>().state;
  if (state is AuthAuthenticated) return true;

  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value: context.read<AuthCubit>(),
        child: const AuthPage(),
      ),
    ),
  );

  return context.read<AuthCubit>().state is AuthAuthenticated;
}