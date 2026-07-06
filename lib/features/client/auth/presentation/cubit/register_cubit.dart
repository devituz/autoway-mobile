import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/auth_repository.dart';
import 'register_state.dart';

/// Holds the data collected step-by-step during registration AND drives the
/// two async auth calls (request OTP → verify). Form mutations are plain CRUD;
/// the network actions emit [AuthStatus] transitions the screens listen to.
class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _repository;

  RegisterCubit(this._repository) : super(const RegisterState());

  void setLanguage(String language) => emit(state.copyWith(language: language));

  void setUserType(UserType type) => emit(state.copyWith(userType: type));

  void setPhone(String phone) => emit(state.copyWith(phone: phone));

  void setOtp(String otp) => emit(state.copyWith(otp: otp));

  void setFirstName(String firstName) =>
      emit(state.copyWith(firstName: firstName));

  void setLastName(String lastName) =>
      emit(state.copyWith(lastName: lastName));

  void setBirthDate(String date) => emit(state.copyWith(birthDate: date));

  void setGender(Gender gender) => emit(state.copyWith(gender: gender));

  /// Resets the transient status so a screen can re-arm its BlocListener.
  void resetStatus() =>
      emit(state.copyWith(status: AuthStatus.initial, errorMessage: null));

  /// E.164 phone (`+998901112233`) from the 9 stored national digits.
  String get _e164Phone => '+998${state.phone}';

  /// Step 0+1 — check the phone, then for an existing user send the login OTP
  /// ([AuthStatus.codeSent] → OTP screen). A new user needs a profile first
  /// ([AuthStatus.needProfile] → profile screen).
  Future<void> submitPhone() async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    final check = await _repository.check(_e164Phone);
    await check.fold(
      (failure) async => emit(state.copyWith(
          status: AuthStatus.failure, errorMessage: failure.message)),
      (result) async {
        emit(state.copyWith(isRegistered: result.isRegistered));
        if (!result.isRegistered) {
          emit(state.copyWith(status: AuthStatus.needProfile));
          return;
        }
        final otp = await _repository.loginRequest(_e164Phone);
        otp.fold(
          (failure) => emit(state.copyWith(
              status: AuthStatus.failure, errorMessage: failure.message)),
          (_) => emit(state.copyWith(status: AuthStatus.codeSent)),
        );
      },
    );
  }

  /// REGISTER 1/2 — submit the collected profile, which creates the account and
  /// sends the OTP ([AuthStatus.codeSent] → OTP screen).
  Future<void> submitProfile() async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    final res = await _repository.registerRequest(
      phone: _e164Phone,
      firstName: state.firstName.trim(),
      lastName: state.lastName.trim(),
      birthDate: _normalizeBirthDate(state.birthDate),
      gender: state.gender?.name ?? 'male',
      role: _role,
    );
    res.fold(
      (failure) => emit(state.copyWith(
          status: AuthStatus.failure, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: AuthStatus.codeSent)),
    );
  }

  /// Resend the OTP from the OTP screen. By this point the account always
  /// exists (login user, or just created by register/request), so a plain
  /// login OTP is correct — and it emits NO status, so the underlying screens
  /// don't navigate again.
  Future<void> resendOtp() => _repository.loginRequest(_e164Phone);

  /// Step 2 — verify the code (login & register both) → tokens persisted.
  Future<void> verify() async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    final res = await _repository.verify(phone: _e164Phone, code: state.otp);
    res.fold(
      (failure) => emit(state.copyWith(
          status: AuthStatus.failure, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: AuthStatus.success)),
    );
  }

  /// Maps the selected account type to the backend `role` value.
  String get _role => state.userType == UserType.driver ? 'driver' : 'client';

  /// Backend expects ISO `yyyy-MM-dd`. The form accepts `dd.mm.yyyy` (and
  /// `dd/mm/yyyy`); anything already ISO or unrecognized is passed through.
  String _normalizeBirthDate(String input) {
    final m = RegExp(r'^(\d{2})[./](\d{2})[./](\d{4})$').firstMatch(input.trim());
    if (m != null) return '${m.group(3)}-${m.group(2)}-${m.group(1)}';
    return input.trim();
  }
}
