import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/api_constants.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'features/onboarding/domain/repositories/onboarding_repository.dart';
import 'features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'features/presentation/data/datasources/presentation_remote_datasource.dart';
import 'features/presentation/data/repositories/presentation_repository_impl.dart';
import 'features/presentation/domain/repositories/presentation_repository.dart';
import 'features/presentation/presentation/bloc/presentation_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  
  sl.registerFactory(() => AuthBloc(sl()));
  sl.registerFactory(() => PresentationBloc(sl()));
  sl.registerFactory(() => OnboardingBloc(repository: sl()));

  
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<PresentationRepository>(
    () => PresentationRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(sl()),
  );

  
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl()));
  sl.registerLazySingleton(() => PresentationRemoteDataSource(sl()));
  sl.registerLazySingleton(() => OnboardingLocalDataSource(sl()));

  
  sl.registerLazySingleton(() => Supabase.instance.client);
  
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  
  sl.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(milliseconds: ApiConstants.connectionTimeout),
        receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
    
    return dio;
  });
}