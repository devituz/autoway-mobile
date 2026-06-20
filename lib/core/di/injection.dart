import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/client/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/client/auth/data/repositories/auth_repository.dart';
import '../network/dio_client.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../network/interceptors/refresh_interceptor.dart';
import '../storage/token_storage.dart';

final sl = GetIt.instance; // sl stands for Service Locator

Future<void> initInjection() async {
  // External
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);
  sl.registerLazySingleton(() => Dio());

  // Core
  sl.registerLazySingleton(() => TokenStorage(sl()));
  sl.registerLazySingleton(() => AuthInterceptor(sl()));
  sl.registerLazySingleton(() => RefreshInterceptor(sl()));
  sl.registerLazySingleton(() => DioClient(sl(), sl(), sl()));

  // Auth feature
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl()));
  sl.registerLazySingleton(() => AuthRepository(sl(), sl()));
}
