// lib/features/photos/presentation/bloc/photos_event.dart
import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class PhotosEvent extends Equatable {
  const PhotosEvent();

  @override
  List<Object?> get props => [];
}

class FetchPhotos extends PhotosEvent {
  final String userId;

  const FetchPhotos(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UploadPhoto extends PhotosEvent {
  final String userId;
  final File image;

  const UploadPhoto(this.userId, this.image);

  @override
  List<Object?> get props => [userId, image];
}

