// lib/features/photos/presentation/bloc/photos_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_case/add_photos_use_case.dart';
import '../../../domain/use_case/get_photos_use_case.dart';
import 'photos_event.dart';
import 'photos_state.dart';

class PhotosBloc extends Bloc<PhotosEvent, PhotosState> {
  final GetPhotosUseCase getPhotosUseCase;
  final AddPhotoUseCase addPhotoUseCase;

  PhotosBloc({
    required this.getPhotosUseCase,
    required this.addPhotoUseCase,
  }) : super(const PhotosInitial()) {
    on<FetchPhotos>((event, emit) async {
      emit(const PhotosLoading());
      final result = await getPhotosUseCase(event.userId);
      emit(result.fold(
        (failure) => PhotosError(failure.message),
        (photos) => PhotosLoaded(photos),
      ));
    });

    on<UploadPhoto>((event, emit) async {
      emit(const PhotosLoading());
      final result = await addPhotoUseCase(event.userId, event.image);
      emit(result.fold(
        (failure) => PhotosError(failure.message),
        (photo) => PhotosLoaded([photo]), 
      ));
    });
  }
}
