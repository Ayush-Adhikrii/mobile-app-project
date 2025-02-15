import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/preferences_entity.dart';

part 'preferences_api_model.g.dart';

@JsonSerializable()
class PreferencesApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;
  final String? preferredGender;
  final int? minAge;
  final int? maxAge;
  final String? relationType;
  final String? preferredStarSign;
  final String? preferredReligion;

  const PreferencesApiModel({
    this.userId,
    this.preferredGender,
    this.minAge,
    this.maxAge,
    this.relationType,
    this.preferredStarSign,
    this.preferredReligion,
  });

  /// Converts JSON to `PreferenceApiModel`
  factory PreferencesApiModel.fromJson(Map<String, dynamic> json) =>
      _$PreferencesApiModelFromJson(json);

  /// Converts `PreferenceApiModel` to JSON
  Map<String, dynamic> toJson() => _$PreferencesApiModelToJson(this);

  /// Converts `PreferenceApiModel` to `PreferenceEntity`
  PreferencesEntity toEntity() {
    return PreferencesEntity(
      userId: userId ?? '',
      preferredGender: preferredGender,
      minAge: minAge,
      maxAge: maxAge,
      relationType: relationType,
      preferredStarSign: preferredStarSign,
      preferredReligion: preferredReligion,
    );
  }

  /// Creates `PreferenceApiModel` from `PreferenceEntity`
  factory PreferencesApiModel.fromEntity(PreferencesEntity entity) {
    return PreferencesApiModel(
      userId: entity.userId,
      preferredGender: entity.preferredGender,
      minAge: entity.minAge,
      maxAge: entity.maxAge,
      relationType: entity.relationType,
      preferredStarSign: entity.preferredStarSign,
      preferredReligion: entity.preferredReligion,
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
