import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:softwarica_student_management_bloc/app/constants/api_endpoints.dart';
import 'package:softwarica_student_management_bloc/app/constants/theme_constant.dart';
import 'package:softwarica_student_management_bloc/app/di/di.dart';
import 'package:softwarica_student_management_bloc/core/theme/app_theme.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/home_cubit.dart';

import '../view_model/bloc/message_bloc.dart';
import '../view_model/bloc/message_event.dart';
import '../view_model/bloc/message_state.dart';
import 'chat_page.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  _MatchesPageState createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  DateTime? _lastShakeTime;
  static const double logoutShakeThreshold = 50.0; // High threshold for logout
  static const int shakeCooldown = 1000;

  @override
  void initState() {
    super.initState();
    _initLogoutDetection();
  }

  void _initLogoutDetection() {
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      final now = DateTime.now();
      if (_lastShakeTime != null &&
          now.difference(_lastShakeTime!).inMilliseconds < shakeCooldown) {
        return;
      }

      if (event.x.abs() > logoutShakeThreshold ||
          event.y.abs() > logoutShakeThreshold ||
          event.z.abs() > logoutShakeThreshold) {
        _lastShakeTime = now;
        _logout(context);
      }
    });
  }

  void _logout(BuildContext context) {
    context.read<HomeCubit>().logout(context);
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = theme.customThemeExtension;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return BlocProvider(
      create: (_) => getIt<MessageBloc>()..add(FetchMatches()),
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          shadowColor: theme.colorScheme.onSurface.withOpacity(0.1),
          toolbarHeight: isTablet ? 40 : 30,
          leading: Padding(
            padding: const EdgeInsets.only(left: ThemeConstant.smallPadding),
            child: Image.asset(
              'assets/icons/plain_logo.png',
              height: isTablet ? 30 : 20,
              width: isTablet ? 30 : 20,
              fit: BoxFit.contain,
            ),
          ),
          leadingWidth: isTablet ? 40 : 30,
          title: Center(
            child: Image.asset(
              'assets/icons/text_logo.png',
              height: isTablet ? 30 : 20,
              fit: BoxFit.contain,
            ),
          ),
          backgroundColor: theme.colorScheme.background, // Theme-adaptive color
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: customTheme.scaffoldGradient,
          ),
          padding: EdgeInsets.all(isTablet ? ThemeConstant.largePadding : ThemeConstant.mediumPadding),
          child: BlocBuilder<MessageBloc, MessageState>(
            builder: (context, state) {
              if (state is MessageLoading) {
                return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
              } else if (state is MessageLoaded) {
                final matches = state.matches;
                if (matches.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: isTablet ? 60 : 48,
                          color: theme.colorScheme.primary,
                        ),
                        SizedBox(height: ThemeConstant.mediumPadding),
                        Text(
                          'No Matches Yet',
                          style: theme.textTheme.displayMedium,
                        ),
                        Text(
                          'Keep swiping to find your match!',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    final match = matches[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatPage(matchId: match.id),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: ThemeConstant.smallPadding),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ThemeConstant.mediumBorderRadius),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: isTablet ? 30 : 24,
                            backgroundImage: NetworkImage(
                              match.profilePhoto != null
                                  ? '${ApiEndpoints.profilePhotoUrl}${match.profilePhoto}'
                                  : '${ApiEndpoints.profilePhotoUrl}/default_profile.png',
                            ),
                          ),
                          title: Text(
                            match.name,
                            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (state is MessageError) {
                return Center(child: Text('Error: ${state.message}', style: theme.textTheme.bodyLarge));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}