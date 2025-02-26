// lib/app/di/di.dart
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softwarica_student_management_bloc/app/shared_prefs/token_shared_prefs.dart';
import 'package:softwarica_student_management_bloc/core/network/api_service.dart';
import 'package:softwarica_student_management_bloc/core/network/hive_service.dart';
import 'package:softwarica_student_management_bloc/features/auth/data/data_source/local_data_source/auth_local_datasource.dart';
import 'package:softwarica_student_management_bloc/features/auth/data/data_source/remote_data_source/auth_remote_data_source.dart';
import 'package:softwarica_student_management_bloc/features/auth/data/repository/auth_local_repository/auth_local_repository.dart';
import 'package:softwarica_student_management_bloc/features/auth/data/repository/auth_remote_repository/auth_remote_repository.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/repository/auth_repository.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/get_current_user_use_case.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/login_usecase.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/register_user_usecase.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/update_profile_usecase.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/upload_image_usecase.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/edit_profile/edit_profile_bloc.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:softwarica_student_management_bloc/features/home/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:softwarica_student_management_bloc/features/home/data/repository/remote_repository/user_remote_repository.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/repository/user_repository.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/use_case/get_users_usecase.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/bloc/user_bloc.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/home_cubit.dart';
import 'package:softwarica_student_management_bloc/features/splash/presentation/view_model/splash_cubit.dart';
import 'package:softwarica_student_management_bloc/features/user_details/data/data_source/remote_data_source/user_details_remote_data_source.dart';
import 'package:softwarica_student_management_bloc/features/user_details/data/repository/auth_remote_repository/user_details_remote_repository.dart';
import 'package:softwarica_student_management_bloc/features/user_details/domain/repository/user_details_repository.dart';
import 'package:softwarica_student_management_bloc/features/user_details/domain/use_case/get_user_details_use_case.dart';
import 'package:softwarica_student_management_bloc/features/user_details/domain/use_case/update_user_details_use_case.dart';
import 'package:softwarica_student_management_bloc/features/user_details/presentation/view_model/bloc/user_details_bloc.dart';

import '../../features/auth/domain/use_case/update_profile_photo_use_case.dart';
import '../../features/photos/data/data_source/remote_data_source/photos_remote_data_source.dart';
import '../../features/photos/domain/repository/photos_repository.dart';
import '../../features/photos/domain/use_case/add_photos_use_case.dart';
import '../../features/photos/domain/use_case/get_photos_use_case.dart';
import '../../features/photos/presentation/view_model/bloc/photos_bloc.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  await _initApiService();
  await _initSharedPreferences();

  // Core dependencies first
  await _initAuthDependencies(); // Combined auth-related dependencies
  await _initLoginDependencies();
  await _initSplashScreenDependencies();
  await _initHomeDependencies();
  await _initUserProfileDependencies();
  await _initUserDetailsDependencies();
  await _initPhotosDependencies();
  await _initUpdateDependencies();
}

Future<void> _initApiService() async {
  getIt.registerLazySingleton<Dio>(
    () => ApiService(Dio()).dio,
  );
}

Future<void> _initHiveService() async {
  getIt.registerLazySingleton<HiveService>(() => HiveService());
}

Future<void> _initSharedPreferences() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}

Future<void> _initAuthDependencies() async {
  // =========================== Data Source ===========================
  // Local
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(getIt<HiveService>()),
  );
  // Remote
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<Dio>()),
  );

  // =========================== Repository ===========================
  // Local
  getIt.registerLazySingleton<AuthLocalRepository>(
    () => AuthLocalRepository(getIt<AuthLocalDataSource>()),
  );
  // Remote - Register as IAuthRepository
  getIt.registerLazySingleton<IAuthRepository>(
    () => AuthRemoteRepository(getIt<AuthRemoteDataSource>()),
  );

  // =========================== Use Cases ===========================
  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(getIt<IAuthRepository>()),
  );

  getIt.registerLazySingleton<UploadImageUsecase>(
    () => UploadImageUsecase(getIt<IAuthRepository>()),
  );

  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(
      registerUseCase: getIt<RegisterUseCase>(),
      uploadImageUsecase: getIt<UploadImageUsecase>(),
    ),
  );
}

