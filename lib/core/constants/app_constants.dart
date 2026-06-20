/// Application-wide constant values.
///
/// Keep network endpoints, timeouts and storage keys centralized here so they
/// are not duplicated (and silently diverge) across the codebase.
class AppConstants {
  AppConstants._();

  // Network — Taxi backend (Gin). Envelope: {data, error, meta, request_id}.
  static const String baseUrl = 'https://vio.delgo.uz/api';
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Auth endpoints (relative to baseUrl). Flow:
  //   check -> (login/request | register/request) -> verify -> tokens
  static const String authCheck = '/v1/auth/check';
  static const String authLoginRequest = '/v1/auth/login/request';
  static const String authRegisterRequest = '/v1/auth/register/request';
  static const String authVerify = '/v1/auth/verify';
  static const String authRefresh = '/v1/auth/refresh';
  static const String authLogout = '/v1/auth/logout';
  static const String me = '/v1/me';
  static const String mePhoneRequest = '/v1/me/phone/request';
  static const String uploadImage = '/v1/uploads/image';

  // Local storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String localeKey = 'locale';
}
