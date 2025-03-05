import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softwarica_student_management_bloc/app/constants/theme_constant.dart';
import 'package:softwarica_student_management_bloc/app/di/di.dart';

import '../view_model/home_cubit.dart';
import '../view_model/home_state.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return BlocProvider(
      create: (context) => getIt<HomeCubit>(),
      child: Scaffold(
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return state.views.elementAt(state.selectedIndex);
          },
        ),
        bottomNavigationBar: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite,
                    size: isTablet
                        ? ThemeConstant.mediumIconSize
                        : ThemeConstant.smallIconSize,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.filter_list,
                    size: isTablet
                        ? ThemeConstant.mediumIconSize
                        : ThemeConstant.smallIconSize,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.people,
                    size: isTablet
                        ? ThemeConstant.mediumIconSize
                        : ThemeConstant.smallIconSize,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    size: isTablet
                        ? ThemeConstant.mediumIconSize
                        : ThemeConstant.smallIconSize,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.message,
                    size: isTablet
                        ? ThemeConstant.mediumIconSize
                        : ThemeConstant.smallIconSize,
                  ),
                  label: '',
                ),
              ],
              currentIndex: state.selectedIndex,
              onTap: (index) => context.read<HomeCubit>().onTabTapped(index),
            );
          },
        ),
      ),
    );
  }
}
