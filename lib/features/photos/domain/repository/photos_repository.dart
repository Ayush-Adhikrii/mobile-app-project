// lib/features/photos/domain/repositories/photos_repository.dart
import 'package:dartz/dartz.dart';

import 'dart:io';
import '../../../../core/error/failure.dart';
import '../../data/data_source/remote_data_source/photos_remote_data_source.dart';
import '../entity/photo_entity.dart';

abstract class IPhotosRepository {
  Future<Either<Failure, List<PhotoEntity>>> getPhotos(String userId);
  Future<Either<Failure, PhotoEntity>> addPhoto(String userId, File image);
}

class PhotosRepository implements IPhotosRepository {
  final IPhotosRemoteDataSource remoteDataSource;

  PhotosRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, List<PhotoEntity>>> getPhotos(String userId) async {
    try {
      final photos = await remoteDataSource.getPhotos(userId);
      return Right(photos);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PhotoEntity>> addPhoto(String userId, File image) async {
    try {
      final photo = await remoteDataSource.addPhoto(userId, image);
      return Right(photo);
    } catch (e) {
      return Left(ApiFailure(message:  e.toString()));
    }
  }
}