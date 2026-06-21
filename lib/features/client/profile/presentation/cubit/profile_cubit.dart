import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/upload/upload_service.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import 'profile_state.dart';

/// Drives the profile screens: loads `/me`, saves edits (`PUT /me`) and logs out.
/// A single instance is shared across the main shell and the edit screen.
class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository _repository;
  final UploadService _uploadService;

  ProfileCubit(this._repository, this._uploadService)
      : super(const ProfileState());

  /// Loads the current user. Skips the network call if already loaded so
  /// re-entering the Profile tab doesn't flash a spinner.
  Future<void> load({bool force = false}) async {
    if (!force && state.user != null) return;
    emit(state.copyWith(status: ProfileStatus.loading, errorMessage: null));
    final res = await _repository.getMe();
    res.fold(
      (f) => emit(state.copyWith(
          status: ProfileStatus.failure, errorMessage: f.message)),
      (user) => emit(state.copyWith(status: ProfileStatus.loaded, user: user)),
    );
  }

  /// Picks-then-uploads happen in the UI; this just uploads the chosen file and
  /// keeps the returned URL (+ local path for preview) for the next save.
  Future<void> uploadAvatar(String filePath) async {
    emit(state.copyWith(
        status: ProfileStatus.uploadingAvatar,
        avatarLocalPath: filePath,
        errorMessage: null));
    final res = await _uploadService.uploadImage(filePath, folder: 'avatars');
    res.fold(
      (f) => emit(state.copyWith(
          status: ProfileStatus.failure, errorMessage: f.message)),
      (url) => emit(state.copyWith(
          status: ProfileStatus.avatarUploaded, avatarUrl: url)),
    );
  }

  Future<void> updateProfile({
    String? fullName,
    String? birthDate,
    String? gender,
    String? avatarUrl,
  }) async {
    emit(state.copyWith(status: ProfileStatus.saving, errorMessage: null));
    final res = await _repository.updateProfile(
      fullName: fullName,
      birthDate: birthDate,
      gender: gender,
      // Fall back to the avatar uploaded earlier in this edit session.
      avatarUrl: avatarUrl ?? state.avatarUrl,
    );
    res.fold(
      (f) => emit(state.copyWith(
          status: ProfileStatus.failure, errorMessage: f.message)),
      (r) => emit(state.copyWith(status: ProfileStatus.saved, user: r.user)),
    );
  }

  /// Add [amount] to the local balance so the Profile reflects a top-up
  /// immediately. NOTE: the backend has no top-up endpoint yet, so this is a
  /// client-side (demo) increment; a real /me refresh would re-sync it.
  void topUp(num amount) {
    final user = state.user;
    if (user == null || amount <= 0) return;
    emit(state.copyWith(user: user.copyWith(balance: user.balance + amount)));
  }

  Future<void> logout() async {
    emit(state.copyWith(status: ProfileStatus.loading, errorMessage: null));
    // Even if the server call fails, the local session is cleared by the
    // repository; treat it as logged out so the user isn't stuck.
    await _repository.logout();
    emit(const ProfileState(status: ProfileStatus.loggedOut));
  }

  /// Re-arms transient statuses (saved/failure) after a screen consumes them.
  void clearStatus() => emit(state.copyWith(
      status: state.user != null ? ProfileStatus.loaded : ProfileStatus.initial,
      errorMessage: null));
}
