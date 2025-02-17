// import 'dart:io';

// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';
// import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/register_user_usecase.dart';

// import 'repository.mock.dart';

// class FakeFile extends Fake implements File {}

// void main() {
//   late MockUserRepository repository;
//   late RegisterUseCase usecase;

//   setUp(() {
//     repository = MockUserRepository();
//     usecase = RegisterUseCase(repository: repository);
//     registerFallbackValue(AuthEntity.empty());
//   });

//   final params = RegisterUserParams.empty();

//   test('should register a user successfully', () async {
//     when(() => repository.registerUser(any())).thenAnswer(
//       (_) async => Right(unit),
//     );

//     // Act
//     final result = await usecase(params);

//     // Assert
//     expect(result, Right(unit));

//     // Verify
//     verify(() => repository.registerUser(any())).called(1);
//     verifyNoMoreInteractions(repository);
//   });
// }
