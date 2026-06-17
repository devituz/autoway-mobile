/// Application-wide constant values.
///
/// Keep network endpoints, timeouts and storage keys centralized here so they
/// are not duplicated (and silently diverge) across the codebase.
class AppConstants {
  AppConstants._();

  // Network
  static const String baseUrl = 'https://api.autoway.uz/v1';
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Local storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String localeKey = 'locale';
}
