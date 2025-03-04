// lib/features/photos/presentation/bloc/photos_state.dart
import 'package:equatable/equatable.dart';

import '../../../domain/entity/photo_entity.dart';

abstract class PhotosState extends Equatable {
  const PhotosState();

  @override
  List<Object?> get props => [];
}

class PhotosInitial extends PhotosState {
  const PhotosInitial();
}

class PhotosLoading extends PhotosState {
  const PhotosLoading();
}

class PhotosLoaded extends PhotosState {
  final List<PhotoEntity> photos;

  const PhotosLoaded(this.photos);

  @override
  List<Object?> get props => [photos];
}

class PhotosError extends PhotosState {
  final String message;

  const PhotosError(this.message);

  @override
  List<Object?> get props => [message];
}
