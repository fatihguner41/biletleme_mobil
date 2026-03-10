import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/features/auth/presentation/auth_page.dart';
import 'package:ticketing/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ticketing/features/events/presentation/bloc/event_bloc.dart';
import 'package:ticketing/features/home/presentation/main_shell.dart';
import 'package:ticketing/features/venues/presentation/bloc/search_venue/search_venue_bloc.dart';
import 'core/di/service_locator.dart';
import 'core/fake_backend/fake_db.dart';
import 'features/auth/presentation/cubit/profile_cubit.dart';
import 'features/events/presentation/bloc/event_event.dart';
import 'features/home/presentation/home_page.dart';
import 'features/venues/presentation/bloc/search_venue/search_venue_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await sl<FakeDb>().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthCubit>()..appStarted()),
        BlocProvider(
          create: (_) =>
              sl<SearchVenueBloc>()..add(VenueSearchQueryChanged("")),
        ),
        BlocProvider(
          create: (_) => sl<EventBloc>()..add(EventQueryChanged("")),
        ),
      ],
      child: MaterialApp(
        title: 'TFFBilet',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          //colorScheme: .fromSeed(seedColor: Colors.white),
          textTheme: TextTheme(),
          cardTheme: CardThemeData(
            shadowColor: Colors.red.shade800,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          appBarTheme: const AppBarTheme(
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            backgroundColor: Colors.transparent
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.dark(inversePrimary: Colors.red.shade800),
        ),
        home: const MainShell(),
        routes: {
          '/home': (_) => const HomePage(),
          '/login': (_) => const AuthPage(),
        },
      ),
    );
  }
}
