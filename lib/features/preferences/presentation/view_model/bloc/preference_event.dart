// lib/features/preference/presentation/bloc/preference_event.dart
import 'package:equatable/equatable.dart';

import '../../../domain/entity/preference_entity.dart';

abstract class PreferenceEvent extends Equatable {
  const PreferenceEvent();

  @override
  List<Object?> get props => [];
}

class FetchPreference extends PreferenceEvent {
  final String userId;

  const FetchPreference(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdatePreference extends PreferenceEvent {
  final String userId;
  final PreferenceEntity preference;

  const UpdatePreference(this.userId, this.preference);

  @override
  List<Object?> get props => [userId, preference];
}