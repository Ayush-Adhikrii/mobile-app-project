// lib/features/photos/domain/usecases/get_photos_usecase.dart
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entity/photo_entity.dart';
import '../repository/photos_repository.dart';

class GetPhotosUseCase {
  final IPhotosRepository repository;

  GetPhotosUseCase(this.repository);

  Future<Either<Failure, List<PhotoEntity>>> call(String userId) async {
    return await repository.getPhotos(userId);
  }
}