Future<void> _initHomeDependencies() async {
  getIt.registerFactory<HomeCubit>(() => HomeCubit());
}

Future<void> _initLoginDependencies() async {
  getIt.registerLazySingleton<TokenSharedPrefs>(
    () => TokenSharedPrefs(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(
      getIt<IAuthRepository>(),
      getIt<TokenSharedPrefs>(),
    ),
  );
  getIt.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(getIt<IAuthRepository>()),
  );
  getIt.registerLazySingleton<LoginBloc>(
    () => LoginBloc(
      registerBloc: getIt<RegisterBloc>(),
      homeCubit: getIt<HomeCubit>(),
      loginUseCase: getIt<LoginUseCase>(),
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
    ),
  );
}

Future<void> _initSplashScreenDependencies() async {
  getIt.registerLazySingleton<SplashCubit>(
    () => SplashCubit(getIt<LoginBloc>()),
  );
}

Future<void> _initUserDetailsDependencies() async {
  // =========================== Data Source ===========================
  getIt.registerLazySingleton<UserDetailsRemoteDataSource>(
    () => UserDetailsRemoteDataSource(getIt<Dio>()),
  );

  // =========================== Repository ===========================
  getIt.registerLazySingleton<IUserDetailsRepository>(
    () => UserDetailsRepositoryImpl(getIt<UserDetailsRemoteDataSource>()),
  );

  // =========================== Use Cases ===========================
  getIt.registerLazySingleton<GetUserDetailsUseCase>(
    () => GetUserDetailsUseCase(getIt<IUserDetailsRepository>()),
  );
  getIt.registerLazySingleton<UpdateUserDetailsUseCase>(
    () => UpdateUserDetailsUseCase(getIt<IUserDetailsRepository>()),
  );

  // =========================== Bloc ===========================
  getIt.registerFactory<UserDetailsBloc>(
    () => UserDetailsBloc(
      getUserDetailsUseCase: getIt<GetUserDetailsUseCase>(),
      updateUserDetailsUseCase: getIt<UpdateUserDetailsUseCase>(),
    ),
  );
}

Future<void> _initUserProfileDependencies() async {
  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<IUserRepository>(
    () => UserRemoteRepository(getIt<UserRemoteDataSource>()),
  );
  getIt.registerLazySingleton<GetUsersUseCase>(
    () => GetUsersUseCase(getIt<IUserRepository>()),
  );
  getIt.registerFactory<UserBloc>(
    () => UserBloc(getIt<GetUsersUseCase>()),
  );
}

Future<void> _initPhotosDependencies() async {
  getIt.registerLazySingleton<IPhotosRemoteDataSource>(
    () => PhotosRemoteDataSource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<IPhotosRepository>(
    () => PhotosRepository(getIt<IPhotosRemoteDataSource>()),
  );
  getIt.registerLazySingleton<GetPhotosUseCase>(
    () => GetPhotosUseCase(getIt<IPhotosRepository>()),
  );
  getIt.registerLazySingleton<AddPhotoUseCase>(
    () => AddPhotoUseCase(getIt<IPhotosRepository>()),
  );
  getIt.registerLazySingleton<PhotosBloc>(
    () => PhotosBloc(
      getPhotosUseCase: getIt<GetPhotosUseCase>(),
      addPhotoUseCase: getIt<AddPhotoUseCase>(),
    ),
  );
}

Future<void> _initUpdateDependencies() async {
  // Ensure IAuthRepository is available before registering dependent use cases
  getIt.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(getIt<IAuthRepository>()),
  );
  getIt.registerLazySingleton<UploadProfilePhotoUseCase>(
    () => UploadProfilePhotoUseCase(getIt<IAuthRepository>()),
  );
  getIt.registerLazySingleton<EditProfileBloc>(
    () => EditProfileBloc(
      updateProfileUseCase: getIt<UpdateProfileUseCase>(),
      uploadProfilePhotoUseCase: getIt<UploadProfilePhotoUseCase>(),
    ),
  );
}
