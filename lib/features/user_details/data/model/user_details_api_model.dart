import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/user_details_entity.dart';

part 'user_details_api_model.g.dart';
//dart run build_runner build -d

@JsonSerializable()
class UserDetailsApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;
  final String? profession;
  final String? education;
  final double? height;
  final String? exercise;
  final String? drinks;
  final String? smoke;
  final String? kids;
  final String? religion;

  const UserDetailsApiModel({
    this.userId,
    this.profession,
    this.education,
    this.height,
    this.exercise,
    this.drinks,
    this.smoke,
    this.kids,
    this.religion,
  });

  /// Converts JSON to `UserDetailsApiModel`
  factory UserDetailsApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsApiModelFromJson(json);

  /// Converts `UserDetailsApiModel` to JSON
  Map<String, dynamic> toJson() => _$UserDetailsApiModelToJson(this);

  /// Converts `UserDetailsApiModel` to `UserDetailsEntity`
  UserDetailsEntity toEntity() {
    return UserDetailsEntity(
      userId: userId ?? '',
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

  /// Creates `UserDetailsApiModel` from `UserDetailsEntity`
  factory UserDetailsApiModel.fromEntity(UserDetailsEntity entity) {
    return UserDetailsApiModel(
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
