import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repository/auth_repository.dart';

class UploadImageParams {
  final File file;

  const UploadImageParams({required this.file});

  // Corrected empty constructor
  static UploadImageParams empty = UploadImageParams(file: File(''));
}

class UploadImageUsecase
    implements UsecaseWithParams<String, UploadImageParams> {
  final IAuthRepository repository;

  UploadImageUsecase({required this.repository});

  @override
  Future<Either<Failure, String>> call(UploadImageParams params) {
    return repository.uploadProfilePicture(params.file);
  }
}
