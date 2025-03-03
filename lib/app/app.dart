// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softwarica_student_management_bloc/core/theme/app_theme.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view/login_view.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view/home_view.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/bloc/user_bloc.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/home_cubit.dart';
import 'package:softwarica_student_management_bloc/features/preferences/presentation/view/pages/preference_page.dart';
import 'package:softwarica_student_management_bloc/features/splash/presentation/view/splash_view.dart';
import 'package:softwarica_student_management_bloc/features/splash/presentation/view_model/splash_cubit.dart';

import '../features/auth/domain/entity/auth_entity.dart';
import '../features/auth/presentation/view/update_profile_view.dart';
import '../features/auth/presentation/view_model/edit_profile/edit_profile_bloc.dart';
import '../features/messages/presentation/view/chat_page.dart';
import '../features/messages/presentation/view/match_page.dart';
import '../features/messages/presentation/view_model/bloc/message_bloc.dart';
import '../features/photos/presentation/view_model/bloc/photos_bloc.dart';
import '../features/user_details/presentation/view/profile_view.dart';
import '../features/user_details/presentation/view_model/bloc/user_details_bloc.dart';
import 'di/di.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    print('App build called');
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (_) => getIt<LoginBloc>(),
        ),
        BlocProvider<SplashCubit>(
          create: (_) => getIt<SplashCubit>(),
        ),
        BlocProvider<UserBloc>(
          create: (_) => getIt<UserBloc>(),
        ),
        BlocProvider<HomeCubit>(
          create: (_) => getIt<HomeCubit>(),
        ),
        BlocProvider<PhotosBloc>(
          create: (_) => getIt<PhotosBloc>(),
        ),
        BlocProvider<EditProfileBloc>(create: (_) => getIt<EditProfileBloc>()),
        BlocProvider<MessageBloc>(create: (_) => getIt<MessageBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hooked',
        theme: AppTheme.getApplicationTheme(isDarkMode: false),
        initialRoute: '/splash', // Start with SplashView
        routes: {
          '/splash': (context) => const SplashView(),
          '/login': (context) => BlocProvider.value(
                value: getIt<LoginBloc>(),
                child: const LoginView(),
              ),
          '/home': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: getIt<HomeCubit>()),
                  BlocProvider.value(value: getIt<UserBloc>()),
                ],
                child: const HomeView(),
              ),
          '/profile': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: getIt<LoginBloc>()),
                  BlocProvider.value(value: getIt<UserDetailsBloc>()),
                  BlocProvider.value(value: getIt<PhotosBloc>()),
                ],
                child: const ProfilePage(),
              ),
          '/update_profile': (context) {
            final authUser =
                ModalRoute.of(context)!.settings.arguments as AuthEntity;
            return UpdateProfileView(authUser: authUser);
          },
          '/matches': (context) => const MatchesPage(),
          '/preferences': (context) => const PreferencePage(),
          '/chat': (context) => const ChatPage(matchId: ''),
        },
      ),
    );
  }
}
