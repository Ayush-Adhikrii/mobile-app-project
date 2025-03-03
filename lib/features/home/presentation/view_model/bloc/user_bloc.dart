// lib/features/home/presentation/view_model/bloc/user_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_case/get_users_usecase.dart';
import '../../../domain/use_case/sewipe_left_usesace.dart';
import '../../../domain/use_case/swipe_right_usecase.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUseCase getUsersUseCase;
  final SwipeLeftUseCase swipeLeftUseCase;
  final SwipeRightUseCase swipeRightUseCase;

  UserBloc(this.getUsersUseCase, this.swipeLeftUseCase, this.swipeRightUseCase)
      : super(const UserInitial()) {
    on<FetchUsers>((event, emit) async {
      print('FetchUsers event triggered');
      emit(const UserLoading());
      final result = await getUsersUseCase();
      emit(result.fold(
        (failure) {
          print('UserBloc error: ${failure.message}');
          return UserError(failure.message);
        },
        (users) {
          print('UserBloc loaded: ${users.length} users');
          return UserLoaded(users);
        },
      ));
    });

    on<SwipeLeft>((event, emit) async {
      if (state is UserLoaded) {
        final currentState = state as UserLoaded;
        emit(UserLoading(users: currentState.users));
        final result = await swipeLeftUseCase(event.userId);
        emit(result.fold(
          (failure) => UserError(failure.message, users: currentState.users),
          (_) {
            final updatedUsers = currentState.users
                .where((user) => user.id != event.userId)
                .toList();
            print(
                'Swiped left on ${event.userId}, remaining users: ${updatedUsers.length}');
            return UserLoaded(updatedUsers, swipeFeedback: 'passed');
          },
        ));
      }
    });

    on<SwipeRight>((event, emit) async {
      if (state is UserLoaded) {
        final currentState = state as UserLoaded;
        emit(UserLoading(users: currentState.users));
        final result = await swipeRightUseCase(event.userId);
        emit(result.fold(
          (failure) => UserError(failure.message, users: currentState.users),
          (_) {
            final updatedUsers = currentState.users
                .where((user) => user.id != event.userId)
                .toList();
            print(
                'Swiped right on ${event.userId}, remaining users: ${updatedUsers.length}');
            return UserLoaded(updatedUsers, swipeFeedback: 'liked');
          },
        ));
      }
    });
  }
}
