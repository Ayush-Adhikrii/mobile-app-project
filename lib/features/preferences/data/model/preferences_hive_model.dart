import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../../app/constants/hive_table_constant.dart';
import '../../domain/entity/preferences_entity.dart';

part 'preferences_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.preferenceTableId)
class PreferencesHiveModel extends Equatable {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String? preferredGender;

  @HiveField(2)
  final int? minAge;

  @HiveField(3)
  final int? maxAge;

  @HiveField(4)
  final String? relationType;

  @HiveField(5)
  final String? preferredStarSign;

  @HiveField(6)
  final String? preferredReligion;

  const PreferencesHiveModel({
    required this.userId,
    this.preferredGender,
    this.minAge,
    this.maxAge,
    this.relationType,
    this.preferredStarSign,
    this.preferredReligion,
  });

  // From Entity
  factory PreferencesHiveModel.fromEntity(PreferencesEntity entity) {
    return PreferencesHiveModel(
      userId: entity.userId,
      preferredGender: entity.preferredGender,
      minAge: entity.minAge,
      maxAge: entity.maxAge,
      relationType: entity.relationType,
      preferredStarSign: entity.preferredStarSign,
      preferredReligion: entity.preferredReligion,
    );
  }

  // To Entity
  PreferencesEntity toEntity() {
    return PreferencesEntity(
      userId: userId,
      preferredGender: preferredGender,
      minAge: minAge,
      maxAge: maxAge,
      relationType: relationType,
      preferredStarSign: preferredStarSign,
      preferredReligion: preferredReligion,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        preferredGender,
        minAge,
        maxAge,
        relationType,
        preferredStarSign,
        preferredReligion,
      ];
}
