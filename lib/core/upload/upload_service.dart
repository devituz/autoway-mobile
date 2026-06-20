import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import '../error/exceptions.dart';
import '../error/failures.dart';
import '../network/dio_client.dart';

/// App-wide image upload (`POST /v1/uploads/image`). Reusable by any feature
/// (profile avatars, notifications, listings, …) — pass the target [folder].
///
/// Lives in core (not the auth feature) so it isn't coupled to authentication.
class UploadService {
  final DioClient _client;

  UploadService(this._client);

  /// Uploads [filePath] under [folder] (e.g. `avatars`, `notifications`,
  /// `news`) and returns the public URL.
  Future<Either<Failure, String>> uploadImage(
    String filePath, {
    required String folder,
  }) async {
    try {
      final form = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
        'folder': folder,
      });
      final res = await _client.post<Map<String, dynamic>>(
        AppConstants.uploadImage,
        data: form,
      );
      final data = res.data?['data'];
      final url = data is Map ? data['url'] as String? : null;
      if (url == null || url.isEmpty) {
        return const Left(ServerFailure('Rasm yuklanmadi'));
      }
      return Right(url);
    } on DioException catch (e) {
      // ErrorInterceptor wraps the typed exception in DioException.error.
      final inner = e.error;
      if (inner is NetworkException) return Left(NetworkFailure(inner.message));
      if (inner is ServerException) return Left(ServerFailure(inner.message));
      return const Left(ServerFailure());
    } catch (_) {
      return const Left(ServerFailure());
    }
  }
}
