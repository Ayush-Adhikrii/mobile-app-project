import 'package:dartz/dartz.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/entity/user_entity.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/repository/user_repository.dart';
import 'package:softwarica_student_management_bloc/features/user_details/domain/entity/user_details_entity.dart';

import '../../data_source/local_datasource/user_local_datasource.dart';

class UserLocalRepository implements IUserRepository {
  final UserLocalDataSource _localDataSource;

  UserLocalRepository(this._localDataSource);

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers() async {
    try {
      // Create 5 AuthEntity objects
      final users = [
        AuthEntity(
          userId: 'user1',
          name: 'Alice Smith',
          userName: 'alice_s',
          email: 'alice@example.com',
          phoneNumber: '1234567890',
          password: 'password1',
          gender: 'Female',
          birthDate: '1990-01-01',
          starSign: 'Capricorn',
          bio: 'Loves hiking and reading',
          profilePhoto: null,
        ),
        AuthEntity(
          userId: 'user2',
          name: 'Bob Johnson',
          userName: 'bob_j',
          email: 'bob@example.com',
          phoneNumber: '2345678901',
          password: 'password2',
          gender: 'Male',
          birthDate: '1992-02-02',
          starSign: 'Aquarius',
          bio: 'Enjoys gaming and cooking',
          profilePhoto: null,
        ),
        AuthEntity(
          userId: 'user3',
          name: 'Clara Davis',
          userName: 'clara_d',
          email: 'clara@example.com',
          phoneNumber: '3456789012',
          password: 'password3',
          gender: 'Female',
          birthDate: '1993-03-03',
          starSign: 'Pisces',
          bio: 'Passionate about photography',
          profilePhoto: null,
        ),
        AuthEntity(
          userId: 'user4',
          name: 'David Wilson',
          userName: 'david_w',
          email: 'david@example.com',
          phoneNumber: '4567890123',
          password: 'password4',
          gender: 'Male',
          birthDate: '1994-04-04',
          starSign: 'Aries',
          bio: 'Loves traveling and sports',
          profilePhoto: null,
        ),
        AuthEntity(
          userId: 'user5',
          name: 'Emma Brown',
          userName: 'emma_b',
          email: 'emma@example.com',
          phoneNumber: '5678901234',
          password: 'password5',
          gender: 'Female',
          birthDate: '1995-05-05',
          starSign: 'Taurus',
          bio: 'Enjoys painting and music',
          profilePhoto: null,
        ),
      ];

      // Create 5 UserDetailsEntity objects, one for each user
      final userDetailsList = [
        UserDetailsEntity(
          userId: 'user1',
          profession: 'Software Engineer',
          education: 'Bachelor’s in Computer Science',
          height: 165.0,
          exercise: 'Yoga',
          drinks: 'Occasionally',
          smoke: 'No',
          kids: 'No',
          religion: 'Christian',
        ),
        UserDetailsEntity(
          userId: 'user2',
          profession: 'Chef',
          education: 'Culinary School',
          height: 180.0,
          exercise: 'Gym',
          drinks: 'Yes',
          smoke: 'No',
          kids: 'Yes',
          religion: 'Atheist',
        ),
        UserDetailsEntity(
          userId: 'user3',
          profession: 'Photographer',
          education: 'Bachelor’s in Fine Arts',
          height: 170.0,
          exercise: 'Running',
          drinks: 'No',
          smoke: 'No',
          kids: 'No',
          religion: 'Buddhist',
        ),
        UserDetailsEntity(
          userId: 'user4',
          profession: 'Travel Blogger',
          education: 'Bachelor’s in Journalism',
          height: 175.0,
          exercise: 'Hiking',
          drinks: 'Occasionally',
          smoke: 'Yes',
          kids: 'No',
          religion: 'Hindu',
        ),
        UserDetailsEntity(
          userId: 'user5',
          profession: 'Artist',
          education: 'Master’s in Fine Arts',
          height: 160.0,
          exercise: 'Dance',
          drinks: 'No',
          smoke: 'No',
          kids: 'Yes',
          religion: 'Muslim',
        ),
      ];

      // Fetch all users from Hive (includes adding users and user details)
      final userEntities = await _localDataSource.getUsers(users, userDetailsList);
      print('UserLocalRepository: Fetched ${userEntities.length} users from Hive');
      return Right(userEntities);
    } catch (e) {
      print('UserLocalRepository: Failed to fetch users from Hive: $e');
      return Left(LocalDatabaseFailure(message: "Failed to fetch users from local storage: $e"));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getLikers(String userId) async {
    throw UnimplementedError('getLikers not implemented in UserLocalRepository');
  }

  @override
  Future<Either<Failure, void>> swipeLeft(String userId) async {
    throw UnimplementedError('swipeLeft not implemented in UserLocalRepository');
  }

  @override
  Future<Either<Failure, void>> swipeRight(String userId) async {
    throw UnimplementedError('swipeRight not implemented in UserLocalRepository');
  }
}