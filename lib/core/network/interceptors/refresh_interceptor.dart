import 'package:dio/dio.dart';

import '../../constants/app_constants.dart';
import '../../storage/token_storage.dart';

/// On a 401, rotates the access token via `/v1/auth/refresh` and retries the
/// original request once. Uses a bare [Dio] (no interceptors) for the refresh
/// call so it can't recurse. If refresh fails, tokens are cleared so the app
/// falls back to the login flow.
class RefreshInterceptor extends QueuedInterceptor {
  final TokenStorage _tokenStorage;
  final Dio _bareDio;

  RefreshInterceptor(this._tokenStorage)
      : _bareDio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl));

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final response = err.response;
    final path = err.requestOptions.path;
    final isAuthCall = path.contains('/auth/');
    final alreadyRetried = err.requestOptions.extra['__retried'] == true;

    if (response?.statusCode != 401 || isAuthCall || alreadyRetried) {
      return handler.next(err);
    }

    final refreshToken = _tokenStorage.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      await _tokenStorage.clear();
      return handler.next(err);
    }

    try {
      final res = await _bareDio.post<Map<String, dynamic>>(
        AppConstants.authRefresh,
        data: {'refresh_token': refreshToken},
      );
      final data = res.data?['data'] as Map<String, dynamic>?;
      final access = data?['access_token'] as String?;
      final refresh = data?['refresh_token'] as String?;
      if (access == null || access.isEmpty) {
        await _tokenStorage.clear();
        return handler.next(err);
      }
      await _tokenStorage.saveTokens(
        accessToken: access,
        refreshToken: refresh ?? refreshToken,
      );

      // Retry the original request with the new token.
      final req = err.requestOptions;
      req.extra['__retried'] = true;
      req.headers['Authorization'] = 'Bearer $access';
      final retry = await _bareDio.fetch<dynamic>(req);
      return handler.resolve(retry);
    } catch (_) {
      await _tokenStorage.clear();
      return handler.next(err);
    }
  }
}
