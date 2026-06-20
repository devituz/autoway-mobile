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

  /// Step 0 — is this phone already registered? Decides login vs register.
  Future<CheckPhoneResult> check(String phone) async {
    final res = await _client.post<Map<String, dynamic>>(
      AppConstants.authCheck,
      data: {'phone': phone},
    );
    return CheckPhoneResult.fromJson(_data(res));
  }

  /// LOGIN 1/2 — send an SMS code to an existing user's phone.
  Future<RequestOtpResult> loginRequest(String phone) async {
    final res = await _client.post<Map<String, dynamic>>(
      AppConstants.authLoginRequest,
      data: {'phone': phone},
    );
    return RequestOtpResult.fromJson(_data(res));
  }

  /// REGISTER 1/2 — create the account (profile) and send an SMS code.
  Future<RequestOtpResult> registerRequest({
    required String phone,
    required String fullName,
    required String birthDate,
    required String gender,
    required String role,
  }) async {
    final res = await _client.post<Map<String, dynamic>>(
      AppConstants.authRegisterRequest,
      data: {
        'phone': phone,
        'full_name': fullName,
        'birth_date': birthDate,
        'gender': gender,
        'role': role,
      },
    );
    return RequestOtpResult.fromJson(_data(res));
  }

  /// Step 2 — verify the code (both login & register) → tokens. Profile is no
  /// longer sent here; it was provided in register/request.
  Future<AuthTokens> verify({
    required String phone,
    required String code,
  }) async {
    final res = await _client.post<Map<String, dynamic>>(
      AppConstants.authVerify,
      data: {'phone': phone, 'code': code},
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

  /// Upload an image to object storage (`POST /v1/uploads/image`, multipart).
  /// Returns the public URL (response `data.url`).
  Future<String> uploadImage(String filePath) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final res = await _client.post<Map<String, dynamic>>(
      AppConstants.uploadImage,
      data: form,
    );
    final data = _data(res);
    final url = data['url'] as String?;
    if (url == null || url.isEmpty) {
      throw const ServerException('Rasm yuklanmadi');
    }
    return url;
  }

  /// Current user profile (`GET /v1/me`).
  Future<AuthUser> getMe() async {
    final res = await _client.get<Map<String, dynamic>>(AppConstants.me);
    return AuthUser.fromJson(_data(res));
  }

  /// Update profile (`PUT /v1/me`). Pass only the fields being changed; a phone
  /// change additionally needs [otp]. Returns the updated user + whether the
  /// phone actually changed.
  Future<({AuthUser user, bool phoneChanged})> updateProfile({
    String? fullName,
    String? birthDate,
    String? gender,
    String? avatarUrl,
    String? phone,
    String? otp,
  }) async {
    final body = <String, dynamic>{};
    if (fullName != null) body['full_name'] = fullName;
    if (birthDate != null) body['birth_date'] = birthDate;
    if (gender != null) body['gender'] = gender;
    if (avatarUrl != null) body['avatar_url'] = avatarUrl;
    if (phone != null) body['phone'] = phone;
    if (otp != null) body['otp'] = otp;

    final res = await _client.put<Map<String, dynamic>>(
      AppConstants.me,
      data: body,
    );
    final data = _data(res);
    return (
      user: AuthUser.fromJson(data['user'] as Map<String, dynamic>),
      phoneChanged: data['phone_changed'] as bool? ?? false,
    );
  }

  /// Pull the `data` object out of the response envelope.
  Map<String, dynamic> _data(Response<Map<String, dynamic>> res) {
    final body = res.data;
    final data = body?['data'];
    if (data is Map<String, dynamic>) return data;
    throw const ServerException('Serverdan noto‘g‘ri javob keldi');
  }
}
