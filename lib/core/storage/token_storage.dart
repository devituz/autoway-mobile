import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

/// Thin wrapper around [SharedPreferences] for auth tokens.
///
/// Centralizing token access keeps the [AuthInterceptor] and auth feature
/// from touching storage keys directly.
class TokenStorage {
  final SharedPreferences _prefs;

  TokenStorage(this._prefs);

  String? get accessToken => _prefs.getString(AppConstants.accessTokenKey);

  String? get refreshToken => _prefs.getString(AppConstants.refreshTokenKey);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _prefs.setString(AppConstants.accessTokenKey, accessToken);
    await _prefs.setString(AppConstants.refreshTokenKey, refreshToken);
  }

  Future<void> clear() async {
    await _prefs.remove(AppConstants.accessTokenKey);
    await _prefs.remove(AppConstants.refreshTokenKey);
  }
}
