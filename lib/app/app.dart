import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softwarica_student_management_bloc/app/di/di.dart';
import 'package:softwarica_student_management_bloc/core/theme/app_theme.dart';
import 'package:softwarica_student_management_bloc/core/theme/theme_cubit.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view/login_view.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view/update_profile_view.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/edit_profile/edit_profile_bloc.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view/home_view.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/bloc/user_bloc.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/home_cubit.dart';
import 'package:softwarica_student_management_bloc/features/photos/presentation/view_model/bloc/photos_bloc.dart';
import 'package:softwarica_student_management_bloc/features/splash/presentation/view/splash_view.dart';
import 'package:softwarica_student_management_bloc/features/splash/presentation/view_model/splash_cubit.dart';
import 'package:softwarica_student_management_bloc/features/user_details/presentation/view_model/bloc/user_details_bloc.dart';
import '../features/messages/presentation/view/chat_page.dart';
import '../features/messages/presentation/view/match_page.dart';
import '../features/messages/presentation/view_model/bloc/message_bloc.dart';
import '../features/preferences/presentation/view/pages/preference_page.dart';
import '../features/user_details/presentation/view/profile_view.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  static const _proximityChannel = EventChannel('proximity_sensor');
  StreamSubscription<dynamic>? _proximitySensorSubscription;
  Timer? _fallbackTimer;
  bool _simulateProximity = false;

  @override
  void dispose() {
    _proximitySensorSubscription?.cancel();
    _fallbackTimer?.cancel();
    super.dispose();
  }

  void _updateThemeBasedOnProximity(int proximityValue, ThemeState themeState, ThemeCubit themeCubit) {
    final isNear = proximityValue == 1;
    final isDark = isNear;
    if (isDark != themeState.isDarkMode) {
      print('Updating theme: isDark=$isDark (proximityValue=$proximityValue, isNear=$isNear)');
      themeCubit.setDarkMode(isDark);
    } else {
      print('No theme update needed: isDark=$isDark (proximityValue=$proximityValue, isNear=$isNear), current isDarkMode=${themeState.isDarkMode}');
    }
  }

  void _startFallbackTesting(ThemeState themeState, ThemeCubit themeCubit) {
    _fallbackTimer?.cancel();
    _fallbackTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      _simulateProximity = !_simulateProximity;
      final simulatedValue = _simulateProximity ? 1 : 0;
      print('Simulating proximity sensor value: $simulatedValue');
      _updateThemeBasedOnProximity(simulatedValue, themeState, themeCubit);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('App build called');
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (_) => getIt<LoginBloc>()),
        BlocProvider<SplashCubit>(create: (_) => getIt<SplashCubit>()),
        BlocProvider<UserBloc>(create: (_) => getIt<UserBloc>()),
        BlocProvider<HomeCubit>(create: (_) => getIt<HomeCubit>()),
        BlocProvider<PhotosBloc>(create: (_) => getIt<PhotosBloc>()),
        BlocProvider<EditProfileBloc>(create: (_) => getIt<EditProfileBloc>()),
        BlocProvider<MessageBloc>(create: (_) => getIt<MessageBloc>()),
        BlocProvider<ThemeCubit>(create: (_) => getIt<ThemeCubit>()),
      ],
      child: BlocListener<ThemeCubit, ThemeState>(
        listener: (context, themeState) {
          print('ThemeCubit state changed: isAutoTheme=${themeState.isAutoTheme}, isDarkMode=${themeState.isDarkMode}');
          if (themeState.isAutoTheme) {
            _proximitySensorSubscription?.cancel();
            _proximitySensorSubscription = _proximityChannel.receiveBroadcastStream().listen(
              (dynamic proximityValue) {
                final int value = proximityValue as int;
                print('Proximity sensor emitted value: proximityValue=$value');
                _updateThemeBasedOnProximity(value, themeState, context.read<ThemeCubit>());
              },
              onError: (error) {
                print('Proximity sensor error: $error');
                if (themeState.isDarkMode) {
                  context.read<ThemeCubit>().setDarkMode(false);
                }
                print('Starting fallback testing due to sensor error');
                _startFallbackTesting(themeState, context.read<ThemeCubit>());
              },
              onDone: () {
                print('Proximity sensor stream done');
              },
            );
          } else {
            _proximitySensorSubscription?.cancel();
            _proximitySensorSubscription = null;
            _fallbackTimer?.cancel();
            _fallbackTimer = null;
          }
        },
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            print('App rebuilding with theme: isDarkMode=${themeState.isDarkMode}');
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Hooked',
              theme: AppTheme.getApplicationTheme(isDarkMode: themeState.isDarkMode),
              initialRoute: '/splash',
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
                  final authUser = ModalRoute.of(context)!.settings.arguments as AuthEntity;
                  return UpdateProfileView(authUser: authUser);
                },
                '/matches': (context) => const MatchesPage(),
                '/preferences': (context) => const PreferencePage(),
                '/chat': (context) => const ChatPage(matchId: ''),
              },
            );
          },
        ),
      ),
    );
  }
}