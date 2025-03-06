// lib/features/home/presentation/view_model/home_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:softwarica_student_management_bloc/features/messages/presentation/view/match_page.dart';
import 'package:softwarica_student_management_bloc/features/preferences/presentation/view/pages/preference_page.dart';
import 'package:softwarica_student_management_bloc/features/subscription/presentation/view/likes_page.dart';

import '../../../auth/presentation/view_model/login/login_event.dart';
import '../../../user_details/presentation/view/profile_view.dart';
import '../view/swipe_screen.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState(selectedIndex: 2, views: _defaultViews));

  static final List<Widget> _defaultViews = [
    const LikesPage(), //  likes
    const PreferencePage(), // filter
    const SwipeScreen(), // Matches
    const ProfilePage(), // Profile
    const MatchesPage(), //  messages
  ];

  void onTabTapped(int index) {
    print('onTabTapped: $index');
    emit(HomeState(selectedIndex: index, views: _defaultViews));
  }

  void logout(BuildContext context) {
    context.read<LoginBloc>().add(LogoutUserEvent(context));
  }
}
