import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softwarica_student_management_bloc/app/shared_prefs/token_shared_prefs.dart';
import 'package:softwarica_student_management_bloc/core/network/api_service.dart';
import 'package:softwarica_student_management_bloc/core/network/connectivity_service.dart';
import 'package:softwarica_student_management_bloc/core/network/hive_service.dart';
import 'package:softwarica_student_management_bloc/core/services/socket_service.dart';
import 'package:softwarica_student_management_bloc/core/theme/theme_cubit.dart';
import 'package:softwarica_student_management_bloc/features/auth/data/data_source/local_data_source/auth_local_datasource.dart';
import 'package:softwarica_student_management_bloc/features/auth/data/data_source/remote_data_source/auth_remote_data_source.dart';
import 'package:softwarica_student_management_bloc/features/auth/data/repository/auth_local_repository/auth_local_repository.dart';
import 'package:softwarica_student_management_bloc/features/auth/data/repository/auth_remote_repository/auth_remote_repository.dart';
import 'package:softwarica_student_management_bloc/features/auth/data/repository/auth_repository_impl.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/repository/auth_repository.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/get_current_user_use_case.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/login_usecase.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/register_user_usecase.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/update_profile_photo_use_case.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/update_profile_usecase.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/upload_image_usecase.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/edit_profile/edit_profile_bloc.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:softwarica_student_management_bloc/features/home/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:softwarica_student_management_bloc/features/home/data/repository/remote_repository/user_remote_repository.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/repository/user_repository.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/use_case/get_likers_usecase.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/use_case/get_users_usecase.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/use_case/sewipe_left_usesace.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/use_case/swipe_right_usecase.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/bloc/user_bloc.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/home_cubit.dart';
import 'package:softwarica_student_management_bloc/features/messages/data/data_source/message_remote_data_source.dart';
import 'package:softwarica_student_management_bloc/features/messages/data/repositories/message_remote_repository.dart';
import 'package:softwarica_student_management_bloc/features/messages/domain/use_case/get_matches_use_case.dart';
import 'package:softwarica_student_management_bloc/features/messages/domain/use_case/send_message_use_case.dart';
import 'package:softwarica_student_management_bloc/features/messages/presentation/view_model/bloc/message_bloc.dart';
import 'package:softwarica_student_management_bloc/features/photos/data/data_source/remote_data_source/photos_remote_data_source.dart';
import 'package:softwarica_student_management_bloc/features/photos/domain/repository/photos_repository.dart';
import 'package:softwarica_student_management_bloc/features/photos/domain/use_case/add_photos_use_case.dart';
import 'package:softwarica_student_management_bloc/features/photos/domain/use_case/get_photos_use_case.dart';
import 'package:softwarica_student_management_bloc/features/photos/presentation/view_model/bloc/photos_bloc.dart';
import 'package:softwarica_student_management_bloc/features/preferences/data/data_source/preference_remote_data_source.dart';
import 'package:softwarica_student_management_bloc/features/preferences/data/repositories/preference_remote_repository.dart';
import 'package:softwarica_student_management_bloc/features/preferences/domain/use_case/get_preference_use_case.dart';
import 'package:softwarica_student_management_bloc/features/preferences/domain/use_case/update_preference_use_case.dart';
import 'package:softwarica_student_management_bloc/features/preferences/presentation/view_model/bloc/preference_bloc.dart';
import 'package:softwarica_student_management_bloc/features/splash/presentation/view_model/splash_cubit.dart';
import 'package:softwarica_student_management_bloc/features/subscription/data/datasources/payment_service.dart';
import 'package:softwarica_student_management_bloc/features/subscription/data/datasources/subscription_remote_datasource.dart';
import 'package:softwarica_student_management_bloc/features/subscription/data/repositories/subscription_remote_repository.dart';
import 'package:softwarica_student_management_bloc/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:softwarica_student_management_bloc/features/subscription/domain/usecases/get_subscription_expiry.dart';
import 'package:softwarica_student_management_bloc/features/subscription/domain/usecases/save_subscription.dart';
import 'package:softwarica_student_management_bloc/features/subscription/presentation/view_model/bloc/subscription_bloc.dart';
import 'package:softwarica_student_management_bloc/features/user_details/data/data_source/remote_data_source/user_details_remote_data_source.dart';
import 'package:softwarica_student_management_bloc/features/user_details/data/repository/auth_local_repository/user_details_local_repository.dart';
import 'package:softwarica_student_management_bloc/features/user_details/data/repository/auth_remote_repository/user_details_remote_repository.dart';
import 'package:softwarica_student_management_bloc/features/user_details/domain/repository/user_details_repository.dart';
import 'package:softwarica_student_management_bloc/features/user_details/domain/use_case/get_user_details_use_case.dart';
import 'package:softwarica_student_management_bloc/features/user_details/domain/use_case/update_user_details_use_case.dart';
import 'package:softwarica_student_management_bloc/features/user_details/presentation/view_model/bloc/user_details_bloc.dart';

