// lib/features/message/data/models/message_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/message_entity.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel extends MessageEntity {
  const MessageModel({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'sender') required String senderId,
    required String content,
  }) : super(id: id, senderId: senderId, content: content);

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}