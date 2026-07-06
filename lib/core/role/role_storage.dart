import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

/// Persists the active app role (passenger vs driver) so the Home toggle choice
/// survives app restarts. 0 = passenger (Yo'lovchi), 1 = driver (Haydovchi).
class RoleStorage {
  final SharedPreferences _prefs;

  RoleStorage(this._prefs);

  int get role => _prefs.getInt(AppConstants.roleKey) ?? 0;

  Future<void> save(int role) => _prefs.setInt(AppConstants.roleKey, role);
}
