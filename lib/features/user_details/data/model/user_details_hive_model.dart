import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:softwarica_student_management_bloc/app/constants/hive_table_constant.dart';
import 'package:softwarica_student_management_bloc/features/user_details/domain/entity/user_details_entity.dart';

part 'user_details_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userDetailsTableId)
class UserDetailsHiveModel extends Equatable {
  @HiveField(0)
  final String userId; // Changed from String? to String (non-nullable)
  @HiveField(1)
  final String? profession;
  @HiveField(2)
  final String? education;
  @HiveField(3)
  final double? height;
  @HiveField(4)
  final String? exercise;
  @HiveField(5)
  final String? drinks;
  @HiveField(6)
  final String? smoke;
  @HiveField(7)
  final String? kids;
  @HiveField(8)
  final String? religion;

  const UserDetailsHiveModel({
    required this.userId, // Changed to required
    this.profession,
    this.education,
    this.height,
    this.exercise,
    this.drinks,
    this.smoke,
    this.kids,
    this.religion,
  });

  // From Entity
  factory UserDetailsHiveModel.fromEntity(UserDetailsEntity entity) {
    return UserDetailsHiveModel(
      userId: entity.userId,
      profession: entity.profession,
      education: entity.education,
      height: entity.height,
      exercise: entity.exercise,
      drinks: entity.drinks,
      smoke: entity.smoke,
      kids: entity.kids,
      religion: entity.religion,
    );
  }

  // To Entity
  UserDetailsEntity toEntity() {
    return UserDetailsEntity(
      userId: userId,
      profession: profession,
      education: education,
      height: height,
      exercise: exercise,
      drinks: drinks,
      smoke: smoke,
      kids: kids,
      religion: religion,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        profession,
        education,
        height,
        exercise,
        drinks,
        smoke,
        kids,
        religion,
      ];
}
