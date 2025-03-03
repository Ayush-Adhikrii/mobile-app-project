// lib/features/message/data/models/match_model.dart
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/match_entity.dart';

part 'match_model.g.dart';

@JsonSerializable()
class MatchModel extends MatchEntity {
  const MatchModel({
    @JsonKey(name: '_id') required String id,
    required String name,
    @JsonKey(defaultValue: null) String? profilePhoto,
  }) : super(id: id, name: name, profilePhoto: profilePhoto);

  factory MatchModel.fromJson(Map<String, dynamic> json) => _$MatchModelFromJson(json);

  Map<String, dynamic> toJson() => _$MatchModelToJson(this);
}