import '../../features/home/data/data_source/local_datasource/user_local_datasource.dart';
import '../../features/home/data/repository/local_repository/user_local_repository.dart';
import '../../features/home/data/repository/user_repository_impl.dart';
import '../../features/user_details/data/data_source/local_data_source/user_details_local_data_source.dart';
import '../../features/user_details/data/repository/user_details_repository_impl.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  await _initCoreDependencies();
  await _initHiveService();
  await _initApiService();
  await _initSharedPreferences();
  await _initThemeDependencies();

  // Core dependencies first
  await _initAuthDependencies();
  await _initLoginDependencies();
  await _initSplashScreenDependencies();
  await _initHomeDependencies();
  await _initUserProfileDependencies();
  await _initUserDetailsDependencies();
  await _initPhotosDependencies();
  await _initUpdateDependencies();
  await _initPreferenceDependencies();
  await _initMessageDependencies();
  await _initSubscriptionDependencies();
}

Future<void> _initCoreDependencies() async {
  getIt.registerSingleton<ConnectivityService>(ConnectivityService());
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
    () => AuthRemoteDataSource(getIt<Dio>()),
  );

  // =========================== Repository ===========================
  // Local
  getIt.registerLazySingleton<AuthLocalRepository>(
    () => AuthLocalRepository(getIt<AuthLocalDataSource>()),
  );
  // Remote
  getIt.registerLazySingleton<AuthRemoteRepository>(
    () => AuthRemoteRepository(
        getIt<AuthRemoteDataSource>(), getIt<AuthLocalDataSource>()),
  );

  // Domain Repository with Connectivity Check
  getIt.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(
      remoteRepository: getIt<AuthRemoteRepository>(),
      localRepository: getIt<AuthLocalRepository>(),
      connectivityService: getIt<ConnectivityService>(),
    ),
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
  getIt.registerLazySingleton<UserDetailsLocalDataSource>(
    () => UserDetailsLocalDataSource(getIt<HiveService>()),
  );

  // =========================== Repository ===========================
  getIt.registerLazySingleton<IUserDetailsRepository>(
    () => UserDetailsRepositoryImpl(
      remoteRepository: getIt<UserDetailsRemoteRepository>(),
      localRepository: getIt<UserDetailsLocalRepository>(),
      connectivityService: getIt<ConnectivityService>(),
    ),
  );

  // Local
  getIt.registerLazySingleton<UserDetailsLocalRepository>(
    () => UserDetailsLocalRepository(getIt<UserDetailsLocalDataSource>()),
  );
  // Remote
  getIt.registerLazySingleton<UserDetailsRemoteRepository>(
    () => UserDetailsRemoteRepository(getIt<UserDetailsRemoteDataSource>(),
        getIt<UserDetailsLocalDataSource>()),
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
  getIt.registerLazySingleton(() => SocketService());

  // Register UserRemoteDataSource
  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(getIt<Dio>()),
  );

  // Register UserLocalDataSource
  getIt.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSource(getIt<HiveService>()),
  );

  // Register UserRemoteRepository
  getIt.registerLazySingleton<UserRemoteRepository>(
    () => UserRemoteRepository(getIt<UserRemoteDataSource>()),
  );

  // Register UserLocalRepository
  getIt.registerLazySingleton<UserLocalRepository>(
    () => UserLocalRepository(getIt<UserLocalDataSource>()),
  );

  // Register UserRepositoryImpl as the main IUserRepository
  getIt.registerLazySingleton<IUserRepository>(
    () => UserRepositoryImpl(
      remoteRepository: getIt<UserRemoteRepository>(),
      localRepository: getIt<UserLocalRepository>(),
      connectivityService: getIt<ConnectivityService>(),
    ),
  );

  // Register Use Cases
  getIt.registerLazySingleton<GetUsersUseCase>(
    () => GetUsersUseCase(getIt<IUserRepository>()),
  );
  getIt.registerLazySingleton<GetLikersUseCase>(
    () => GetLikersUseCase(getIt<IUserRepository>()),
  );
  getIt.registerLazySingleton<SwipeLeftUseCase>(
    () => SwipeLeftUseCase(getIt<IUserRepository>()),
  );
  getIt.registerLazySingleton<SwipeRightUseCase>(
    () => SwipeRightUseCase(getIt<IUserRepository>()),
  );

  // Register UserBloc
  getIt.registerFactory<UserBloc>(
    () => UserBloc(
      fetchUsersUseCase: getIt<GetUsersUseCase>(),
      fetchLikersUseCase: getIt<GetLikersUseCase>(),
      swipeLeftUseCase: getIt<SwipeLeftUseCase>(),
      swipeRightUseCase: getIt<SwipeRightUseCase>(),
      socketService: getIt<SocketService>(),
    ),
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

Future<void> _initPreferenceDependencies() async {
  print('Initializing preference dependencies');
  // Remote Data Source
  getIt.registerLazySingleton<PreferenceRemoteDataSource>(
    () => PreferenceRemoteDataSourceImpl(getIt<Dio>()),
  );
  // // Local Data Source
  // getIt.registerLazySingleton<PreferenceLocalDataSource>(
  //   () => PreferenceLocalDataSourceImpl(getIt<HiveService>()),
  // );
  // Repositories
  getIt.registerLazySingleton<PreferenceRemoteRepository>(
    () => PreferenceRemoteRepository(getIt<PreferenceRemoteDataSource>()),
  );
  // getIt.registerLazySingleton<PreferenceLocalRepository>(
  //   () => PreferenceLocalRepository(getIt<PreferenceLocalDataSource>()),
  // );
  // Use Cases (Using Remote Repository here; swap to Local if needed)
  getIt.registerLazySingleton<GetPreferenceUseCase>(
    () => GetPreferenceUseCase(getIt<PreferenceRemoteRepository>()),
  );
  getIt.registerLazySingleton<UpdatePreferenceUseCase>(
    () => UpdatePreferenceUseCase(getIt<PreferenceRemoteRepository>()),
  );
  // BLoC
  getIt.registerFactory<PreferenceBloc>(
    () => PreferenceBloc(
      getIt<GetPreferenceUseCase>(),
      getIt<UpdatePreferenceUseCase>(),
    ),
  );
}

Future<void> _initMessageDependencies() async {
  print('Initializing message dependencies');
  getIt.registerLazySingleton<MessageRemoteDataSource>(() =>
      MessageRemoteDataSourceImpl(
        getIt<Dio>(),
        getIt<LoginBloc>().state.authUser?.userId ?? '67bca780905faf4859a1686f',
      ));
  getIt.registerLazySingleton<MessageRepositoryImpl>(
      () => MessageRepositoryImpl(getIt<MessageRemoteDataSource>()));
  getIt.registerLazySingleton<GetMatchesUseCase>(
      () => GetMatchesUseCase(getIt<MessageRepositoryImpl>()));
  getIt.registerLazySingleton<SendMessageUseCase>(
      () => SendMessageUseCase(getIt<MessageRepositoryImpl>()));
  getIt.registerFactory<MessageBloc>(
    () => MessageBloc(
      getIt<GetMatchesUseCase>(),
      getIt<SendMessageUseCase>(),
      getIt<MessageRepositoryImpl>(),
    ),
  );
}

Future<void> _initSubscriptionDependencies() async {
  getIt.registerLazySingleton<SubscriptionRemoteDataSource>(
    () => SubscriptionRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<SubscriptionRepository>(
    () => SubscriptionRepositoryImpl(getIt<SubscriptionRemoteDataSource>()),
  );
  getIt.registerLazySingleton<GetSubscriptionExpiry>(
    () => GetSubscriptionExpiry(getIt<SubscriptionRepository>()),
  );
  getIt.registerLazySingleton<SaveSubscription>(
    () => SaveSubscription(getIt<SubscriptionRepository>()),
  );
  getIt.registerFactory<SubscriptionBloc>(
    () => SubscriptionBloc(
        getIt<GetSubscriptionExpiry>(), getIt<SaveSubscription>()),
  );
  getIt.registerSingleton<PaymentService>(PaymentService(getIt<Dio>()));
}

Future<void> _initThemeDependencies() async {
  print('Initializing theme dependencies');
  // Register ThemeCubit as a singleton
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
}
