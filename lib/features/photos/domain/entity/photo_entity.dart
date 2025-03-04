// lib/features/photos/domain/entities/photo_entity.dart
class PhotoEntity {
  final String id; // MongoDB _id
  final String userId;
  final String? image; // Image path or URL

  PhotoEntity({
    required this.id,
    required this.userId,
    this.image,
  });

  factory PhotoEntity.fromJson(Map<String, dynamic> json) {
    return PhotoEntity(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'image': image,
    };
  }
}