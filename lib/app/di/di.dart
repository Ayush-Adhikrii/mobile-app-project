import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softwarica_student_management_bloc/features/user_details/data/data_source/local_data_source/user_details_local_data_source.dart';

import '../../core/network/api_service.dart';
import '../../core/network/hive_service.dart';
import '../../features/auth/data/data_source/local_data_source/auth_local_datasource.dart';
import '../../features/auth/data/data_source/remote_data_source/auth_remote_data_source.dart';
import '../../features/auth/data/repository/auth_local_repository/auth_local_repository.dart';
import '../../features/auth/data/repository/auth_remote_repository/auth_remote_repository.dart';
import '../../features/auth/domain/use_case/login_usecase.dart';
import '../../features/auth/domain/use_case/register_user_usecase.dart';
import '../../features/auth/domain/use_case/upload_image_usecase.dart';
import '../../features/auth/presentation/view_model/login/login_bloc.dart';
import '../../features/auth/presentation/view_model/signup/register_bloc.dart';
import '../../features/home/presentation/view_model/home_cubit.dart';
import '../../features/splash/presentation/view_model/splash_cubit.dart';
import '../../features/user_details/data/repository/auth_local_repository/user_details_local_repository.dart';
import '../../features/user_details/domain/use_case/user_details_use_case.dart';
import '../../features/user_details/presentation/view_model/bloc/user_details_bloc.dart';
import '../shared_prefs/token_shared_prefs.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  await _initApiService();

  await _initHomeDependencies();
  await _initRegisterDependencies();
  await _initLoginDependencies();
  await _initSplashScreenDependencies();
  await _initSharedPreferences();

  await _initUserDetailsDependencies();
}

_initApiService() {
  // Remote Data Source
  getIt.registerLazySingleton<Dio>(
    () => ApiService(Dio()).dio,
  );
}

_initHiveService() {
  getIt.registerLazySingleton<HiveService>(() => HiveService());
}

Future<void> _initSharedPreferences() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}

_initRegisterDependencies() {
  // =========================== Data Source ===========================
  //local
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(getIt<HiveService>()),
  );
  //remote
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<Dio>()),
  );

  // =========================== Repository ===========================
  //local
  getIt.registerLazySingleton(
    () => AuthLocalRepository(getIt<AuthLocalDataSource>()),
  );
  //remote
  getIt.registerLazySingleton<AuthRemoteRepository>(
    () => AuthRemoteRepository(getIt<AuthRemoteDataSource>()),
  );

  // =========================== Usecases ===========================

  //remote
  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(
      getIt<AuthRemoteRepository>(),
    ),
  );

  getIt.registerLazySingleton<UploadImageUsecase>(
    () => UploadImageUsecase(getIt<AuthRemoteRepository>()),
  );

  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(
      registerUseCase: getIt(),
      uploadImageUsecase: getIt(),
    ),
  );
}

_initHomeDependencies() {
  getIt.registerFactory<HomeCubit>(() => HomeCubit());
}

_initLoginDependencies() {
  getIt.registerLazySingleton<TokenSharedPrefs>(
    () => TokenSharedPrefs(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(
      getIt<AuthRemoteRepository>(),
      getIt<TokenSharedPrefs>(),
    ),
  );

  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(
      registerBloc: getIt<RegisterBloc>(),
      homeCubit: getIt<HomeCubit>(),
      loginUseCase: getIt<LoginUseCase>(),
    ),
  );
}

_initSplashScreenDependencies() {
  getIt.registerFactory<SplashCubit>(
    () => SplashCubit(getIt<LoginBloc>()),
  );
}

_initUserDetailsDependencies() {
  // =========================== Data Source ===========================
  //local
  getIt.registerLazySingleton<UserDetailsLocalDataSource>(
    () => UserDetailsLocalDataSource(getIt<HiveService>()),
  );
  //remote
  // getIt.registerLazySingleton<UserDetailsRemoteDataSource>(
  //   () => UserDetailsRemoteDataSource(getIt<Dio>()),
  // );

  // =========================== Repository ===========================
  //local
  getIt.registerLazySingleton(
    () => UserDetailsLocalRepository(getIt<UserDetailsLocalDataSource>()),
  );
  //remote
  // getIt.registerLazySingleton<UserDetailsRemoteRepository>(
  //   () => UserDetailsRemoteRepository(getIt<UserDetailsRemoteDataSource>()),
  // );

  // =========================== Usecases ===========================
  //local
  getIt.registerLazySingleton<UserDetailsUseCase>(
    () => UserDetailsUseCase(getIt<UserDetailsLocalRepository>()),
  );

  //remote

  // getIt.registerLazySingleton<UserDetailsUseCase>(
  //   () => UserDetailsUseCase(
  //     getIt<UserDetailsRemoteRepository>(),
  //   ),
  // );

  // =========================== Bloc ===========================
  getIt.registerFactory<UserDetailsBloc>(
    () => UserDetailsBloc(
      addUserDetailsUseCase: getIt(),
    ),
  );
}
