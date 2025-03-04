// lib/features/preference/presentation/bloc/preference_state.dart
import 'package:equatable/equatable.dart';

import '../../../domain/entity/preference_entity.dart';

abstract class PreferenceState extends Equatable {
  const PreferenceState();

  @override
  List<Object?> get props => [];
}

class PreferenceInitial extends PreferenceState {
  const PreferenceInitial();
}

class PreferenceLoading extends PreferenceState {
  const PreferenceLoading();
}

class PreferenceLoaded extends PreferenceState {
  final PreferenceEntity preference;

  const PreferenceLoaded(this.preference);

  @override
  List<Object?> get props => [preference];
}

class PreferenceError extends PreferenceState {
  final String message;

  const PreferenceError(this.message);

  @override
  List<Object?> get props => [message];
}