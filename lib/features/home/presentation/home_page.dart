import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/features/auth/presentation/auth_page.dart';
import 'package:ticketing/features/auth/presentation/cubit/auth_cubit.dart';
import '../../venues/presentation/pages/venue_page.dart';
import '../../venues/presentation/pages/venue_root.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          BlocBuilder<AuthCubit,AuthState>(
            builder: (context,state){
              if(state is AuthAuthenticated){
                return PopupMenuButton(itemBuilder: (context)=>[
                  const PopupMenuItem(
                      value: "profile",
                      child: Text("Profil")),
                  const PopupMenuItem(
                      value: "logout",
                      child: Text("Çıkış Yap")),

                ],
                onSelected: (value){
                  if(value == "logout") {
                    context.read<AuthCubit>().signOut();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Çıkış Yapıldı"))
                    );
                  }


                });
              }
              else if(state is AuthInitial){
                return CircularProgressIndicator();
              }

              return TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => const AuthPage(),
                  );
                },
                child: Text("Giriş Yap"),
              );
            },
          )

        ],
      ),
      body:  const VenueRoot(child: VenuePage())
    );
  }
}
