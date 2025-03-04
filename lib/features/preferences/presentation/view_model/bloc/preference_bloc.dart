// lib/features/preference/presentation/bloc/preference_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_case/get_preference_use_case.dart';
import '../../../domain/use_case/update_preference_use_case.dart';
import 'preference_event.dart';
import 'preference_state.dart';

class PreferenceBloc extends Bloc<PreferenceEvent, PreferenceState> {
  final GetPreferenceUseCase getPreferenceUseCase;
  final UpdatePreferenceUseCase updatePreferenceUseCase;

  PreferenceBloc(this.getPreferenceUseCase, this.updatePreferenceUseCase) : super(const PreferenceInitial()) {
    on<FetchPreference>((event, emit) async {
      emit(const PreferenceLoading());
      final result = await getPreferenceUseCase(event.userId);
      emit(result.fold(
        (failure) => PreferenceError(failure.message),
        (preference) => PreferenceLoaded(preference),
      ));
    });

    on<UpdatePreference>((event, emit) async {
      emit(const PreferenceLoading());
      final result = await updatePreferenceUseCase(event.userId, event.preference);
      emit(result.fold(
        (failure) => PreferenceError(failure.message),
        (preference) => PreferenceLoaded(preference),
      ));
    });
  }
}