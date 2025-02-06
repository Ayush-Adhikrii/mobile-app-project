import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/register_user_usecase.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/upload_image_usecase.dart';

import 'repository.mock.dart';

class FakeFile extends Fake implements File {}

void main() {
  late MockUserRepository repository;
  late RegisterUsecase usecase;
  late UploadImageUsecase imageUsecase;

  setUpAll(() {
    registerFallbackValue(FakeFile()); // Registering a fallback value for File
  });

  setUp(() {
    repository = MockUserRepository();
    usecase = RegisterUsecase(repository: repository);
    imageUsecase = UploadImageUsecase(repository: repository);
    registerFallbackValue(
        AuthEntity.empty()); // Registering fallback for AuthEntity
  });

  final params = RegisterUserParams.empty();
  final imageFile = File('/assets/images/profile.png');
  final imageParams = UploadImageParams(file: imageFile);
  test('should register a user successfully', () async {
    when(() => repository.registerUser(any())).thenAnswer(
      (_) async => Right(unit),
    );

    // Act
    final result = await usecase(params);

    // Assert
    expect(result, Right(unit));

    // Verify
    verify(() => repository.registerUser(any())).called(1);
    verifyNoMoreInteractions(repository);
  });

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
}
