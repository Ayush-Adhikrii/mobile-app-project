// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_details_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetailsApiModel _$UserDetailsApiModelFromJson(Map<String, dynamic> json) =>
    UserDetailsApiModel(
      userId: json['_id'] as String?,
      profession: json['profession'] as String?,
      education: json['education'] as String?,
      height: (json['height'] as num?)?.toDouble(),
      exercise: json['exercise'] as String?,
      drinks: json['drinks'] as String?,
      smoke: json['smoke'] as String?,
      kids: json['kids'] as String?,
      religion: json['religion'] as String?,
    );

Map<String, dynamic> _$UserDetailsApiModelToJson(
        UserDetailsApiModel instance) =>
    <String, dynamic>{
      '_id': instance.userId,
      'profession': instance.profession,
      'education': instance.education,
      'height': instance.height,
      'exercise': instance.exercise,
      'drinks': instance.drinks,
      'smoke': instance.smoke,
      'kids': instance.kids,
      'religion': instance.religion,
    };
