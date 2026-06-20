import 'package:dio/dio.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/dio_client.dart';
import '../models/auth_models.dart';

/// Raw HTTP access to the auth endpoints. Unwraps the `{data, ...}` envelope
/// and maps any failure to the app's typed exceptions (the [DioClient]'s
/// [ErrorInterceptor] already converts Dio errors into [ServerException] /
/// [NetworkException]).
class AuthRemoteDataSource {
  final DioClient _client;

  AuthRemoteDataSource(this._client);

  /// Step 1 — send the phone number, receive an SMS code.
  Future<RequestOtpResult> requestOtp(String phone) async {
    final res = await _client.post<Map<String, dynamic>>(
      AppConstants.authRequest,
      data: {'phone': phone},
    );
    return RequestOtpResult.fromJson(_data(res));
  }

  /// Step 2 — verify the code. For a new user pass [fullName]/[birthDate]/
  /// [gender]/[role] (REGISTER); for an existing one omit them (LOGIN).
  Future<AuthTokens> verify({
    required String phone,
    required String code,
    String? fullName,
    String? birthDate,
    String? gender,
    String? role,
  }) async {
    final body = <String, dynamic>{'phone': phone, 'code': code};
    if (fullName != null) body['full_name'] = fullName;
    if (birthDate != null) body['birth_date'] = birthDate;
    if (gender != null) body['gender'] = gender;
    if (role != null) body['role'] = role;

    final res = await _client.post<Map<String, dynamic>>(
      AppConstants.authVerify,
      data: body,
    );
    return AuthTokens.fromJson(_data(res));
  }

  /// Step 3 — rotate tokens using the refresh token.
  Future<AuthTokens> refresh(String refreshToken) async {
    final res = await _client.post<Map<String, dynamic>>(
      AppConstants.authRefresh,
      data: {'refresh_token': refreshToken},
    );
    return AuthTokens.fromJson(_data(res));
  }

  /// Step 4 — invalidate the current session server-side.
  Future<void> logout() => _client.post<dynamic>(AppConstants.authLogout);

  /// Pull the `data` object out of the response envelope.
  Map<String, dynamic> _data(Response<Map<String, dynamic>> res) {
    final body = res.data;
    final data = body?['data'];
    if (data is Map<String, dynamic>) return data;
    throw const ServerException('Serverdan noto‘g‘ri javob keldi');
  }
}
