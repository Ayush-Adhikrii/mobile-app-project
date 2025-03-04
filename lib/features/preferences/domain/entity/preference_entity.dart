// lib/features/preference/domain/entities/preference_entity.dart
import 'package:equatable/equatable.dart';

class PreferenceEntity extends Equatable {
  final String userId;
  final String? preferredGender;
  final int? minAge;
  final int? maxAge;
  final String? relationType;
  final String? preferredStarSign;
  final String? preferredReligion;

  const PreferenceEntity({
    required this.userId,
    this.preferredGender,
    this.minAge,
    this.maxAge,
    this.relationType,
    this.preferredStarSign,
    this.preferredReligion,
  });

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