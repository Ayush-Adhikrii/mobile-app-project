// lib/features/photos/data/models/photo_model.dart

import '../../domain/entity/photo_entity.dart';

class PhotoModel extends PhotoEntity {
  PhotoModel({
    required String id,
    required String userId,
    String? image,
  }) : super(id: id, userId: userId, image: image);

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      image: json['image'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'image': image,
    };
  }
}