import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/upload_image_usecase.dart';

import 'register_user_usecase_test.dart';
import 'repository.mock.dart';

void main() {
  late MockUserRepository repository;
  late UploadImageUsecase imageUsecase;

  setUp(() {
    repository = MockUserRepository();
    imageUsecase = UploadImageUsecase(repository: repository);
    registerFallbackValue(FakeFile());
  });

  final imageFile = File('/assets/images/profile.png');
  final imageParams = UploadImageParams(file: imageFile);

  test('should call upload image', () async {
    when(() => repository.uploadProfilePicture(any())).thenAnswer(
      (_) async => Right("image name"),
    );

    // Act
    final result = await imageUsecase(imageParams);

    // Assert
    expect(result, Right("image name"));

    // Verify
    verify(() => repository.uploadProfilePicture(any())).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('should call upload image', () async {
    when(() => repository.uploadProfilePicture(any())).thenAnswer(
      (_) async => Right("image name"),
    );

    // Act
    final result = await imageUsecase(imageParams);

    // Assert
    expect(result, Right("photo name")); //photo instead of image

    // Verify
    verify(() => repository.uploadProfilePicture(any())).called(1);
    verifyNoMoreInteractions(repository);
  });
}
