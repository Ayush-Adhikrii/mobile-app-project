// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserApiModel _$UserApiModelFromJson(Map<String, dynamic> json) => UserApiModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      userName: json['userName'] as String,
      gender: json['gender'] as String?,
      birthDate: json['birthDate'] as String?,
      starSign: json['starSign'] as String?,
      bio: json['bio'] as String?,
      profilePhoto: json['profilePhoto'] as String?,
    );

Map<String, dynamic> _$UserApiModelToJson(UserApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'userName': instance.userName,
      'gender': instance.gender,
      'birthDate': instance.birthDate,
      'starSign': instance.starSign,
      'bio': instance.bio,
      'profilePhoto': instance.profilePhoto,
    };
