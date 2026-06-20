import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/data/models/auth_models.dart';

part 'profile_state.freezed.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  saving,
  saved,
  uploadingAvatar,
  avatarUploaded,
  loggedOut,
  failure,
}

/// State for the profile screens (load /me, edit, logout).
@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(ProfileStatus.initial) ProfileStatus status,
    AuthUser? user,
    // Avatar uploaded during edit, pending the PUT /me save. Also the local
    // file path for instant preview before the upload finishes.
    String? avatarUrl,
    String? avatarLocalPath,
    String? errorMessage,
  }) = _ProfileState;
}
