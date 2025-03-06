import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softwarica_student_management_bloc/core/common/snackbar/my_snackbar.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/update_profile_photo_use_case.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/update_profile_usecase.dart';

import 'edit_profile_event.dart';
import 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final UpdateProfileUseCase updateProfileUseCase;
  final UploadProfilePhotoUseCase uploadProfilePhotoUseCase;

  EditProfileBloc({
    required this.updateProfileUseCase,
    required this.uploadProfilePhotoUseCase,
  }) : super(const EditProfileInitial()) {
    on<UpdateProfile>((event, emit) async {
      emit(const EditProfileLoading());
      final result = await updateProfileUseCase(
        UpdateProfileParams(
          userId: event.userId,
          name: event.name!,
          gender: event.gender!,
          email: event.email!,
          birthDate: event.birthDate!,
          starSign: event.starSign!,
          phoneNumber: event.phoneNumber!,
          bio: event.bio!,
          userName: event.userName!,
        ),
      );
      emit(result.fold(
        (failure) {
          print('UpdateProfile failed: ${failure.message}');
          showMySnackBar(
            context: event.context,
            message: failure.message.contains('Failed to update user in local storage')
                ? "Updated locally. Will sync when online."
                : "Failed to update profile: ${failure.message}",
            color: failure.message.contains('Failed to update user in local storage')
                ? Colors.orange
                : Colors.red,
          );
          return EditProfileError(
            failure.message,
            isOffline: failure.message.contains('Failed to update user in local storage'),
          );
        },
        (user) {
          print('UpdateProfile success: ${user.toJson()}');
          showMySnackBar(
            context: event.context,
            message: "Profile updated successfully",
            color: Colors.green,
          );
          return EditProfileSuccess(user);
        },
      ));
    });

    on<UploadProfilePhoto>((event, emit) async {
      emit(const EditProfileLoading());
      final result = await uploadProfilePhotoUseCase(
        UploadProfilePhotoParams(userId: event.userId, image: event.image),
      );
      emit(result.fold(
        (failure) {
          print('UploadProfilePhoto failed: ${failure.message}');
          showMySnackBar(
            context: event.context,
            message: failure.message.contains('No internet connection')
                ? "Offline: Cannot upload photo without internet"
                : "Failed to upload photo: ${failure.message}",
            color: Colors.red,
          );
          return EditProfileError(
            failure.message,
            isOffline: failure.message.contains('No internet connection'),
          );
        },
        (user) {
          print('UploadProfilePhoto success: ${user.toJson()}');
          showMySnackBar(
            context: event.context,
            message: "Profile photo uploaded successfully",
            color: Colors.green,
          );
          return EditProfileSuccess(user);
        },
      ));
    });
  }
}