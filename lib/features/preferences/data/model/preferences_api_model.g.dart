// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreferencesApiModel _$PreferencesApiModelFromJson(Map<String, dynamic> json) =>
    PreferencesApiModel(
      userId: json['_id'] as String?,
      preferredGender: json['preferredGender'] as String?,
      minAge: (json['minAge'] as num?)?.toInt(),
      maxAge: (json['maxAge'] as num?)?.toInt(),
      relationType: json['relationType'] as String?,
      preferredStarSign: json['preferredStarSign'] as String?,
      preferredReligion: json['preferredReligion'] as String?,
    );

Map<String, dynamic> _$PreferencesApiModelToJson(
        PreferencesApiModel instance) =>
    <String, dynamic>{
      '_id': instance.userId,
      'preferredGender': instance.preferredGender,
      'minAge': instance.minAge,
      'maxAge': instance.maxAge,
      'relationType': instance.relationType,
      'preferredStarSign': instance.preferredStarSign,
      'preferredReligion': instance.preferredReligion,
    };
