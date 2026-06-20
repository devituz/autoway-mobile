import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/data/models/auth_models.dart';

part 'profile_state.freezed.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  saving,
  saved,
  loggedOut,
  failure,
}

/// State for the profile screens (load /me, edit, logout).
@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(ProfileStatus.initial) ProfileStatus status,
    AuthUser? user,
    String? errorMessage,
  }) = _ProfileState;
}
