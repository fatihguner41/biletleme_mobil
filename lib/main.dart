
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/features/auth/presentation/auth_page.dart';
import 'package:ticketing/features/auth/presentation/cubit/auth_cubit.dart';
import 'core/di/service_locator.dart';
import 'features/home/presentation/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_)=> sl<AuthCubit>()..appStarted(),
      child: MaterialApp(
        title: 'TFFBilet',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(

          //colorScheme: .fromSeed(seedColor: Colors.white),
          cardTheme: CardThemeData(shadowColor: Colors.yellowAccent,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color:Colors.blueAccent,width: 2,strokeAlign: BorderSide.strokeAlignOutside)))

        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.dark(inversePrimary: Colors.indigo)
        ),
        home:  const HomePage(),
        routes: {
          '/home': (_) => const HomePage(),
          '/login': (_) => const AuthPage(),
        },
      ),
    );
  }
}
