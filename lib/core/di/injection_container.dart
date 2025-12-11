import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

// Core
import '../config/dio_client.dart';
import '../services/notification_service.dart';
import '../services/navigation_service.dart';

// Features - Auth
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/login_2fa_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/verify_email_usecase.dart';
import '../../features/auth/domain/usecases/setup_2fa_usecase.dart';
import '../../features/auth/domain/usecases/enable_2fa_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';

/// Global GetIt instance
final sl = GetIt.instance; // sl = Service Locator

/// Initialize all dependencies
/// Call this once at app startup (in main.dart)
Future<void> initializeDependencies() async {
  // ===== CORE =====

  // Dio HTTP Client (singleton)
  sl.registerLazySingleton<Dio>(() => DioClient.instance);

  // Services (singletons)
  sl.registerLazySingleton<NotificationService>(() => NotificationService());
  sl.registerLazySingleton<NavigationService>(() => NavigationService());

  // ===== FEATURES - AUTH =====

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => Login2FAUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => VerifyEmailUseCase(sl()));
  sl.registerLazySingleton(() => Setup2FAUseCase(sl()));
  sl.registerLazySingleton(() => Enable2FAUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // ===== ADD YOUR FEATURES HERE =====
  // Follow the same pattern as Auth feature above:
  // 1. Register data sources
  // 2. Register repositories
  // 3. Register use cases
  //
  // Example:
  // sl.registerLazySingleton<MyFeatureRemoteDataSource>(
  //   () => MyFeatureRemoteDataSourceImpl(dio: sl()),
  // );
  // sl.registerLazySingleton<MyFeatureRepository>(
  //   () => MyFeatureRepositoryImpl(remoteDataSource: sl()),
  // );
  // sl.registerLazySingleton(() => GetMyDataUseCase(sl()));
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await sl.reset();
}
