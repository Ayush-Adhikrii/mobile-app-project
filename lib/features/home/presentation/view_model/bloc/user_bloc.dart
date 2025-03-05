// lib/features/home/presentation/view_model/bloc/user_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/use_case/get_likers_usecase.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/use_case/get_users_usecase.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/use_case/sewipe_left_usesace.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/use_case/swipe_right_usecase.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/bloc/user_event.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/bloc/user_state.dart';

import '../../../../../core/services/socket_service.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUseCase fetchUsersUseCase;
  final GetLikersUseCase fetchLikersUseCase;
  final SwipeRightUseCase swipeRightUseCase;
  final SwipeLeftUseCase swipeLeftUseCase;
  final SocketService socketService;

  UserBloc({
    required this.fetchUsersUseCase,
    required this.fetchLikersUseCase,
    required this.swipeRightUseCase,
    required this.swipeLeftUseCase,
    required this.socketService,
  }) : super(const UserInitial()) {
    // Subscribe to new matches when the bloc is initialized
    socketService.subscribeToNewMatches((newMatch) {
      if (state is UserLoaded) {
        final currentState = state as UserLoaded;
        print('New match received: $newMatch');
        add(NewMatchDetected(users: currentState.users));
      } else if (state is LikersLoaded) {
        final currentState = state as LikersLoaded;
        print('New match received: $newMatch');
        add(NewMatchDetected(users: currentState.likers));
      }
    });

    // Event handlers
    on<FetchUsers>((event, emit) async {
      emit(const UserLoading(users: []));
      final result = await fetchUsersUseCase();
      emit(result.fold(
        (failure) => UserError(failure.message, users: []),
        (users) => UserLoaded(users),
      ));
    });

    on<FetchLikers>((event, emit) async {
      emit(const UserLoading(users: []));
      final result = await fetchLikersUseCase(event.userId);
      emit(result.fold(
        (failure) => UserError(failure.message, users: []),
        (likers) => LikersLoaded(likers),
      ));
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

    on<NewMatchDetected>((event, emit) {
      emit(UserMatchFound(users: event.users, swipeFeedback: 'liked'));
    });
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('UserBloc error: $error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
