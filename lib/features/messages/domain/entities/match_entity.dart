// lib/features/message/domain/entities/match_entity.dart
import 'package:equatable/equatable.dart';

class MatchEntity extends Equatable {
  final String id;
  final String name;
  final String? profilePhoto;

  const MatchEntity({
    required this.id,
    required this.name,
    this.profilePhoto,
  });

  @override
  List<Object?> get props => [id, name, profilePhoto];
}