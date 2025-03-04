
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';

import '../entity/photo_entity.dart';
import '../repository/photos_repository.dart';

class AddPhotoUseCase {
  final IPhotosRepository repository;

  AddPhotoUseCase(this.repository);

  Future<Either<Failure, PhotoEntity>> call(String userId, File image) async {
    return await repository.addPhoto(userId, image);
  }
}