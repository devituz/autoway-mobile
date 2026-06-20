import 'package:dio/dio.dart';

import '../../error/exceptions.dart';

/// Translates low-level [DioException]s into the app's typed exceptions so the
/// data layer can map them to `Failure`s without inspecting Dio internals.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError =>
        const NetworkException(),
      DioExceptionType.badResponse => ServerException(_messageFor(err.response)),
      _ => const ServerException(),
    };

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: exception,
      ),
    );
  }

  String _messageFor(Response? response) {
    final data = response?.data;
    // Backend wraps errors in {error: {code, message}}.
    if (data is Map) {
      final error = data['error'];
      if (error is Map && error['message'] is String) {
        return error['message'] as String;
      }
      if (data['message'] is String) return data['message'] as String;
    }
    return 'Serverda xatolik yuz berdi (${response?.statusCode ?? '-'})';
  }
}
