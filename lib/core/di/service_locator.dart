import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketing/core/storage/token_storage.dart';
import 'package:ticketing/features/auth/data/services/fake_auth_remote_service.dart';
import 'package:ticketing/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:ticketing/features/auth/domain/usecases/logout_usecase.dart';
import 'package:ticketing/features/events/domain/usecases/get_events_by_venue_id_usecase.dart';
import 'package:ticketing/features/events/domain/usecases/get_events_usecase.dart';
import 'package:ticketing/features/events/presentation/bloc/event_bloc.dart';
import 'package:ticketing/features/tickets/data/repositories/ticket_repository_impl.dart';
import 'package:ticketing/features/tickets/domain/repositories/ticket_repository.dart';
import 'package:ticketing/features/tickets/domain/usecases/get_my_tickets_usecase.dart';
import 'package:ticketing/features/tickets/domain/usecases/purchase_ticket_usecase.dart';
import 'package:ticketing/features/tickets/presentation/cubit/ticket_purchase_cubit.dart';
import 'package:ticketing/features/tickets/presentation/cubit/tickets_cubit.dart';
import 'package:ticketing/features/venues/data/repositories/venue_repository_impl.dart';
import 'package:ticketing/features/venues/data/services/venue_api_service.dart';
import 'package:ticketing/features/venues/data/services/venue_cache.dart';
import 'package:ticketing/features/venues/domain/repositories/venue_repository.dart';
import 'package:ticketing/features/venues/domain/usecases/search_venues_usecase.dart';
import 'package:ticketing/features/venues/presentation/bloc/search_venue/search_venue_bloc.dart';
import 'package:ticketing/features/venues/presentation/bloc/venue_detail/venue_detail_bloc.dart';

import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_token_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/profile_cubit.dart';
import '../../features/events/data/repositories/event_repository_impl.dart';
import '../../features/events/data/services/event_api_service.dart';
import '../../features/events/domain/repositories/event_repository.dart';
import '../../features/venues/domain/usecases/get_venue_by_id_usecase.dart';
import '../fake_backend/fake_db.dart';
import '../network/dio_client.dart';


final sl = GetIt.instance;


Future<void> setupLocator() async {
  //db
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);
  sl.registerLazySingleton(() => FakeDb(sl()));

// Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(authService: sl(), tokenStorage: sl()));
  sl.registerLazySingleton(() => FakeAuthRemoteService(sl()));
  sl.registerSingleton(TokenStorage());
  sl.registerLazySingleton(() => DioClient().dio);
  //event
  sl.registerLazySingleton(() => EventApiService(sl()));
  sl.registerLazySingleton<EventRepository>(() => EventRepositoryImpl(sl()));
  //venue
  sl.registerLazySingleton(() => VenueApiService(sl()));
  sl.registerLazySingleton<VenueRepository>(()=> VenueRepositoryImpl(sl()));
  sl.registerLazySingleton(()=> VenueCache());
  //ticket
  sl.registerLazySingleton<TicketRepository>(() => TicketRepositoryImpl(db: sl(), authRepository: sl()));

// UseCase
  //auth
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GetTokenUseCase(sl()));
  //event
  sl.registerLazySingleton(() => GetEventsUsecase(sl()));
  sl.registerLazySingleton(() => GetEventsByVenueIdUsecase(sl()));
  //venue
  sl.registerLazySingleton(() => SearchVenuesUsecase(sl()));
  sl.registerLazySingleton(() => GetVenueByIdUseCase(sl()));
  //ticket
  sl.registerLazySingleton(() => PurchaseTicketUseCase(sl()));
  sl.registerLazySingleton(() => GetMyTicketsUseCase(sl()));

// Bloc (factory çünkü her sayfada yeni instance)
  sl.registerFactory(() => AuthCubit(loginUseCase: sl(),registerUseCase: sl(), checkAuthUseCase: sl(), logoutUseCase: sl()));
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(getTokenUseCase: sl()));
  sl.registerFactory(() => EventBloc(sl(),sl()));
  sl.registerFactory(() => SearchVenueBloc(sl()));
  sl.registerFactory(() => VenueDetailBloc(sl()));
  sl.registerFactory(() => TicketsCubit(getMyTicketsUseCase: sl()));
  sl.registerFactory(() => TicketPurchaseCubit(purchaseTicketUseCase: sl()));
}