import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../core/common/snackbar/my_snackbar.dart';
import '../../../domain/use_case/user_details_use_case.dart';

part 'user_details_event.dart';
part 'user_details_state.dart';

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  final UserDetailsUseCase _addUserDetailsUseCase;

  UserDetailsBloc({
    required UserDetailsUseCase addUserDetailsUseCase,
  })  : _addUserDetailsUseCase = addUserDetailsUseCase,
        super(UserDetailsState.initial()) {
    on<UserDetails>(_onAddUserDetailsEvent);
  }

  void _onAddUserDetailsEvent(
    UserDetails event,
    Emitter<UserDetailsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _addUserDetailsUseCase.call(AddUserDetailsParams(
      userId: 'some_user_id',
      profession: event.profession,
      education: event.education,
      height: event.height,
      exercise: event.exercise,
      drinks: event.drinks,
      smoke: event.smoke,
      kids: event.kids,
      religion: event.religion,
    ));

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        showMySnackBar(
          color: Colors.red,
          context: event.context,
          message: "Failed to add user details",
        );
      },
      (success) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
          context: event.context,
          message: "User details added successfully",
        );
      },
    );
  }
}
