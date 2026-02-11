import 'package:get_it/get_it.dart';
import 'package:ticketing/core/storage/token_storage.dart';
import 'package:ticketing/features/auth/data/services/fake_auth_remote_service.dart';
import 'package:ticketing/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:ticketing/features/auth/domain/usecases/logout_usecase.dart';
import 'package:ticketing/features/events/domain/usecases/get_events_usecase.dart';
import 'package:ticketing/features/events/presentation/bloc/event_bloc.dart';
import 'package:ticketing/features/venues/data/repositories/venue_repository_impl.dart';
import 'package:ticketing/features/venues/data/services/venue_api_service.dart';
import 'package:ticketing/features/venues/data/services/venue_cache.dart';
import 'package:ticketing/features/venues/domain/repositories/venue_repository.dart';
import 'package:ticketing/features/venues/domain/usecases/get_venues_usecase.dart';
import 'package:ticketing/features/venues/presentation/bloc/venue_bloc.dart';

import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/events/data/repositories/event_repository_impl.dart';
import '../../features/events/data/services/event_api_service.dart';
import '../../features/events/domain/repositories/event_repository.dart';
import '../network/dio_client.dart';


final sl = GetIt.instance;


Future<void> setupLocator() async {
// Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(authService: sl(), tokenStorage: sl()));
  sl.registerLazySingleton(() => FakeAuthRemoteService());
  sl.registerSingleton(TokenStorage());
  sl.registerLazySingleton(() => DioClient().dio);
  //event
  sl.registerLazySingleton(() => EventApiService(sl()));
  sl.registerLazySingleton<EventRepository>(() => EventRepositoryImpl(sl()));
  //venue
  sl.registerLazySingleton(() => VenueApiService(sl()));
  sl.registerLazySingleton<VenueRepository>(()=> VenueRepositoryImpl(sl()));
  sl.registerLazySingleton(()=> VenueCache());

// UseCase
  //auth
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthUseCase(sl()));
  //event
  sl.registerLazySingleton(() => GetEventsUsecase(sl()));
  //venue
  sl.registerLazySingleton(() => GetVenuesUsecase(sl()));

// Bloc (factory çünkü her sayfada yeni instance)
  sl.registerFactory(() => AuthCubit(loginUseCase: sl(), checkAuthUseCase: sl(), logoutUseCase: sl()));
  sl.registerFactory(() => EventBloc(sl()));
  sl.registerFactory(() => VenueBloc(sl(), sl()));
}