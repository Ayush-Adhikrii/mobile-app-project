// lib/features/auth/presentation/view_model/edit_profile/edit_profile_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_case/update_profile_photo_use_case.dart';
import '../../../domain/use_case/update_profile_usecase.dart';
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
          name: event.name,
          gender: event.gender,
          email: event.email,
          birthDate: event.birthDate,
          phoneNumber: event.phoneNumber,
          bio: event.bio,
          userName: event.userName,
        ),
      );
      emit(result.fold(
        (failure) => EditProfileError(failure.message),
        (user) {
          print('UpdateProfile success: ${user.toJson()}');
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
        (failure) => EditProfileError(failure.message),
        (user) {
          print('UploadProfilePhoto success: ${user.toJson()}');
          return EditProfileSuccess(user);
        },
      ));
    });
  }
}
