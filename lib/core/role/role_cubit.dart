import 'package:flutter_bloc/flutter_bloc.dart';

import 'role_storage.dart';

/// App-wide role switch: 0 = passenger (Yo'lovchi), 1 = driver (Haydovchi).
///
/// A single instance is provided at the app root so the Home toggle, the main
/// shell and the Profile tab all read/write the same value. The choice is
/// persisted via [RoleStorage] — re-launching the app keeps the last role, and
/// switching to Haydovchi flips the Profile tab to the driver screen.
class RoleCubit extends Cubit<int> {
  final RoleStorage _storage;

  RoleCubit(this._storage) : super(_storage.role);

  bool get isDriver => state == 1;

  void setRole(int role) {
    if (role == state) return;
    _storage.save(role);
    emit(role);
  }
}
