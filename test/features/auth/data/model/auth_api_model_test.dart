import 'package:flutter_test/flutter_test.dart';
import 'package:softwarica_student_management_bloc/features/auth/data/model/auth_api_model.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';

void main() {
  const authApiModel = AuthApiModel(
    userId: '123',
    name: 'Hari Bahadur',
    email: 'hari.bahadur@example.com',
    phoneNumber: '9876543210',
    userName: 'haribahadur',
    password: 'password123',
    gender: 'Male',
    birthDate: null,
    starSign: 'Leo',
    bio: 'Hello, I am Hari!',
    profilePhoto: 'profile.jpg',
  );

  const authEntity = AuthEntity(
    userId: '123',
    name: 'Hari Bahadur',
    email: 'hari.bahadur@example.com',
    phoneNumber: '9876543210',
    userName: 'haribahadur',
    password: 'password123',
    gender: 'Male',
    birthDate: null,
    starSign: 'Leo',
    bio: 'Hello, I am Hari!',
    profilePhoto: 'profile.jpg',
  );

  final jsonMap = {
    '_id': '123',
    'name': 'Hari Bahadur',
    'email': 'hari.bahadur@example.com',
    'phoneNumber': '9876543210',
    'userName': 'haribahadur',
    'password': 'password123',
    'gender': 'Male',
    'birthDate': null,
    'starSign': 'Leo',
    'bio': 'Hello, I am Hari!',
    'profilePhoto': 'profile.jpg',
  };

  test('should correctly convert from JSON', () {
    final result = AuthApiModel.fromJson(jsonMap);
    expect(result, authApiModel);
  });

  test('should correctly convert to JSON', () {
    final result = authApiModel.toJson();
    expect(result, jsonMap);
  });

  test('should correctly convert to AuthEntity', () {
    final result = authApiModel.toEntity();
    expect(result, authEntity);
  });

  test('should correctly convert from AuthEntity', () {
    final result = AuthApiModel.fromEntity(authEntity);
    expect(result, authApiModel);
  });

  test('should have correct Equatable props', () {
    expect(authApiModel.props, [
      authApiModel.userId,
      authApiModel.name,
      authApiModel.email,
      authApiModel.phoneNumber,
      authApiModel.userName,
      authApiModel.password,
      authApiModel.gender,
      authApiModel.birthDate,
      authApiModel.starSign,
      authApiModel.bio,
      authApiModel.profilePhoto,
    ]);
  });
}
