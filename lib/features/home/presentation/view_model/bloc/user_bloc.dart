// lib/features/home/presentation/view_model/bloc/user_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/use_case/get_likers_usecase.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/use_case/get_users_usecase.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/use_case/sewipe_left_usesace.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/use_case/swipe_right_usecase.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/bloc/user_event.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUseCase getUsersUseCase;
  final SwipeLeftUseCase swipeLeftUseCase;
  final SwipeRightUseCase swipeRightUseCase;
  final GetLikersUseCase getLikersUseCase;

  UserBloc(this.getUsersUseCase, this.swipeLeftUseCase, this.swipeRightUseCase,
      this.getLikersUseCase)
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

    on<FetchLikers>((event, emit) async {
      emit(const UserLoading());
      final result = await getLikersUseCase(event.userId);
      emit(result.fold(
        (failure) {
          print('UserBloc error: ${failure.message}');
          return UserError(failure.message);
        },
        (likers) {
          print('UserBloc loaded likers: ${likers.length} users');
          return LikersLoaded(likers);
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
      } else if (state is LikersLoaded) {
        final currentState = state as LikersLoaded;
        emit(UserLoading(users: currentState.likers));
        final result = await swipeLeftUseCase(event.userId);
        emit(result.fold(
          (failure) => UserError(failure.message, users: currentState.likers),
          (_) {
            final updatedLikers = currentState.likers
                .where((user) => user.id != event.userId)
                .toList();
            print(
                'Swiped left on ${event.userId}, remaining likers: ${updatedLikers.length}');
            return LikersLoaded(updatedLikers, swipeFeedback: 'passed');
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
      } else if (state is LikersLoaded) {
        final currentState = state as LikersLoaded;
        emit(UserLoading(users: currentState.likers));
        final result = await swipeRightUseCase(event.userId);
        emit(result.fold(
          (failure) => UserError(failure.message, users: currentState.likers),
          (_) {
            final updatedLikers = currentState.likers
                .where((user) => user.id != event.userId)
                .toList();
            print(
                'Swiped right on ${event.userId}, remaining likers: ${updatedLikers.length}');
            return LikersLoaded(updatedLikers, swipeFeedback: 'liked');
          },
        ));
      }
    });
  }
}
