import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:softwarica_student_management_bloc/core/common/snackbar/my_snackbar.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/register_user_usecase.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/upload_image_usecase.dart';

import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase _registerUseCase;
  final UploadImageUsecase _uploadImageUsecase;

  RegisterBloc({
    required RegisterUseCase registerUseCase,
    required UploadImageUsecase uploadImageUsecase,
  })  : _registerUseCase = registerUseCase,
        _uploadImageUsecase = uploadImageUsecase,
        super(RegisterState.initial()) {
    on<RegisterUser>(_onRegisterEvent);
    on<UploadImage>(_onLoadImage);
  }

  // Registration event: uses the stored imageName (filename) for the profile photo
  void _onRegisterEvent(
    RegisterUser event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isOffline: false));
    print("password ${event.password}");

    final result = await _registerUseCase.call(RegisterUserParams(
      name: event.name,
      email: event.email,
      phoneNumber: event.phoneNumber,
      userName: event.userName,
      password: event.password,
      gender: event.gender,
      birthDate: event.birthDate,
      starSign: event.starSign,
      bio: event.bio,
      profilePhoto: state.imageName,
    ));

    result.fold(
      (failure) {
        print('Register failed: ${failure.message}');
        emit(state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: failure.message,
          isOffline: failure.message
              .contains('Failed to register user in local storage'),
        ));
        showMySnackBar(
          context: event.context,
          message: failure.message
                  .contains('Failed to register user in local storage')
              ? "Registered locally. Will sync when online."
              : "Registration failed: ${failure.message}",
          color: failure.message
                  .contains('Failed to register user in local storage')
              ? Colors.orange
              : Colors.red,
        );
      },
      (_) {
        print('Register succeeded');
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
          context: event.context,
          message: "Registration Successful",
          color: Colors.green,
        );
      },
    );
  }

  // Upload image event: extracts the filename from the upload API response
  void _onLoadImage(
    UploadImage event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isOffline: false));
    final result = await _uploadImageUsecase.call(
      UploadImageParams(
        file: event.file,
      ),
    );

    result.fold(
      (failure) {
        print('Upload image failed: ${failure.message}');
        emit(state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: failure.message,
          isOffline: failure.message.contains('No internet connection'),
        ));
        showMySnackBar(
          context: event.context,
          message: failure.message.contains('No internet connection')
              ? "Offline: Cannot upload image without internet"
              : "Image upload failed: ${failure.message}",
          color: Colors.red,
        );
      },
      (imageName) {
        print('Upload image succeeded, imageName: $imageName');
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          imageName: imageName,
        ));
        showMySnackBar(
          context: event.context,
          message: "Image uploaded successfully",
          color: Colors.green,
        );
      },
    );
  }
}
