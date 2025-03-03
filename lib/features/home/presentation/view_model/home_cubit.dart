// lib/features/home/presentation/view_model/home_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:softwarica_student_management_bloc/features/messages/presentation/view/match_page.dart';
import 'package:softwarica_student_management_bloc/features/preferences/presentation/view/pages/preference_page.dart';

import '../../../user_details/presentation/view/profile_view.dart';
import '../view/swipe_screen.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState(selectedIndex: 2, views: _defaultViews));

  static final List<Widget> _defaultViews = [
    const Center(child: Text('Likes')), // Placeholder for likes
    const PreferencePage(), // Placeholder for filter
    const SwipeScreen(), // Matches
    const ProfilePage(), // Profile
    const MatchesPage(), // Placeholder for messages
  ];

  void onTabTapped(int index) {
    print('onTabTapped: $index');
    emit(HomeState(selectedIndex: index, views: _defaultViews));
  }

  void logout(BuildContext context) {
    context.read<LoginBloc>().add(LogoutUserEvent(context));
  }
}
