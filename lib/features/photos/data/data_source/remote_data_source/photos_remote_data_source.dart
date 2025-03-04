// lib/features/photos/data/datasources/photos_remote_datasource.dart
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../../app/constants/api_endpoints.dart';
import '../../model/photo_model.dart';

abstract class IPhotosRemoteDataSource {
  Future<List<PhotoModel>> getPhotos(String userId);
  Future<PhotoModel> addPhoto(String userId, File image);
}

class PhotosRemoteDataSource implements IPhotosRemoteDataSource {
  final Dio _dio;

  PhotosRemoteDataSource(this._dio);

  @override
  Future<List<PhotoModel>> getPhotos(String userId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.baseUrl}photos/$userId');
      print('getPhotos response: ${response.statusCode}, ${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data ?? [];
        return data
            .where((item) => item != null) // Filter out nulls
            .map((item) {
          if (item is String) {
            // Handle legacy string-only response
            return PhotoModel(id: "", userId: userId, image: item);
          } else if (item is Map<String, dynamic>) {
            return PhotoModel.fromJson(item);
          }
          throw Exception('Invalid photo item: $item');
        }).toList();
      } else {
        throw Exception('Failed to fetch photos: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print(
          'DioException in getPhotos: ${e.message}, Response: ${e.response?.data}');
      throw Exception('Failed to fetch photos: ${e.message}');
    } catch (e) {
      print('Unexpected error in getPhotos: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<PhotoModel> addPhoto(String userId, File image) async {
    try {
      // Step 1: Upload the image to /photos/uploadPhoto
      final String fileName = image.path.split('/').last;
      final FormData formData = FormData.fromMap({
        'userId': userId,
        'userPhoto':
            await MultipartFile.fromFile(image.path, filename: fileName),
      });
      final uploadResponse = await _dio.post(
        '${ApiEndpoints.baseUrl}photos/uploadPhoto',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      print(
          'uploadPhoto response: ${uploadResponse.statusCode}, ${uploadResponse.data}');
      if (uploadResponse.statusCode != 200) {
        throw Exception(
            'Failed to upload photo: ${uploadResponse.statusMessage}');
      }

      final String imageName =
          uploadResponse.data['data'] as String; // Image name from response
      print("imageagterupload $imageName");

      // Step 2: Save metadata to /photos
      final saveResponse = await _dio.post(
        '${ApiEndpoints.baseUrl}photos',
        data: {
          'userId': userId,
          'image': imageName, // Use the returned image name
        },
      );
      print(
          'addPhoto response: ${saveResponse.statusCode}, ${saveResponse.data}');
      if (saveResponse.statusCode == 200 || saveResponse.statusCode == 201) {
        return PhotoModel.fromJson(saveResponse.data);
      } else {
        throw Exception('Failed to save photo: ${saveResponse.statusMessage}');
      }
    } on DioException catch (e) {
      print(
          'DioException in addPhoto: ${e.message}, Response: ${e.response?.data}');
      throw Exception('Failed to add photo: ${e.message}');
    } catch (e) {
      print('Unexpected error in addPhoto: $e');
      throw Exception('Unexpected error: $e');
    }
  }
}
