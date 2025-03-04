// lib/features/user_details/presentation/view_model/bloc/user_details_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/di/di.dart';
import '../../../../auth/presentation/view_model/login/login_bloc.dart';
import '../../../domain/use_case/get_user_details_use_case.dart';
import '../../../domain/use_case/update_user_details_use_case.dart';
import 'user_details_event.dart';
import 'user_details_state.dart';

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  final GetUserDetailsUseCase getUserDetailsUseCase;
  final UpdateUserDetailsUseCase updateUserDetailsUseCase;

  UserDetailsBloc({
    required this.getUserDetailsUseCase,
    required this.updateUserDetailsUseCase,
  }) : super(const UserDetailsInitial()) {
    on<FetchUserDetails>((event, emit) async {
      emit(const UserDetailsLoading());
      final result = await getUserDetailsUseCase(userId: event.userId);
      emit(result.fold(
        (failure) => UserDetailsError(failure.message),
        (userDetails) => UserDetailsLoaded(userDetails),
      ));
    });

    on<UpdateUserDetails>((event, emit) async {
      emit(const UserDetailsLoading());
      final result =
          await updateUserDetailsUseCase(event.userId, event.key, event.value);
      emit(result.fold(
        (failure) => UserDetailsError(failure.message),
        (_) {
          // Simply refetch details without navigation
          final currentUserId = getIt<LoginBloc>().state.authUser?.userId ?? '';
          add(FetchUserDetails(currentUserId));
          return const UserDetailsLoading(); // Keep user on ProfilePage
        },
      ));
    });
  }
}
